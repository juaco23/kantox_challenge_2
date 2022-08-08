<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_openid_connect_provider.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.github_actions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.github_actions_assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [tls_certificate.github](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_client_id_list"></a> [client\_id\_list](#input\_client\_id\_list) | Audience that identifies the application that is registered with an OpenID Connect provider | `list(string)` | <pre>[<br>  "sts.amazonaws.com"<br>]</pre> | no |
| <a name="input_codedeploy_application_name"></a> [codedeploy\_application\_name](#input\_codedeploy\_application\_name) | The CodeDeploy application name | `string` | `""` | no |
| <a name="input_codedeploy_dg"></a> [codedeploy\_dg](#input\_codedeploy\_dg) | The CodeDeploy Deployment Group name | `string` | `""` | no |
| <a name="input_ecr_repository_arn"></a> [ecr\_repository\_arn](#input\_ecr\_repository\_arn) | The ECR repository ARN | `string` | `"us-east-1"` | no |
| <a name="input_ecs_cluster_name"></a> [ecs\_cluster\_name](#input\_ecs\_cluster\_name) | The ECS Cluster Name | `string` | `""` | no |
| <a name="input_ecs_role_arn"></a> [ecs\_role\_arn](#input\_ecs\_role\_arn) | The ECS role arn | `string` | `""` | no |
| <a name="input_ecs_service_name"></a> [ecs\_service\_name](#input\_ecs\_service\_name) | The ECS Service Name | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | `"us-east-1"` | no |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The repository name to connect to AWS by OIDC | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_github_actions_arn"></a> [github\_actions\_arn](#output\_github\_actions\_arn) | n/a |
<!-- END_TF_DOCS -->