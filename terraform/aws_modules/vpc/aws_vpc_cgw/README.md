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
| [aws_customer_gateway.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/customer_gateway) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | The name of the application | `string` | n/a | yes |
| <a name="input_cgw_ip_address"></a> [cgw\_ip\_address](#input\_cgw\_ip\_address) | The IP address of the customer gateway | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment | `string` | n/a | yes |
| <a name="input_bgp_asn"></a> [bgp\_asn](#input\_bgp\_asn) | Border Gateway Protocol Autonomous Systems Number | `any` | `"65000"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cgw_id"></a> [cgw\_id](#output\_cgw\_id) | The ID of the customer gateway |
<!-- END_TF_DOCS -->