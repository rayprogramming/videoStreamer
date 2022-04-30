<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_frontend"></a> [frontend](#module\_frontend) | rayprogramming/videoStreamer-cloudfront/aws | ~>2.0 |
| <a name="module_users"></a> [users](#module\_users) | rayprogramming/cognito-auth/aws | ~>1.0 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_zone.selected](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | The project name | `any` | n/a | yes |
| <a name="input_root_domain"></a> [root\_domain](#input\_root\_domain) | Root domain to deploy under. Must already exist, and will be deployed under as seperate zone. | `any` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->