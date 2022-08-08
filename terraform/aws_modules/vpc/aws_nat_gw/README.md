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
| <a name="module_aws_eip"></a> [aws\_eip](#module\_aws\_eip) | ../aws_eip | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_nat_gateway.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the NAT Gateway | `string` | n/a | yes |
| <a name="input_nat_subnet_ids"></a> [nat\_subnet\_ids](#input\_nat\_subnet\_ids) | A list of subnet IDs for the NATs | `list(any)` | n/a | yes |
| <a name="input_ngw_count"></a> [ngw\_count](#input\_ngw\_count) | The number of NAT gateways that will be created | `number` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_identifier_tags"></a> [identifier\_tags](#input\_identifier\_tags) | A mapping of identifier tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ngw_ids"></a> [ngw\_ids](#output\_ngw\_ids) | The IDs of the NAT gateway |
| <a name="output_ngws"></a> [ngws](#output\_ngws) | A mapping of values for the NAT Gateway |
<!-- END_TF_DOCS -->