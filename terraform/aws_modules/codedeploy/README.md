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
| [aws_codedeploy_app.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_app) | resource |
| [aws_codedeploy_deployment_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/codedeploy_deployment_group) | resource |
| [aws_iam_role.code_deploy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_lb_listener_blue_arn"></a> [aws\_lb\_listener\_blue\_arn](#input\_aws\_lb\_listener\_blue\_arn) | The blue Listener ARN | `string` | `""` | no |
| <a name="input_aws_lb_listener_green_arn"></a> [aws\_lb\_listener\_green\_arn](#input\_aws\_lb\_listener\_green\_arn) | The green Listener ARN | `string` | `""` | no |
| <a name="input_aws_lb_target_group_blue_name"></a> [aws\_lb\_target\_group\_blue\_name](#input\_aws\_lb\_target\_group\_blue\_name) | The blue TG name | `string` | `""` | no |
| <a name="input_aws_lb_target_group_green_name"></a> [aws\_lb\_target\_group\_green\_name](#input\_aws\_lb\_target\_group\_green\_name) | The green TG name | `string` | `""` | no |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | A valid ssl certificate arn | `string` | `""` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The ECS Cluster Name | `string` | `""` | no |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | The ECS Service Name | `string` | `""` | no |
| <a name="input_name_prefix"></a> [name\_prefix](#input\_name\_prefix) | Prefix environment name | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_aws_codedeploy_app_name"></a> [aws\_codedeploy\_app\_name](#output\_aws\_codedeploy\_app\_name) | n/a |
| <a name="output_deployment_group_name"></a> [deployment\_group\_name](#output\_deployment\_group\_name) | n/a |
<!-- END_TF_DOCS -->