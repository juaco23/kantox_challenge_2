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

| Name | Source | Version |
|------|--------|---------|
| <a name="module_route_igw"></a> [route\_igw](#module\_route\_igw) | ../aws_route | n/a |
| <a name="module_route_ngw"></a> [route\_ngw](#module\_route\_ngw) | ../aws_route | n/a |
| <a name="module_route_tables"></a> [route\_tables](#module\_route\_tables) | ../aws_route_table | n/a |
| <a name="module_route_to_ops"></a> [route\_to\_ops](#module\_route\_to\_ops) | ../aws_route | n/a |
| <a name="module_subnets"></a> [subnets](#module\_subnets) | ../aws_subnet | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_route_table_association.route_private_ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.route_public_igw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_available_az"></a> [available\_az](#input\_available\_az) | A list of available Availability Zones | `list(any)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The VPC's CIDR block | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_is_public"></a> [is\_public](#input\_is\_public) | Whether or not the VPC is public | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the subnet | `string` | n/a | yes |
| <a name="input_subnet_assignment_list"></a> [subnet\_assignment\_list](#input\_subnet\_assignment\_list) | A list of subnet CIDR for assignment | `list(any)` | n/a | yes |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | The number of subnets that will be created | `number` | n/a | yes |
| <a name="input_subnet_size"></a> [subnet\_size](#input\_subnet\_size) | The size of the subnet | `string` | n/a | yes |
| <a name="input_subnet_type"></a> [subnet\_type](#input\_subnet\_type) | The type of the subnet | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_dst_cidr_block"></a> [dst\_cidr\_block](#input\_dst\_cidr\_block) | The destination CIDR block | `string` | `"0.0.0.0/0"` | no |
| <a name="input_dynamodb_vpc_endpoint_id"></a> [dynamodb\_vpc\_endpoint\_id](#input\_dynamodb\_vpc\_endpoint\_id) | The ID of the Dynamo endpoint | `string` | `""` | no |
| <a name="input_enable_dynamodb_vpc_endpoint"></a> [enable\_dynamodb\_vpc\_endpoint](#input\_enable\_dynamodb\_vpc\_endpoint) | If the value is 0, the Dynamo endpoint won't be enabled | `string` | `"0"` | no |
| <a name="input_enable_ops_peering_routes"></a> [enable\_ops\_peering\_routes](#input\_enable\_ops\_peering\_routes) | If the value is 0, the OPS peering routes won't be enabled | `string` | `"0"` | no |
| <a name="input_enable_s3_vpc_endpoint"></a> [enable\_s3\_vpc\_endpoint](#input\_enable\_s3\_vpc\_endpoint) | If the value is 0, the S3 endpoint won't be enabled | `string` | `"0"` | no |
| <a name="input_gw_count"></a> [gw\_count](#input\_gw\_count) | The number of VGW or IGW | `number` | `0` | no |
| <a name="input_gw_id"></a> [gw\_id](#input\_gw\_id) | The ID of the VGW/IGW | `string` | `""` | no |
| <a name="input_identifier_tags"></a> [identifier\_tags](#input\_identifier\_tags) | A mapping of identifier tags | `map(string)` | `{}` | no |
| <a name="input_ngw_count"></a> [ngw\_count](#input\_ngw\_count) | The number of NAT gateways | `number` | `0` | no |
| <a name="input_ngw_id_list"></a> [ngw\_id\_list](#input\_ngw\_id\_list) | A list of IDs of NAT Gateways | `list(any)` | `[]` | no |
| <a name="input_ops_cidr"></a> [ops\_cidr](#input\_ops\_cidr) | The CIDR of the OPS | `string` | `"0"` | no |
| <a name="input_ops_peering_id"></a> [ops\_peering\_id](#input\_ops\_peering\_id) | The ID of the OPS peering | `string` | `"0"` | no |
| <a name="input_propagating_vgws"></a> [propagating\_vgws](#input\_propagating\_vgws) | A list of propagating VGWs | `list(any)` | `[]` | no |
| <a name="input_s3_vpc_endpoint_id"></a> [s3\_vpc\_endpoint\_id](#input\_s3\_vpc\_endpoint\_id) | The ID of the S3 endpoint | `string` | `""` | no |
| <a name="input_subnet_tag_values"></a> [subnet\_tag\_values](#input\_subnet\_tag\_values) | A mapping of subnet tag values | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_route_table_ids"></a> [route\_table\_ids](#output\_route\_table\_ids) | The ID of the route table |
| <a name="output_subnet_cidrs"></a> [subnet\_cidrs](#output\_subnet\_cidrs) | The CIDR blocks of the subnets |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The ID of the subnets |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | The subnets created by the module |
<!-- END_TF_DOCS -->