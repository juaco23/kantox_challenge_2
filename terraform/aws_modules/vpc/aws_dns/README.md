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
| [aws_route53_record.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_zone.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_zone) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_base_dns"></a> [base\_dns](#input\_base\_dns) | The base DNS for the zone name | `string` | n/a | yes |
| <a name="input_enable_dns"></a> [enable\_dns](#input\_enable\_dns) | If number is 0 no record will be created | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | environment | `string` | n/a | yes |
| <a name="input_parent_zone"></a> [parent\_zone](#input\_parent\_zone) | The DNS parent zone | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | n/a | yes |
| <a name="input_subdomain"></a> [subdomain](#input\_subdomain) | The subdomain for the zone name | `string` | n/a | yes |
| <a name="input_identifier_tags"></a> [identifier\_tags](#input\_identifier\_tags) | A mapping of identifier tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_zone_id"></a> [zone\_id](#output\_zone\_id) | The ID of the zone |
| <a name="output_zone_name"></a> [zone\_name](#output\_zone\_name) | The name of the zone |
<!-- END_TF_DOCS -->