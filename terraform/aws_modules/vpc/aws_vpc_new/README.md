# AWS VPC Terraform module

[![Help Contribute to Open Source](https://www.codetriage.com/terraform-aws-modules/terraform-aws-vpc/badges/users.svg)](https://www.codetriage.com/terraform-aws-modules/terraform-aws-vpc)

Terraform module which creates VPC resources on AWS.

These types of resources are supported:

* [VPC](https://www.terraform.io/docs/providers/aws/r/vpc.html)
* [Subnet](https://www.terraform.io/docs/providers/aws/r/subnet.html)
* [Route](https://www.terraform.io/docs/providers/aws/r/route.html)
* [Route table](https://www.terraform.io/docs/providers/aws/r/route_table.html)
* [Internet Gateway](https://www.terraform.io/docs/providers/aws/r/internet_gateway.html)
* [NAT Gateway](https://www.terraform.io/docs/providers/aws/r/nat_gateway.html)
* [VPN Gateway](https://www.terraform.io/docs/providers/aws/r/vpn_gateway.html)
* [VPC Endpoint](https://www.terraform.io/docs/providers/aws/r/vpc_endpoint.html) (S3 and DynamoDB)
* [RDS DB Subnet Group](https://www.terraform.io/docs/providers/aws/r/db_subnet_group.html)
* [ElastiCache Subnet Group](https://www.terraform.io/docs/providers/aws/r/elasticache_subnet_group.html)
* [Redshift Subnet Group](https://www.terraform.io/docs/providers/aws/r/redshift_subnet_group.html)
* [DHCP Options Set](https://www.terraform.io/docs/providers/aws/r/vpc_dhcp_options.html)
* [Default VPC](https://www.terraform.io/docs/providers/aws/r/default_vpc.html)

## Usage

```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
```

## External NAT Gateway IPs

By default this module will provision new Elastic IPs for the VPC's NAT Gateways.
This means that when creating a new VPC, new IPs are allocated, and when that VPC is destroyed those IPs are released.
Sometimes it is handy to keep the same IPs even after the VPC is destroyed and re-created.
To that end, it is possible to assign existing IPs to the NAT Gateways.
This prevents the destruction of the VPC from releasing those IPs, while making it possible that a re-created VPC uses the same IPs.

To achieve this, allocate the IPs outside the VPC module declaration.
```hcl
resource "aws_eip" "nat" {
  count = 3

  vpc = true
}
```

Then, pass the allocated IPs as a parameter to this module.
```hcl
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  # The rest of arguments are omitted for brevity

  enable_nat_gateway  = true
  single_nat_gateway  = false
  reuse_nat_ips       = true                      # <= Skip creation of EIPs for the NAT Gateways
  external_nat_ip_ids = ["${aws_eip.nat.*.id}"]   # <= IPs specified here as input to the module
}
```

Note that in the example we allocate 3 IPs because we will be provisioning 3 NAT Gateways (due to `single_nat_gateway = false` and having 3 subnets).
If, on the other hand, `single_nat_gateway = true`, then `aws_eip.nat` would only need to allocate 1 IP.
Passing the IPs into the module is done by setting two variables `reuse_nat_ips = true` and `external_nat_ip_ids = ["${aws_eip.nat.*.id}"]`.

## NAT Gateway Scenarios

This module supports three scenarios for creating NAT gateways. Each will be explained in further detail in the corresponding sections.

* One NAT Gateway per subnet (default behavior)
    * `enable_nat_gateway = true`
    * `single_nat_gateway = false`
    * `one_nat_gateway_per_az = false`
* Single NAT Gateway
    * `enable_nat_gateway = true`
    * `single_nat_gateway = true`
    * `one_nat_gateway_per_az = false`
* One NAT Gateway per availability zone
    * `enable_nat_gateway = true`
    * `single_nat_gateway = false`
    * `one_nat_gateway_per_az = true`

If both `single_nat_gateway` and `one_nat_gateway_per_az` are set to `true`, then `single_nat_gateway` takes precedence.

### One NAT Gateway per subnet (default)

By default, the module will determine the number of NAT Gateways to create based on the the `max()` of the private subnet lists (`database_subnets`, `elasticache_subnets`, `private_subnets`, and `redshift_subnets`). The module **does not** take into account the number of `intra_subnets`, since the latter are designed to have no Internet access via NAT Gateway.  For example, if your configuration looks like the following:

```hcl
database_subnets    = ["10.0.21.0/24", "10.0.22.0/24"]
elasticache_subnets = ["10.0.31.0/24", "10.0.32.0/24"]
private_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
redshift_subnets    = ["10.0.41.0/24", "10.0.42.0/24"]
intra_subnets       = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
```

Then `5` NAT Gateways will be created since `5` private subnet CIDR blocks were specified.

### Single NAT Gateway

If `single_nat_gateway = true`, then all private subnets will route their Internet traffic through this single NAT gateway. The NAT gateway will be placed in the first public subnet in your `public_subnets` block.

### One NAT Gateway per availability zone

If `one_nat_gateway_per_az = true` and `single_nat_gateway = false`, then the module will place one NAT gateway in each availability zone you specify in `var.azs`. There are some requirements around using this feature flag:

* The variable `var.azs` **must** be specified.
* The number of public subnet CIDR blocks specified in `public_subnets` **must** be greater than or equal to the number of availability zones specified in `var.azs`. This is to ensure that each NAT Gateway has a dedicated public subnet to deploy to.

## "private" versus "intra" subnets

By default, if NAT Gateways are enabled, private subnets will be configured with routes for Internet traffic that point at the NAT Gateways configured by use of the above options.

If you need private subnets that should have no Internet routing (in the sense of [RFC1918 Category 1 subnets](https://tools.ietf.org/html/rfc1918)), `intra_subnets` should be specified. An example use case is configuration of AWS Lambda functions within a VPC, where AWS Lambda functions only need to pass traffic to internal resources or VPC endpoints for AWS services.
 
Since AWS Lambda functions allocate Elastic Network Interfaces in proportion to the traffic received ([read more](https://docs.aws.amazon.com/lambda/latest/dg/vpc.html)), it can be useful to allocate a large private subnet for such allocations, while keeping the traffic they generate entirely internal to the VPC.

You can add additional tags with `intra_subnet_tags` as with other subnet types.

## Conditional creation

Sometimes you need to have a way to create VPC resources conditionally but Terraform does not allow to use `count` inside `module` block, so the solution is to specify argument `create_vpc`.

```hcl
# This VPC will not be created
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  create_vpc = false
  # ... omitted
}
```

## Terraform version

Terraform version 0.10.3 or newer is required for this module to work.

## Examples

* [Simple VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/simple-vpc)
* [Complete VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/complete-vpc)
* [Manage Default VPC](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/manage-default-vpc)
* Few tests and edge cases examples: [#46](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/issue-46-no-private-subnets), [#44](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/issue-44-asymmetric-private-subnets), [#108](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/examples/issue-108-route-already-exists)

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| assign\_generated\_ipv6\_cidr\_block | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block | string | `"false"` | no |
| azs | A list of availability zones in the region | list | `[]` | no |
| cidr | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | string | `"0.0.0.0/0"` | no |
| create\_database\_subnet\_group | Controls if database subnet group should be created | string | `"true"` | no |
| create\_database\_subnet\_route\_table | Controls if separate route table for database should be created | string | `"false"` | no |
| create\_elasticache\_subnet\_route\_table | Controls if separate route table for elasticache should be created | string | `"false"` | no |
| create\_redshift\_subnet\_route\_table | Controls if separate route table for redshift should be created | string | `"false"` | no |
| create\_vpc | Controls if VPC should be created (it affects almost all resources) | string | `"true"` | no |
| database\_route\_table\_tags | Additional tags for the database route tables | map | `{}` | no |
| database\_subnet\_group\_tags | Additional tags for the database subnet group | map | `{}` | no |
| database\_subnet\_tags | Additional tags for the database subnets | map | `{}` | no |
| database\_subnets | A list of database subnets | list | `[]` | no |
| default\_vpc\_enable\_classiclink | Should be true to enable ClassicLink in the Default VPC | string | `"false"` | no |
| default\_vpc\_enable\_dns\_hostnames | Should be true to enable DNS hostnames in the Default VPC | string | `"false"` | no |
| default\_vpc\_enable\_dns\_support | Should be true to enable DNS support in the Default VPC | string | `"true"` | no |
| default\_vpc\_name | Name to be used on the Default VPC | string | `""` | no |
| default\_vpc\_tags | Additional tags for the Default VPC | map | `{}` | no |
| dhcp\_options\_domain\_name | Specifies DNS name for DHCP options set | string | `""` | no |
| dhcp\_options\_domain\_name\_servers | Specify a list of DNS server addresses for DHCP options set, default to AWS provided | list | `[ "AmazonProvidedDNS" ]` | no |
| dhcp\_options\_netbios\_name\_servers | Specify a list of netbios servers for DHCP options set | list | `[]` | no |
| dhcp\_options\_netbios\_node\_type | Specify netbios node_type for DHCP options set | string | `""` | no |
| dhcp\_options\_ntp\_servers | Specify a list of NTP servers for DHCP options set | list | `[]` | no |
| dhcp\_options\_tags | Additional tags for the DHCP option set | map | `{}` | no |
| elasticache\_route\_table\_tags | Additional tags for the elasticache route tables | map | `{}` | no |
| elasticache\_subnet\_tags | Additional tags for the elasticache subnets | map | `{}` | no |
| elasticache\_subnets | A list of elasticache subnets | list | `[]` | no |
| enable\_dhcp\_options | Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type | string | `"false"` | no |
| enable\_dns\_hostnames | Should be true to enable DNS hostnames in the VPC | string | `"false"` | no |
| enable\_dns\_support | Should be true to enable DNS support in the VPC | string | `"true"` | no |
| enable\_dynamodb\_endpoint | Should be true if you want to provision a DynamoDB endpoint to the VPC | string | `"false"` | no |
| enable\_nat\_gateway | Should be true if you want to provision NAT Gateways for each of your private networks | string | `"false"` | no |
| enable\_s3\_endpoint | Should be true if you want to provision an S3 endpoint to the VPC | string | `"false"` | no |
| enable\_vpn\_gateway | Should be true if you want to create a new VPN Gateway resource and attach it to the VPC | string | `"false"` | no |
| external\_nat\_ip\_ids | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse_nat_ips) | list | `[]` | no |
| igw\_tags | Additional tags for the internet gateway | map | `{}` | no |
| instance\_tenancy | A tenancy option for instances launched into the VPC | string | `"default"` | no |
| intra\_route\_table\_tags | Additional tags for the intra route tables | map | `{}` | no |
| intra\_subnet\_tags | Additional tags for the intra subnets | map | `{}` | no |
| intra\_subnets | A list of intra subnets | list | `[]` | no |
| manage\_default\_vpc | Should be true to adopt and manage Default VPC | string | `"false"` | no |
| map\_public\_ip\_on\_launch | Should be false if you do not want to auto-assign public IP on launch | string | `"true"` | no |
| name | Name to be used on all the resources as identifier | string | `""` | no |
| nat\_eip\_tags | Additional tags for the NAT EIP | map | `{}` | no |
| nat\_gateway\_tags | Additional tags for the NAT gateways | map | `{}` | no |
| one\_nat\_gateway\_per\_az | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`. | string | `"false"` | no |
| private\_route\_table\_tags | Additional tags for the private route tables | map | `{}` | no |
| private\_subnet\_tags | Additional tags for the private subnets | map | `{}` | no |
| private\_subnets | A list of private subnets inside the VPC | list | `[]` | no |
| propagate\_private\_route\_tables\_vgw | Should be true if you want route table propagation | string | `"false"` | no |
| propagate\_public\_route\_tables\_vgw | Should be true if you want route table propagation | string | `"false"` | no |
| public\_route\_table\_tags | Additional tags for the public route tables | map | `{}` | no |
| public\_subnet\_tags | Additional tags for the public subnets | map | `{}` | no |
| public\_subnets | A list of public subnets inside the VPC | list | `[]` | no |
| redshift\_route\_table\_tags | Additional tags for the redshift route tables | map | `{}` | no |
| redshift\_subnet\_group\_tags | Additional tags for the redshift subnet group | map | `{}` | no |
| redshift\_subnet\_tags | Additional tags for the redshift subnets | map | `{}` | no |
| redshift\_subnets | A list of redshift subnets | list | `[]` | no |
| reuse\_nat\_ips | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external_nat_ip_ids' variable | string | `"false"` | no |
| single\_nat\_gateway | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | string | `"false"` | no |
| tags | A map of tags to add to all resources | map | `{}` | no |
| vpc\_id | Controls if VPC should be created (it affects almost all resources) | string | `""` | no |
| vpc\_tags | Additional tags for the VPC | map | `{}` | no |
| vpn\_gateway\_id | ID of VPN Gateway to attach to the VPC | string | `""` | no |
| vpn\_gateway\_tags | Additional tags for the VPN gateway | map | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| database\_route\_table\_ids | List of IDs of database route tables |
| database\_subnet\_group | ID of database subnet group |
| database\_subnets | List of IDs of database subnets |
| database\_subnets\_cidr\_blocks | List of cidr_blocks of database subnets |
| default\_network\_acl\_id | The ID of the default network ACL |
| default\_route\_table\_id | The ID of the default route table |
| default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| default\_vpc\_cidr\_block | The CIDR block of the VPC |
| default\_vpc\_default\_network\_acl\_id | The ID of the default network ACL |
| default\_vpc\_default\_route\_table\_id | The ID of the default route table |
| default\_vpc\_default\_security\_group\_id | The ID of the security group created by default on VPC creation |
| default\_vpc\_enable\_dns\_hostnames | Whether or not the VPC has DNS hostname support |
| default\_vpc\_enable\_dns\_support | Whether or not the VPC has DNS support |
| default\_vpc\_id | The ID of the VPC |
| default\_vpc\_instance\_tenancy | Tenancy of instances spin up within VPC |
| default\_vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |
| elasticache\_route\_table\_ids | List of IDs of elasticache route tables |
| elasticache\_subnet\_group | ID of elasticache subnet group |
| elasticache\_subnet\_group\_name | Name of elasticache subnet group |
| elasticache\_subnets | List of IDs of elasticache subnets |
| elasticache\_subnets\_cidr\_blocks | List of cidr_blocks of elasticache subnets |
| igw\_id | The ID of the Internet Gateway |
| intra\_route\_table\_ids | List of IDs of intra route tables |
| intra\_subnets | List of IDs of intra subnets |
| intra\_subnets\_cidr\_blocks | List of cidr_blocks of intra subnets |
| nat\_ids | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| nat\_public\_ips | List of public Elastic IPs created for AWS NAT Gateway |
| natgw\_ids | List of NAT Gateway IDs |
| private\_route\_table\_ids | List of IDs of private route tables |
| private\_subnets | List of IDs of private subnets |
| private\_subnets\_cidr\_blocks | List of cidr_blocks of private subnets |
| public\_route\_table\_ids | List of IDs of public route tables |
| public\_subnets | List of IDs of public subnets |
| public\_subnets\_cidr\_blocks | List of cidr_blocks of public subnets |
| redshift\_route\_table\_ids | List of IDs of redshift route tables |
| redshift\_subnet\_group | ID of redshift subnet group |
| redshift\_subnets | List of IDs of redshift subnets |
| redshift\_subnets\_cidr\_blocks | List of cidr_blocks of redshift subnets |
| vgw\_id | The ID of the VPN Gateway |
| vpc\_cidr\_block | The CIDR block of the VPC |
| vpc\_enable\_dns\_hostnames | Whether or not the VPC has DNS hostname support |
| vpc\_enable\_dns\_support | Whether or not the VPC has DNS support |
| vpc\_endpoint\_dynamodb\_id | The ID of VPC endpoint for DynamoDB |
| vpc\_endpoint\_dynamodb\_pl\_id | The prefix list for the DynamoDB VPC endpoint. |
| vpc\_endpoint\_s3\_id | The ID of VPC endpoint for S3 |
| vpc\_endpoint\_s3\_pl\_id | The prefix list for the S3 VPC endpoint. |
| vpc\_id | The ID of the VPC |
| vpc\_instance\_tenancy | Tenancy of instances spin up within VPC |
| vpc\_main\_route\_table\_id | The ID of the main route table associated with this VPC |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Tests

This module has been packaged with [awspec](https://github.com/k1LoW/awspec) tests through test kitchen. To run them:

1. Install [rvm](https://rvm.io/rvm/install) and the ruby version specified in the [Gemfile](https://github.com/terraform-aws-modules/terraform-aws-vpc/tree/master/Gemfile).
2. Install bundler and the gems from our Gemfile:
```
gem install bundler; bundle install
```
3. Test using `bundle exec kitchen test` from the root of the repo.


## Authors

Module is maintained by [Anton Babenko](https://github.com/antonbabenko) with help from [these awesome contributors](https://github.com/terraform-aws-modules/terraform-aws-vpc/graphs/contributors).

## License

Apache 2 Licensed. See LICENSE for full details.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_subnet_group.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_subnet_group) | resource |
| [aws_default_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/default_vpc) | resource |
| [aws_eip.nat](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_elasticache_subnet_group.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/elasticache_subnet_group) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_redshift_subnet_group.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/redshift_subnet_group) | resource |
| [aws_route.private_nat_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.intra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.intra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_subnet.database](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.elasticache](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.intra](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.redshift](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_vpc_dhcp_options.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options) | resource |
| [aws_vpc_dhcp_options_association.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_dhcp_options_association) | resource |
| [aws_vpc_endpoint.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.intra_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.intra_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.private_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.private_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.public_dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.public_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpn_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway) | resource |
| [aws_vpn_gateway_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_attachment) | resource |
| [aws_vpn_gateway_route_propagation.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_vpn_gateway_route_propagation.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpn_gateway_route_propagation) | resource |
| [aws_vpc_endpoint_service.dynamodb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |
| [aws_vpc_endpoint_service.s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint_service) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_assign_generated_ipv6_cidr_block"></a> [assign\_generated\_ipv6\_cidr\_block](#input\_assign\_generated\_ipv6\_cidr\_block) | Requests an Amazon-provided IPv6 CIDR block with a /56 prefix length for the VPC. You cannot specify the range of IP addresses, or the size of the CIDR block | `bool` | `false` | no |
| <a name="input_azs"></a> [azs](#input\_azs) | A list of availability zones in the region | `list` | `[]` | no |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden | `string` | `"0.0.0.0/0"` | no |
| <a name="input_create_database_subnet_group"></a> [create\_database\_subnet\_group](#input\_create\_database\_subnet\_group) | Controls if database subnet group should be created | `bool` | `true` | no |
| <a name="input_create_database_subnet_route_table"></a> [create\_database\_subnet\_route\_table](#input\_create\_database\_subnet\_route\_table) | Controls if separate route table for database should be created | `bool` | `false` | no |
| <a name="input_create_elasticache_subnet_route_table"></a> [create\_elasticache\_subnet\_route\_table](#input\_create\_elasticache\_subnet\_route\_table) | Controls if separate route table for elasticache should be created | `bool` | `false` | no |
| <a name="input_create_redshift_subnet_route_table"></a> [create\_redshift\_subnet\_route\_table](#input\_create\_redshift\_subnet\_route\_table) | Controls if separate route table for redshift should be created | `bool` | `false` | no |
| <a name="input_create_vpc"></a> [create\_vpc](#input\_create\_vpc) | Controls if VPC should be created (it affects almost all resources) | `bool` | `true` | no |
| <a name="input_database_route_table_tags"></a> [database\_route\_table\_tags](#input\_database\_route\_table\_tags) | Additional tags for the database route tables | `map(any)` | `{}` | no |
| <a name="input_database_subnet_group_tags"></a> [database\_subnet\_group\_tags](#input\_database\_subnet\_group\_tags) | Additional tags for the database subnet group | `map(any)` | `{}` | no |
| <a name="input_database_subnet_tags"></a> [database\_subnet\_tags](#input\_database\_subnet\_tags) | Additional tags for the database subnets | `map(any)` | `{}` | no |
| <a name="input_database_subnets"></a> [database\_subnets](#input\_database\_subnets) | A list of database subnets | `list(any)` | `[]` | no |
| <a name="input_default_vpc_enable_classiclink"></a> [default\_vpc\_enable\_classiclink](#input\_default\_vpc\_enable\_classiclink) | Should be true to enable ClassicLink in the Default VPC | `bool` | `false` | no |
| <a name="input_default_vpc_enable_dns_hostnames"></a> [default\_vpc\_enable\_dns\_hostnames](#input\_default\_vpc\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the Default VPC | `bool` | `false` | no |
| <a name="input_default_vpc_enable_dns_support"></a> [default\_vpc\_enable\_dns\_support](#input\_default\_vpc\_enable\_dns\_support) | Should be true to enable DNS support in the Default VPC | `bool` | `true` | no |
| <a name="input_default_vpc_name"></a> [default\_vpc\_name](#input\_default\_vpc\_name) | Name to be used on the Default VPC | `string` | `""` | no |
| <a name="input_default_vpc_tags"></a> [default\_vpc\_tags](#input\_default\_vpc\_tags) | Additional tags for the Default VPC | `map(any)` | `{}` | no |
| <a name="input_dhcp_options_domain_name"></a> [dhcp\_options\_domain\_name](#input\_dhcp\_options\_domain\_name) | Specifies DNS name for DHCP options set | `string` | `""` | no |
| <a name="input_dhcp_options_domain_name_servers"></a> [dhcp\_options\_domain\_name\_servers](#input\_dhcp\_options\_domain\_name\_servers) | Specify a list of DNS server addresses for DHCP options set, default to AWS provided | `list(any)` | <pre>[<br>  "AmazonProvidedDNS"<br>]</pre> | no |
| <a name="input_dhcp_options_netbios_name_servers"></a> [dhcp\_options\_netbios\_name\_servers](#input\_dhcp\_options\_netbios\_name\_servers) | Specify a list of netbios servers for DHCP options set | `list(any)` | `[]` | no |
| <a name="input_dhcp_options_netbios_node_type"></a> [dhcp\_options\_netbios\_node\_type](#input\_dhcp\_options\_netbios\_node\_type) | Specify netbios node\_type for DHCP options set | `string` | `""` | no |
| <a name="input_dhcp_options_ntp_servers"></a> [dhcp\_options\_ntp\_servers](#input\_dhcp\_options\_ntp\_servers) | Specify a list of NTP servers for DHCP options set | `list(any)` | `[]` | no |
| <a name="input_dhcp_options_tags"></a> [dhcp\_options\_tags](#input\_dhcp\_options\_tags) | Additional tags for the DHCP option set | `map(any)` | `{}` | no |
| <a name="input_elasticache_route_table_tags"></a> [elasticache\_route\_table\_tags](#input\_elasticache\_route\_table\_tags) | Additional tags for the elasticache route tables | `map(any)` | `{}` | no |
| <a name="input_elasticache_subnet_tags"></a> [elasticache\_subnet\_tags](#input\_elasticache\_subnet\_tags) | Additional tags for the elasticache subnets | `map(any)` | `{}` | no |
| <a name="input_elasticache_subnets"></a> [elasticache\_subnets](#input\_elasticache\_subnets) | A list of elasticache subnets | `list(any)` | `[]` | no |
| <a name="input_enable_dhcp_options"></a> [enable\_dhcp\_options](#input\_enable\_dhcp\_options) | Should be true if you want to specify a DHCP options set with a custom domain name, DNS servers, NTP servers, netbios servers, and/or netbios server type | `bool` | `false` | no |
| <a name="input_enable_dns_hostnames"></a> [enable\_dns\_hostnames](#input\_enable\_dns\_hostnames) | Should be true to enable DNS hostnames in the VPC | `bool` | `false` | no |
| <a name="input_enable_dns_support"></a> [enable\_dns\_support](#input\_enable\_dns\_support) | Should be true to enable DNS support in the VPC | `bool` | `true` | no |
| <a name="input_enable_dynamodb_endpoint"></a> [enable\_dynamodb\_endpoint](#input\_enable\_dynamodb\_endpoint) | Should be true if you want to provision a DynamoDB endpoint to the VPC | `bool` | `false` | no |
| <a name="input_enable_nat_gateway"></a> [enable\_nat\_gateway](#input\_enable\_nat\_gateway) | Should be true if you want to provision NAT Gateways for each of your private networks | `bool` | `false` | no |
| <a name="input_enable_s3_endpoint"></a> [enable\_s3\_endpoint](#input\_enable\_s3\_endpoint) | Should be true if you want to provision an S3 endpoint to the VPC | `bool` | `false` | no |
| <a name="input_enable_vpn_gateway"></a> [enable\_vpn\_gateway](#input\_enable\_vpn\_gateway) | Should be true if you want to create a new VPN Gateway resource and attach it to the VPC | `bool` | `false` | no |
| <a name="input_external_nat_ip_ids"></a> [external\_nat\_ip\_ids](#input\_external\_nat\_ip\_ids) | List of EIP IDs to be assigned to the NAT Gateways (used in combination with reuse\_nat\_ips) | `list(any)` | `[]` | no |
| <a name="input_igw_tags"></a> [igw\_tags](#input\_igw\_tags) | Additional tags for the internet gateway | `map(any)` | `{}` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | A tenancy option for instances launched into the VPC | `string` | `"default"` | no |
| <a name="input_intra_route_table_tags"></a> [intra\_route\_table\_tags](#input\_intra\_route\_table\_tags) | Additional tags for the intra route tables | `map(any)` | `{}` | no |
| <a name="input_intra_subnet_tags"></a> [intra\_subnet\_tags](#input\_intra\_subnet\_tags) | Additional tags for the intra subnets | `map(any)` | `{}` | no |
| <a name="input_intra_subnets"></a> [intra\_subnets](#input\_intra\_subnets) | A list of intra subnets | `list(any)` | `[]` | no |
| <a name="input_manage_default_vpc"></a> [manage\_default\_vpc](#input\_manage\_default\_vpc) | Should be true to adopt and manage Default VPC | `bool` | `false` | no |
| <a name="input_map_public_ip_on_launch"></a> [map\_public\_ip\_on\_launch](#input\_map\_public\_ip\_on\_launch) | Should be false if you do not want to auto-assign public IP on launch | `bool` | `true` | no |
| <a name="input_name"></a> [name](#input\_name) | Name to be used on all the resources as identifier | `string` | `""` | no |
| <a name="input_nat_eip_tags"></a> [nat\_eip\_tags](#input\_nat\_eip\_tags) | Additional tags for the NAT EIP | `map(any)` | `{}` | no |
| <a name="input_nat_gateway_tags"></a> [nat\_gateway\_tags](#input\_nat\_gateway\_tags) | Additional tags for the NAT gateways | `map(any)` | `{}` | no |
| <a name="input_one_nat_gateway_per_az"></a> [one\_nat\_gateway\_per\_az](#input\_one\_nat\_gateway\_per\_az) | Should be true if you want only one NAT Gateway per availability zone. Requires `var.azs` to be set, and the number of `public_subnets` created to be greater than or equal to the number of availability zones specified in `var.azs`. | `bool` | `false` | no |
| <a name="input_private_route_table_tags"></a> [private\_route\_table\_tags](#input\_private\_route\_table\_tags) | Additional tags for the private route tables | `map(any)` | `{}` | no |
| <a name="input_private_subnet_tags"></a> [private\_subnet\_tags](#input\_private\_subnet\_tags) | Additional tags for the private subnets | `map(any)` | `{}` | no |
| <a name="input_private_subnets"></a> [private\_subnets](#input\_private\_subnets) | A list of private subnets inside the VPC | `list` | `[]` | no |
| <a name="input_propagate_private_route_tables_vgw"></a> [propagate\_private\_route\_tables\_vgw](#input\_propagate\_private\_route\_tables\_vgw) | Should be true if you want route table propagation | `bool` | `false` | no |
| <a name="input_propagate_public_route_tables_vgw"></a> [propagate\_public\_route\_tables\_vgw](#input\_propagate\_public\_route\_tables\_vgw) | Should be true if you want route table propagation | `bool` | `false` | no |
| <a name="input_public_route_table_tags"></a> [public\_route\_table\_tags](#input\_public\_route\_table\_tags) | Additional tags for the public route tables | `map(any)` | `{}` | no |
| <a name="input_public_subnet_tags"></a> [public\_subnet\_tags](#input\_public\_subnet\_tags) | Additional tags for the public subnets | `map(any)` | `{}` | no |
| <a name="input_public_subnets"></a> [public\_subnets](#input\_public\_subnets) | A list of public subnets inside the VPC | `list` | `[]` | no |
| <a name="input_redshift_route_table_tags"></a> [redshift\_route\_table\_tags](#input\_redshift\_route\_table\_tags) | Additional tags for the redshift route tables | `map(any)` | `{}` | no |
| <a name="input_redshift_subnet_group_tags"></a> [redshift\_subnet\_group\_tags](#input\_redshift\_subnet\_group\_tags) | Additional tags for the redshift subnet group | `map(any)` | `{}` | no |
| <a name="input_redshift_subnet_tags"></a> [redshift\_subnet\_tags](#input\_redshift\_subnet\_tags) | Additional tags for the redshift subnets | `map(any)` | `{}` | no |
| <a name="input_redshift_subnets"></a> [redshift\_subnets](#input\_redshift\_subnets) | A list of redshift subnets | `list(any)` | `[]` | no |
| <a name="input_reuse_nat_ips"></a> [reuse\_nat\_ips](#input\_reuse\_nat\_ips) | Should be true if you don't want EIPs to be created for your NAT Gateways and will instead pass them in via the 'external\_nat\_ip\_ids' variable | `bool` | `false` | no |
| <a name="input_single_nat_gateway"></a> [single\_nat\_gateway](#input\_single\_nat\_gateway) | Should be true if you want to provision a single shared NAT Gateway across all of your private networks | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to add to all resources | `map(any)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Controls if VPC should be created (it affects almost all resources) | `string` | `""` | no |
| <a name="input_vpc_tags"></a> [vpc\_tags](#input\_vpc\_tags) | Additional tags for the VPC | `map(any)` | `{}` | no |
| <a name="input_vpn_gateway_id"></a> [vpn\_gateway\_id](#input\_vpn\_gateway\_id) | ID of VPN Gateway to attach to the VPC | `string` | `""` | no |
| <a name="input_vpn_gateway_tags"></a> [vpn\_gateway\_tags](#input\_vpn\_gateway\_tags) | Additional tags for the VPN gateway | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_database_route_table_ids"></a> [database\_route\_table\_ids](#output\_database\_route\_table\_ids) | List of IDs of database route tables |
| <a name="output_database_subnet_group"></a> [database\_subnet\_group](#output\_database\_subnet\_group) | ID of database subnet group |
| <a name="output_database_subnets"></a> [database\_subnets](#output\_database\_subnets) | List of IDs of database subnets |
| <a name="output_database_subnets_cidr_blocks"></a> [database\_subnets\_cidr\_blocks](#output\_database\_subnets\_cidr\_blocks) | List of cidr\_blocks of database subnets |
| <a name="output_default_network_acl_id"></a> [default\_network\_acl\_id](#output\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_route_table_id"></a> [default\_route\_table\_id](#output\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_security_group_id"></a> [default\_security\_group\_id](#output\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_default_vpc_cidr_block"></a> [default\_vpc\_cidr\_block](#output\_default\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_default_vpc_default_network_acl_id"></a> [default\_vpc\_default\_network\_acl\_id](#output\_default\_vpc\_default\_network\_acl\_id) | The ID of the default network ACL |
| <a name="output_default_vpc_default_route_table_id"></a> [default\_vpc\_default\_route\_table\_id](#output\_default\_vpc\_default\_route\_table\_id) | The ID of the default route table |
| <a name="output_default_vpc_default_security_group_id"></a> [default\_vpc\_default\_security\_group\_id](#output\_default\_vpc\_default\_security\_group\_id) | The ID of the security group created by default on VPC creation |
| <a name="output_default_vpc_enable_dns_hostnames"></a> [default\_vpc\_enable\_dns\_hostnames](#output\_default\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_default_vpc_enable_dns_support"></a> [default\_vpc\_enable\_dns\_support](#output\_default\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_default_vpc_id"></a> [default\_vpc\_id](#output\_default\_vpc\_id) | The ID of the VPC |
| <a name="output_default_vpc_instance_tenancy"></a> [default\_vpc\_instance\_tenancy](#output\_default\_vpc\_instance\_tenancy) | Tenancy of instances spin up within VPC |
| <a name="output_default_vpc_main_route_table_id"></a> [default\_vpc\_main\_route\_table\_id](#output\_default\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC |
| <a name="output_elasticache_route_table_ids"></a> [elasticache\_route\_table\_ids](#output\_elasticache\_route\_table\_ids) | List of IDs of elasticache route tables |
| <a name="output_elasticache_subnet_group"></a> [elasticache\_subnet\_group](#output\_elasticache\_subnet\_group) | ID of elasticache subnet group |
| <a name="output_elasticache_subnet_group_name"></a> [elasticache\_subnet\_group\_name](#output\_elasticache\_subnet\_group\_name) | Name of elasticache subnet group |
| <a name="output_elasticache_subnets"></a> [elasticache\_subnets](#output\_elasticache\_subnets) | List of IDs of elasticache subnets |
| <a name="output_elasticache_subnets_cidr_blocks"></a> [elasticache\_subnets\_cidr\_blocks](#output\_elasticache\_subnets\_cidr\_blocks) | List of cidr\_blocks of elasticache subnets |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The ID of the Internet Gateway |
| <a name="output_intra_route_table_ids"></a> [intra\_route\_table\_ids](#output\_intra\_route\_table\_ids) | List of IDs of intra route tables |
| <a name="output_intra_subnets"></a> [intra\_subnets](#output\_intra\_subnets) | List of IDs of intra subnets |
| <a name="output_intra_subnets_cidr_blocks"></a> [intra\_subnets\_cidr\_blocks](#output\_intra\_subnets\_cidr\_blocks) | List of cidr\_blocks of intra subnets |
| <a name="output_nat_ids"></a> [nat\_ids](#output\_nat\_ids) | List of allocation ID of Elastic IPs created for AWS NAT Gateway |
| <a name="output_nat_public_ips"></a> [nat\_public\_ips](#output\_nat\_public\_ips) | List of public Elastic IPs created for AWS NAT Gateway |
| <a name="output_natgw_ids"></a> [natgw\_ids](#output\_natgw\_ids) | List of NAT Gateway IDs |
| <a name="output_private_route_table_ids"></a> [private\_route\_table\_ids](#output\_private\_route\_table\_ids) | List of IDs of private route tables |
| <a name="output_private_subnets"></a> [private\_subnets](#output\_private\_subnets) | List of IDs of private subnets |
| <a name="output_private_subnets_cidr_blocks"></a> [private\_subnets\_cidr\_blocks](#output\_private\_subnets\_cidr\_blocks) | List of cidr\_blocks of private subnets |
| <a name="output_public_route_table_ids"></a> [public\_route\_table\_ids](#output\_public\_route\_table\_ids) | List of IDs of public route tables |
| <a name="output_public_subnets"></a> [public\_subnets](#output\_public\_subnets) | List of IDs of public subnets |
| <a name="output_public_subnets_cidr_blocks"></a> [public\_subnets\_cidr\_blocks](#output\_public\_subnets\_cidr\_blocks) | List of cidr\_blocks of public subnets |
| <a name="output_redshift_route_table_ids"></a> [redshift\_route\_table\_ids](#output\_redshift\_route\_table\_ids) | List of IDs of redshift route tables |
| <a name="output_redshift_subnet_group"></a> [redshift\_subnet\_group](#output\_redshift\_subnet\_group) | ID of redshift subnet group |
| <a name="output_redshift_subnets"></a> [redshift\_subnets](#output\_redshift\_subnets) | List of IDs of redshift subnets |
| <a name="output_redshift_subnets_cidr_blocks"></a> [redshift\_subnets\_cidr\_blocks](#output\_redshift\_subnets\_cidr\_blocks) | List of cidr\_blocks of redshift subnets |
| <a name="output_vgw_id"></a> [vgw\_id](#output\_vgw\_id) | The ID of the VPN Gateway |
| <a name="output_vpc_cidr_block"></a> [vpc\_cidr\_block](#output\_vpc\_cidr\_block) | The CIDR block of the VPC |
| <a name="output_vpc_enable_dns_hostnames"></a> [vpc\_enable\_dns\_hostnames](#output\_vpc\_enable\_dns\_hostnames) | Whether or not the VPC has DNS hostname support |
| <a name="output_vpc_enable_dns_support"></a> [vpc\_enable\_dns\_support](#output\_vpc\_enable\_dns\_support) | Whether or not the VPC has DNS support |
| <a name="output_vpc_endpoint_dynamodb_id"></a> [vpc\_endpoint\_dynamodb\_id](#output\_vpc\_endpoint\_dynamodb\_id) | The ID of VPC endpoint for DynamoDB |
| <a name="output_vpc_endpoint_dynamodb_pl_id"></a> [vpc\_endpoint\_dynamodb\_pl\_id](#output\_vpc\_endpoint\_dynamodb\_pl\_id) | The prefix list for the DynamoDB VPC endpoint. |
| <a name="output_vpc_endpoint_s3_id"></a> [vpc\_endpoint\_s3\_id](#output\_vpc\_endpoint\_s3\_id) | The ID of VPC endpoint for S3 |
| <a name="output_vpc_endpoint_s3_pl_id"></a> [vpc\_endpoint\_s3\_pl\_id](#output\_vpc\_endpoint\_s3\_pl\_id) | The prefix list for the S3 VPC endpoint. |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
| <a name="output_vpc_instance_tenancy"></a> [vpc\_instance\_tenancy](#output\_vpc\_instance\_tenancy) | Tenancy of instances spin up within VPC |
| <a name="output_vpc_main_route_table_id"></a> [vpc\_main\_route\_table\_id](#output\_vpc\_main\_route\_table\_id) | The ID of the main route table associated with this VPC |
<!-- END_TF_DOCS -->