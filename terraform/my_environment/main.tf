############################################################################
############################## GENERAL #####################################
############################################################################

locals {
  name_prefix = "${var.environment}-${var.application_name}"
  azones      = formatlist("${var.region}%s", var.availability_zones)
  tags = {
    Environment = var.environment
    Region      = var.region
    Owner       = "poc"
  }
}


############################################################################
############################## GITHUB ROLE #################################
############################################################################

module "oidc_github" {
  source         = "../aws_modules/oidc_github"
  client_id_list = var.client_id_list
  repo_name      = var.repo_name
  region         = var.region

  #permissions
  ecs_role_arn                = module.ecs_services.ecs_role_arn
  ecs_service_name            = module.ecs_services.service_name
  ecs_cluster_name            = module.ecs_cluster.cluster_name
  codedeploy_application_name = module.codedeploy.aws_codedeploy_app_name
  codedeploy_dg               = module.codedeploy.deployment_group_name
  ecr_repository_arn          = module.ecr.ecr_repository_arn
}


############################################################################
#################################### ECR ###################################
############################################################################

module "ecr" {
  source = "../aws_modules/ecr"
  name   = "${local.name_prefix}-repo"
  tags   = local.tags

}


############################################################################
####################### APPLICATION LOAD BALANCER ##########################
############################################################################

module "alb" {
  source      = "../aws_modules/alb"
  subnets     = module.public_subnets.subnet_ids
  vpc_id      = module.vpc.id
  tags        = local.tags
  name_prefix = local.name_prefix

  ssl_certificate   = var.ssl_certificate
  target_group_port = var.container_port
}


############################################################################
############################# CODEDEPLOY ###################################
############################################################################

module "codedeploy" {
  source                         = "../aws_modules/codedeploy"
  name_prefix                    = local.name_prefix
  ecs_cluster_name               = module.ecs_cluster.cluster_name
  ecs_service_name               = module.ecs_services.service_name
  aws_lb_listener_green_arn      = module.alb.aws_lb_listener_green_arn
  aws_lb_listener_blue_arn       = module.alb.aws_lb_listener_blue_arn
  aws_lb_target_group_green_name = module.alb.aws_lb_target_group_green_name
  aws_lb_target_group_blue_name  = module.alb.aws_lb_target_group_blue_name

  depends_on = [module.ecs_services]

}


############################################################################
################################# ECS ######################################
############################################################################

## ECS IAM PROFILE

module "ecs_profile" {
  source = "../aws_modules/ecs/instance_profile"
  name   = "${local.name_prefix}-ip"
  tags   = local.tags
}

## ECS CLUSTER

module "ecs_cluster" {
  source             = "../aws_modules/ecs/cluster"
  name               = "${local.name_prefix}-cl"
  container_insights = var.container_insights
  tags               = local.tags

}


## ECS SERVICE

module "ecs_services" {
  source           = "../aws_modules/ecs/service"
  target_group_arn = module.alb.aws_lb_target_group_green_arn
  name_prefix      = local.name_prefix
  name             = var.container_name

  ## TASK DEFINITION
  task_cpu       = var.task_cpu
  task_memory    = var.task_memory
  container_port = var.container_port

  ## TASK DEFINITION CONTAINER DEFINITION

  container_definition = templatefile("./container-definitions/${var.container_name}.json", {
    name      = "${var.container_name}"
    region    = "${var.region}"
    log_group = "${local.name_prefix}-${var.container_name}"
  })
  ## NETWORKING
  applications_subnets = module.application_subnet.subnet_ids
  vpc_id               = module.vpc.id
  alb_sg_id            = module.alb.alb_sg_id
  ## ASG
  max_capacity        = var.max_capacity
  min_capacity        = var.min_capacity
  cpu_target_value    = var.cpu_target_value
  memory_target_value = var.memory_target_value

  ## TAGS
  tags = local.tags

  depends_on = [
    module.ecs_cluster
  ]
}


############################################################################
########################## NETWORKING ######################################
############################################################################

module "vpc" {
  source               = "../aws_modules/vpc/aws_vpc"
  environment          = var.environment
  name                 = var.application_name
  cidr_block           = var.vpc_cidr_block
  identifier_tags      = var.tags
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = "true"
  enable_dns_support   = "true"
}

module "internet_gateway" {
  source          = "../aws_modules/vpc/aws_igw"
  name            = var.application_name
  vpc_id          = module.vpc.id
  environment     = var.environment
  identifier_tags = local.tags
}

module "nat_gateway" {
  source          = "../aws_modules/vpc/aws_nat_gw"
  environment     = var.environment
  nat_subnet_ids  = module.public_subnets.subnet_ids
  name            = "${local.name_prefix}-ng"
  ngw_count       = length(local.azones)
  vpc_id          = module.vpc.id
  identifier_tags = var.tags
  owner           = "poc"
}

module "public_subnets" {
  source                 = "../aws_modules/vpc/aws_subnet_setup"
  name                   = local.name_prefix
  environment            = var.environment
  vpc_id                 = module.vpc.id
  cidr_block             = module.vpc.cidr_block
  subnet_size            = var.subnet_size
  available_az           = local.azones
  is_public              = true
  gw_id                  = module.internet_gateway.igw_id
  gw_count               = length(local.azones)
  subnet_count           = length(local.azones)
  subnet_assignment_list = split(",", lookup(var.subnet_assignment, "public", 0))
  subnet_type            = "public"
}

module "application_subnet" {
  source                 = "../aws_modules/vpc/aws_subnet_setup"
  name                   = local.name_prefix
  vpc_id                 = module.vpc.id
  available_az           = local.azones
  subnet_count           = length(local.azones)
  environment            = var.environment
  subnet_size            = var.subnet_size
  cidr_block             = module.vpc.cidr_block
  subnet_assignment_list = split(",", lookup(var.subnet_assignment, "application", 0))
  subnet_type            = "application"
  ngw_id_list            = module.nat_gateway.ngw_ids
  is_public              = false
  ngw_count              = length(local.azones)
}
