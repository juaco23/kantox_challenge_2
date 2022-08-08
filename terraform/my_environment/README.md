<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.15.1 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_alb"></a> [alb](#module\_alb) | ../aws_modules/alb | n/a |
| <a name="module_application_subnet"></a> [application\_subnet](#module\_application\_subnet) | ../aws_modules/vpc/aws_subnet_setup | n/a |
| <a name="module_codedeploy"></a> [codedeploy](#module\_codedeploy) | ../aws_modules/codedeploy | n/a |
| <a name="module_ecr"></a> [ecr](#module\_ecr) | ../aws_modules/ecr | n/a |
| <a name="module_ecs_cluster"></a> [ecs\_cluster](#module\_ecs\_cluster) | ../aws_modules/ecs/cluster | n/a |
| <a name="module_ecs_profile"></a> [ecs\_profile](#module\_ecs\_profile) | ../aws_modules/ecs/instance_profile | n/a |
| <a name="module_ecs_services"></a> [ecs\_services](#module\_ecs\_services) | ../aws_modules/ecs/service | n/a |
| <a name="module_internet_gateway"></a> [internet\_gateway](#module\_internet\_gateway) | ../aws_modules/vpc/aws_igw | n/a |
| <a name="module_nat_gateway"></a> [nat\_gateway](#module\_nat\_gateway) | ../aws_modules/vpc/aws_nat_gw | n/a |
| <a name="module_oidc_github"></a> [oidc\_github](#module\_oidc\_github) | ../aws_modules/oidc_github | n/a |
| <a name="module_public_subnets"></a> [public\_subnets](#module\_public\_subnets) | ../aws_modules/vpc/aws_subnet_setup | n/a |
| <a name="module_vpc"></a> [vpc](#module\_vpc) | ../aws_modules/vpc/aws_vpc | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_name"></a> [application\_name](#input\_application\_name) | Application name | `string` | n/a | yes |
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | A list of availability zones | `list(any)` | n/a | yes |
| <a name="input_client_id_list"></a> [client\_id\_list](#input\_client\_id\_list) | Audience that identifies the application that is registered with an OpenID Connect provider | `list(string)` | n/a | yes |
| <a name="input_container_insights"></a> [container\_insights](#input\_container\_insights) | Enable or disable Container Insights | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container port | `number` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_repo_name"></a> [repo\_name](#input\_repo\_name) | The repository name to connect to AWS to GitHub Actions | `string` | n/a | yes |
| <a name="input_subnet_size"></a> [subnet\_size](#input\_subnet\_size) | Subnet size | `string` | n/a | yes |
| <a name="input_task_cpu"></a> [task\_cpu](#input\_task\_cpu) | CPU defined at the task level | `number` | n/a | yes |
| <a name="input_task_memory"></a> [task\_memory](#input\_task\_memory) | MEMORY defined at the task level | `number` | n/a | yes |
| <a name="input_vpc_cidr_block"></a> [vpc\_cidr\_block](#input\_vpc\_cidr\_block) | CIDR block of the vpc | `string` | n/a | yes |
| <a name="input_container_definition"></a> [container\_definition](#input\_container\_definition) | Task definitions, container definitions | `string` | `""` | no |
| <a name="input_container_name"></a> [container\_name](#input\_container\_name) | The name of your container | `string` | `""` | no |
| <a name="input_cpu_target_value"></a> [cpu\_target\_value](#input\_cpu\_target\_value) | Value for the cpu target to do autoscale | `number` | `50` | no |
| <a name="input_instance_tenancy"></a> [instance\_tenancy](#input\_instance\_tenancy) | The tenancy of the instances that will be created inside the VPC | `string` | `"default"` | no |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Max services for scale up | `number` | `1` | no |
| <a name="input_memory_target_value"></a> [memory\_target\_value](#input\_memory\_target\_value) | Value for the memory target to do autoscale | `number` | `50` | no |
| <a name="input_min_capacity"></a> [min\_capacity](#input\_min\_capacity) | Min services for scale up | `number` | `1` | no |
| <a name="input_region"></a> [region](#input\_region) | Region | `string` | `"us-east-1"` | no |
| <a name="input_ssl_certificate"></a> [ssl\_certificate](#input\_ssl\_certificate) | A valid SSL certificate ARN | `string` | `""` | no |
| <a name="input_subnet_assignment"></a> [subnet\_assignment](#input\_subnet\_assignment) | subnet assignment | `map(string)` | <pre>{<br>  "application": "3,4",<br>  "public": "1,2"<br>}</pre> | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The metadata that you apply to the task definition to help you categorize and organize them | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_CODE_DEPLOY_APPLICATION"></a> [CODE\_DEPLOY\_APPLICATION](#output\_CODE\_DEPLOY\_APPLICATION) | The CodeDeploy Application name |
| <a name="output_CODE_DEPLOY_DG"></a> [CODE\_DEPLOY\_DG](#output\_CODE\_DEPLOY\_DG) | The CodeDeploy Deployment Group name |
| <a name="output_CONTAINER_NAME"></a> [CONTAINER\_NAME](#output\_CONTAINER\_NAME) | The name of your container |
| <a name="output_DEPLOY_ROLE"></a> [DEPLOY\_ROLE](#output\_DEPLOY\_ROLE) | The ARN of the GitHub Role, which is used to deploy by Github Actions |
| <a name="output_ECR_REPOSITORY"></a> [ECR\_REPOSITORY](#output\_ECR\_REPOSITORY) | The ECR Repository name |
| <a name="output_ECS_CLUSTER_NAME"></a> [ECS\_CLUSTER\_NAME](#output\_ECS\_CLUSTER\_NAME) | The ECS Cluster Name |
| <a name="output_ECS_SERVICE_NAME"></a> [ECS\_SERVICE\_NAME](#output\_ECS\_SERVICE\_NAME) | The ECS Service Name |
| <a name="output_TASK_DEFINITION_FAMILY"></a> [TASK\_DEFINITION\_FAMILY](#output\_TASK\_DEFINITION\_FAMILY) | The ECS TaskDefinition Family |
| <a name="output_alb_dns"></a> [alb\_dns](#output\_alb\_dns) | The Application Load Balancer DNS |
<!-- END_TF_DOCS -->