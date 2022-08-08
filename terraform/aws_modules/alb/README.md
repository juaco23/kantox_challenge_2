<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_lb.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https_prod](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https_test](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.blue](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_target_group.green](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix environment name | `string` | `""` | no |
| <a name="input_ssl_certificate"></a> [ssl\_certificate](#input\_ssl\_certificate) | A valid SSL certificate ARN | `string` | `""` | no |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Public subnets IDs for ALB | `list` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The metadata that you apply to the task definition to help you categorize and organize them | `map(string)` | `{}` | no |
| <a name="input_target_group_port"></a> [target\_group\_port](#input\_target\_group\_port) | The target group port number | `number` | `"80"` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns"></a> [alb\_dns](#output\_alb\_dns) | n/a |
| <a name="output_alb_sg_id"></a> [alb\_sg\_id](#output\_alb\_sg\_id) | n/a |
| <a name="output_aws_lb_listener_blue_arn"></a> [aws\_lb\_listener\_blue\_arn](#output\_aws\_lb\_listener\_blue\_arn) | n/a |
| <a name="output_aws_lb_listener_green_arn"></a> [aws\_lb\_listener\_green\_arn](#output\_aws\_lb\_listener\_green\_arn) | n/a |
| <a name="output_aws_lb_target_group_blue_name"></a> [aws\_lb\_target\_group\_blue\_name](#output\_aws\_lb\_target\_group\_blue\_name) | n/a |
| <a name="output_aws_lb_target_group_green_arn"></a> [aws\_lb\_target\_group\_green\_arn](#output\_aws\_lb\_target\_group\_green\_arn) | n/a |
| <a name="output_aws_lb_target_group_green_name"></a> [aws\_lb\_target\_group\_green\_name](#output\_aws\_lb\_target\_group\_green\_name) | n/a |
<!-- END_TF_DOCS -->