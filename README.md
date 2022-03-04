## Description
This module's purpose is to automatically deploy an EC2 to AWS and have it configure itself to be a node in the MASQ Network (masq.ai)

NOTE: This is still in Development

#TODO: NEEDS Updating

## Usage
We assume you have some working knowledge of Terraform to consume this module.
```HCL
module "masq_node" {
    source = "github.com/MASQ-Project/terraform-aws-masq-server?ref=v1.0.4"
    mnemonic = "Red Orange Yellow Green Blue Indigo Violet"


}
```
<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |
| <a name="provider_random"></a> [random](#provider\_random) | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bcsurl"></a> [bcsurl](#input\_bcsurl) | The url of the blockchain service.  This defaults to ropsten url. | `string` | `"https://ropsten.infura.io/v3/0ead23143b174f6983c76f69ddcf4026"` | no |
| <a name="input_centralLogging"></a> [centralLogging](#input\_centralLogging) | Would you like to enable central logging via cloudwatch logs. | `bool` | `false` | no |
| <a name="input_chain"></a> [chain](#input\_chain) | The name of the blockchain to use, mainnet and ropsten are the only valid options. | `string` | `"ropsten"` | no |
| <a name="input_clandestine_port"></a> [clandestine\_port](#input\_clandestine\_port) | This is the port you want MASQ to listen on for clandestine traffic.  This will be used for your config.toml and SG settings. | `number` | `null` | no |
| <a name="input_conkey"></a> [conkey](#input\_conkey) | The private key to sign consuming transactions. | `string` | `""` | no |
| <a name="input_dbpass"></a> [dbpass](#input\_dbpass) | The password you would like to use for the MASQ DB. | `string` | `"Whynotchangeme123"` | no |
| <a name="input_dnsservers"></a> [dnsservers](#input\_dnsservers) | The DNS servers to use to resolve URLs for requests. | `string` | `"1.0.0.1,1.1.1.1,8.8.8.8,9.9.9.9"` | no |
| <a name="input_earnwallet"></a> [earnwallet](#input\_earnwallet) | The wallet address used for storing payments for services. | `string` | `""` | no |
| <a name="input_gasprice"></a> [gasprice](#input\_gasprice) | The gas price you are willing to pay to settle transactions. | `number` | `50` | no |
| <a name="input_instance_role"></a> [instance\_role](#input\_instance\_role) | The name of the Instance Role you want to use, shouldn't need to be set unless you are doing something custom. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type you would like to deploy. | `string` | `"t3.micro"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the AWS Key Pair you want to use. | `string` | `""` | no |
| <a name="input_mnemonic"></a> [mnemonic](#input\_mnemonic) | The mnemonic phrase used to generate your MASQ wallet | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name you would like to give the instance.  This is purely for use inside of AWS, it won't show on the MASQ Network. | `string` | `"MASQNode"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet that you want the instance to deploy to, if you don't supply one, it will grab one from your VPC automatically. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID if you are not using default VPC. | `string` | `""` | no |
| <a name="input_customnNighbors"></a> [customnNighbors](#input\_customnNighbors) | Node Descriptors for connecting to the MASQ network. Separate with a ','. | `string` | `""` | no |
| <a name="input_centralNighbors"></a> [centralNighbors](#input\_centralNighbors) | Gets official MASQ Node Descriptors. | `bool` | `false` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create. | `number` | `1` | no |
| <a name="input_mnemonic_list"></a> [mnemonic\_list](#input\_mnemonic\_list) | List of mnemonic. | `list` | `[""]` | no |
| <a name="input_earnwallet_list"></a> [earnwallet\_list](#input\_earnwallet\_list) | List of earnwallets. | `list` | `[""]` | no |
| <a name="input_downloadurl"></a> [downloadurl](#input\_downloadurl) | URL of MASQ bin file, .zip formatt. | `string` | `""` | no |



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
<!-- END_TF_DOCS -->