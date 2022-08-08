<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.12 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_subnet.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [template_file._subnet_name](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |
| [template_file.subnet_offset_to_assigned_size](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_available_az"></a> [available\_az](#input\_available\_az) | A list of available Availability Zones | `list(any)` | n/a | yes |
| <a name="input_cidr_block"></a> [cidr\_block](#input\_cidr\_block) | The CIDR block of the VPC | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_is_public"></a> [is\_public](#input\_is\_public) | Whether or not the subnet will be public | `bool` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the subnet | `string` | n/a | yes |
| <a name="input_subnet_assignment"></a> [subnet\_assignment](#input\_subnet\_assignment) | A list of subnet CIDR for assignment | `list(any)` | n/a | yes |
| <a name="input_subnet_count"></a> [subnet\_count](#input\_subnet\_count) | The number of subnets that will be created | `number` | n/a | yes |
| <a name="input_subnet_size"></a> [subnet\_size](#input\_subnet\_size) | The size of the subnet | `string` | n/a | yes |
| <a name="input_subnet_type"></a> [subnet\_type](#input\_subnet\_type) | The type of subnet that will be created | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_enable_subnet"></a> [enable\_subnet](#input\_enable\_subnet) | If the value is 0, the subnet creation won't be enabled | `string` | `"1"` | no |
| <a name="input_identifier_tags"></a> [identifier\_tags](#input\_identifier\_tags) | A mapping of identifier tags | `map(string)` | `{}` | no |
| <a name="input_number_of_az"></a> [number\_of\_az](#input\_number\_of\_az) | The number of availability zones | `string` | `"3"` | no |
| <a name="input_tag_values"></a> [tag\_values](#input\_tag\_values) | A mapping of tag values | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_cidrs"></a> [subnet\_cidrs](#output\_subnet\_cidrs) | The CIDRs of the subnet |
| <a name="output_subnet_ids"></a> [subnet\_ids](#output\_subnet\_ids) | The ID of the subnets |
| <a name="output_subnets"></a> [subnets](#output\_subnets) | A mapping of subnet properties (ID, Availability zone, CIDR blocks) |
<!-- END_TF_DOCS -->