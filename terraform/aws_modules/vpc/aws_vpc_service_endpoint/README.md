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
| [aws_vpc_endpoint.vpc_endpoint](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_service"></a> [service](#input\_service) | The name of the service | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC | `string` | n/a | yes |
| <a name="input_enable_vpc_endpoint"></a> [enable\_vpc\_endpoint](#input\_enable\_vpc\_endpoint) | If the value is 0 the VPC endpoint won't be enabled | `any` | `"1"` | no |
| <a name="input_private_dns_enabled"></a> [private\_dns\_enabled](#input\_private\_dns\_enabled) | Whether the private DNS will be enabled | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_endpoint_cidr_blocks"></a> [vpc\_endpoint\_cidr\_blocks](#output\_vpc\_endpoint\_cidr\_blocks) | The VPC endpoint CIDR block |
| <a name="output_vpc_endpoint_id"></a> [vpc\_endpoint\_id](#output\_vpc\_endpoint\_id) | The VPC endpoint ID |
| <a name="output_vpc_endpoint_prefix_list_id"></a> [vpc\_endpoint\_prefix\_list\_id](#output\_vpc\_endpoint\_prefix\_list\_id) | The VPC endpoint prefix list ID |
<!-- END_TF_DOCS -->