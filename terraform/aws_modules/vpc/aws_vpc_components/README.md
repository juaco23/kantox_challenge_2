<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ../aws_vpc_bastion | n/a |
| <a name="module_dhcp_options"></a> [dhcp\_options](#module\_dhcp\_options) | ../aws_dhcp_options | n/a |
| <a name="module_dynamodb_vpc_endpoint"></a> [dynamodb\_vpc\_endpoint](#module\_dynamodb\_vpc\_endpoint) | ../aws_vpc_endpoint | n/a |
| <a name="module_internet_gateway"></a> [internet\_gateway](#module\_internet\_gateway) | ../aws_igw | n/a |
| <a name="module_nat_gateways"></a> [nat\_gateways](#module\_nat\_gateways) | ../aws_nat_gw | n/a |
| <a name="module_nat_subnets_setup"></a> [nat\_subnets\_setup](#module\_nat\_subnets\_setup) | ../aws_subnet_setup | n/a |
| <a name="module_s3_vpc_endpoint"></a> [s3\_vpc\_endpoint](#module\_s3\_vpc\_endpoint) | ../aws_vpc_endpoint | n/a |
| <a name="module_services_subnets_setup"></a> [services\_subnets\_setup](#module\_services\_subnets\_setup) | ../aws_subnet_setup | n/a |
| <a name="module_unbound"></a> [unbound](#module\_unbound) | ../unbound | n/a |
| <a name="module_vpc_dns"></a> [vpc\_dns](#module\_vpc\_dns) | ../aws_dns | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_vpc.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |
| [template_file.svc_offset_to_assigned_size](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_available_az"></a> [available\_az](#input\_available\_az) | A list of available Availability zones | `list(any)` | n/a | yes |
| <a name="input_base_route53_domain"></a> [base\_route53\_domain](#input\_base\_route53\_domain) | The base Route53 domain | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the resource | `string` | n/a | yes |
| <a name="input_num_az"></a> [num\_az](#input\_num\_az) | Number of AZs specified | `any` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The Region | `string` | n/a | yes |
| <a name="input_route53_zone_id"></a> [route53\_zone\_id](#input\_route53\_zone\_id) | The Route53 zone ID | `string` | n/a | yes |
| <a name="input_subnet_assignment"></a> [subnet\_assignment](#input\_subnet\_assignment) | A mapping of subnet assignments | `map(any)` | n/a | yes |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | A mapping of subnet counts | `map(any)` | n/a | yes |
| <a name="input_subnet_tag_values"></a> [subnet\_tag\_values](#input\_subnet\_tag\_values) | A mapping of subnet tag values | `map(any)` | n/a | yes |
| <a name="input_user"></a> [user](#input\_user) | The User | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | If the value is 0 the bastion won't be enabled | `any` | `"1"` | no |
| <a name="input_enable_dns_zone"></a> [enable\_dns\_zone](#input\_enable\_dns\_zone) | If the value is 0 the bastion won't be enabled | `string` | `"1"` | no |
| <a name="input_enable_dynamodb_vpc_endpoint"></a> [enable\_dynamodb\_vpc\_endpoint](#input\_enable\_dynamodb\_vpc\_endpoint) | If the value is 0, the Dynamo endpoint won't be enabled | `string` | `"0"` | no |
| <a name="input_enable_flow_logs"></a> [enable\_flow\_logs](#input\_enable\_flow\_logs) | If the value is 0 the flow logs won't be enabled | `string` | `"0"` | no |
| <a name="input_enable_ops_peering_routes"></a> [enable\_ops\_peering\_routes](#input\_enable\_ops\_peering\_routes) | If the value is 0, the OPS peering routes won't be enabled | `string` | `"0"` | no |
| <a name="input_enable_s3_vpc_endpoint"></a> [enable\_s3\_vpc\_endpoint](#input\_enable\_s3\_vpc\_endpoint) | If the value is 0, the S3 endpoint won't be enabled | `string` | `"0"` | no |
| <a name="input_enable_unbound"></a> [enable\_unbound](#input\_enable\_unbound) | If the value is 0 the unbound won't be enabled | `any` | `"0"` | no |
| <a name="input_forward_zones"></a> [forward\_zones](#input\_forward\_zones) | A mapping of forward zones | `map(any)` | `{}` | no |
| <a name="input_identifier_tags"></a> [identifier\_tags](#input\_identifier\_tags) | A mapping of identifier tags | `map(any)` | `{}` | no |
| <a name="input_ops_cidr"></a> [ops\_cidr](#input\_ops\_cidr) | The CIDR of the OPS | `string` | `"0"` | no |
| <a name="input_ops_peering_id"></a> [ops\_peering\_id](#input\_ops\_peering\_id) | The ID of the OPS peering | `string` | `"0"` | no |
| <a name="input_propagating_vgws"></a> [propagating\_vgws](#input\_propagating\_vgws) | A list of propagating vgws | `list(any)` | `[]` | no |
| <a name="input_subnet_offset"></a> [subnet\_offset](#input\_subnet\_offset) | The subnet offset | `any` | `"3"` | no |
| <a name="input_svc_subnet_size"></a> [svc\_subnet\_size](#input\_svc\_subnet\_size) | The service subnet size | `any` | `"24"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bastion_dns_record"></a> [bastion\_dns\_record](#output\_bastion\_dns\_record) | The bastion DNS record |
| <a name="output_bastion_private_key_pem"></a> [bastion\_private\_key\_pem](#output\_bastion\_private\_key\_pem) | The bastion's private key pem |
| <a name="output_dns_zone_id"></a> [dns\_zone\_id](#output\_dns\_zone\_id) | The DNS zone ID |
| <a name="output_dns_zone_name"></a> [dns\_zone\_name](#output\_dns\_zone\_name) | The DNS zone name |
| <a name="output_dynamodb_vpc_endpoint_id"></a> [dynamodb\_vpc\_endpoint\_id](#output\_dynamodb\_vpc\_endpoint\_id) | The DynamoDB endpoint ID |
| <a name="output_igw_id"></a> [igw\_id](#output\_igw\_id) | The ID of the internet gateway |
| <a name="output_nat_gws"></a> [nat\_gws](#output\_nat\_gws) | NAT gateways |
| <a name="output_nat_subnets"></a> [nat\_subnets](#output\_nat\_subnets) | The NAT subnets |
| <a name="output_s3_vpc_endpoint_id"></a> [s3\_vpc\_endpoint\_id](#output\_s3\_vpc\_endpoint\_id) | The S3 endpoint ID |
| <a name="output_services_subnets"></a> [services\_subnets](#output\_services\_subnets) | The service subnets |
<!-- END_TF_DOCS -->