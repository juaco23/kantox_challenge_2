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
| [aws_eip.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eip_count"></a> [eip\_count](#input\_eip\_count) | A number than determines the amount of eip to be created | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_eip_alloc_id"></a> [eip\_alloc\_id](#output\_eip\_alloc\_id) | The ID of the EIPs |
<!-- END_TF_DOCS -->