# **ECS service with dummy hello world**
-----------
## Description 
A simple container service hosted on ECS Fargate, with an ASG configured and deployed with the CodeDeploy Service.
Blue Green will be used as the deployment strategy, to be gradual and without application downtime.
It will have an associated Application Load Balancer that will deliver a valid SSL certificate to make the connection secure.
The deployment workflow is built with GitHub Actions and requires minimal configuration to be used.
## Step by Step Installation tutorial
### 1 - Infrastructure creation
In this step we build all the necessary infrastructure with Terraform.
* Go to the path: **terraform/my_environment** and customize the  **terraform.tfvars** file with yours values. Check above the INPUT reference if your not sure about to how to complete.
* Create a container definition file inside the path **/container-definitions**. The name of this file, must have the same of your **container_name** variable.

* Run the following Terraform command in your console :
*	 **terraform init**. 
*	 **terraform apply**. 
Check the log and accept writing **yes**.
* Save the outputs, then they will be used to complete the workflow file. If you didnt, dont worry! Run the following Terraform command to get them back: **terraform output**.

### 2 - Create a DNS in your hosted zone.
* Create in the hosted zone where the SSL certificate is validated, a record of the type cname or Alias with the domain name and as value the DNS output of the Application Load Balancer called: **alb_dns** .
The propagation time of this DNS depends on the provider.

### 3 - Check your service
* Check your service in a browser pasting your created DNS in previous step, you should see a simple **Hello World! from v1**.

### 4 - Configure the WorkFlow
* Open the file /.github/workflows/workflow.yml in your editor and complete the ENV VARIABLES. You can find all the data in the previously saved outputs.
* Save the file

### 5 - Configure the appspec.json file
* Open the /hello-world/appspec.json file in your editor, complete  the field "**ContainerName**" with the same value of the variable **container_name** and  "**ContainerPort**" with the same value of the variable **container_port**
* Save the file

### 6 - Run the Workflow and deploy a new release of your app.

* Make a change in the application like changing the Hello World message to v2, add the changes to stage, commit and push. Go to "Actions" secction on GitHub and check the progress.
The workflow will run automatically and create a new Docker image, tag it with the commit number, and then push it to ECR.
* It will then update the TaskDefinition with the newly created image and the appspec.json file with the new revision. And it will generate a new deployment in the CodeDeploy service.
It will terminate automatically once CodeDeploy confirms the deploy as successful

### 7 - Check the CodeDeploy service

* Inside the AWS CodeDeploy service, got to your application and your DeploymentGroup. You should see a running task inside.

### 8 - Check your new realese
* The CodeDeploy deployment is set to "**Blue / Green deployment strategy**" to deploy the new TaskDefinition revision. Double-check your DNS again and in minutes you should be able to see your new release in the browser. As you will see, this change is gradual and by percentage, delivering making the service not have any time without working.


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.15.1 |


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