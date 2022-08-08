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
| [aws_route.gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.instance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.ngw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.vpc_peering](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dst_cidr_block"></a> [dst\_cidr\_block](#input\_dst\_cidr\_block) | The CIDR block of the destination | `string` | n/a | yes |
| <a name="input_route_table_ids"></a> [route\_table\_ids](#input\_route\_table\_ids) | List of route table ids | `list(any)` | n/a | yes |
| <a name="input_gw_count"></a> [gw\_count](#input\_gw\_count) | The amount of igw or vgw | `number` | `"0"` | no |
| <a name="input_gw_id_list"></a> [gw\_id\_list](#input\_gw\_id\_list) | A list of igw or vgw IDs | `list(any)` | `[]` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | The amount of instances | `string` | `"0"` | no |
| <a name="input_instance_id"></a> [instance\_id](#input\_instance\_id) | A list of the instances IDs | `list(any)` | `[]` | no |
| <a name="input_ngw_count"></a> [ngw\_count](#input\_ngw\_count) | The amount of NAT gateways | `number` | `"0"` | no |
| <a name="input_ngw_id_list"></a> [ngw\_id\_list](#input\_ngw\_id\_list) | A list of NAT gateways' IDs | `list(any)` | `[]` | no |
| <a name="input_vpc_peering_count"></a> [vpc\_peering\_count](#input\_vpc\_peering\_count) | The amount of VPC peering | `string` | `"0"` | no |
| <a name="input_vpc_peering_id"></a> [vpc\_peering\_id](#input\_vpc\_peering\_id) | The ID of the VPC peering | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->