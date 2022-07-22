## Description
This module's purpose is to automatically deploy an EC2 to AWS and have it configure itself to be a node in the MASQ Network (masq.ai)

NOTE: This is still in Development

#TODO: NEEDS Updating

## Usage
We assume you have some working knowledge of Terraform to consume this module.
```HCL
provider "aws" {
    region = "ap-southeast-2"
    alias = "sydney"
}

module "masq_node" {
    source = "github.com/MASQ-Project/terraform-aws-masq-server?ref=v2.1.0"
    mnemonic_list     = [ "Red Orange Yellow Green Blue Indigo Violet" ]
    downloadurl       = "<masq.zip-URL>"
    derivationIndex   = 0
    instance_count    = 1
    customnNighbors   = "<MASQ-Nighbor-Descriptor>"
    providers         = { aws = aws.sydney }
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
| <a name="input_instance_role"></a> [instance\_role](#input\_instance\_role) | The name of the Instance Role you want to use, shouldn't need to be set unless you are doing something custom. | `string` | `""` | no |
| <a name="input_instance_type"></a> [instance\_type](#input\_instance\_type) | The instance type you would like to deploy. | `string` | `"t3.micro"` | no |
| <a name="input_name"></a> [name](#input\_name) | The name you would like to give the instance.  This is purely for use inside of AWS, it won't show on the MASQ Network. | `string` | `"MASQNode"` | no |
| <a name="input_subnet_id"></a> [subnet\_id](#input\_subnet\_id) | The subnet that you want the instance to deploy to, if you don't supply one, it will grab one from your VPC automatically. | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The VPC ID if you are not using default VPC. | `string` | `""` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | The name of the AWS Key Pair you want to use. | `string` | `""` | no |
| <a name="input_bcsurl"></a> [bcsurl](#input\_bcsurl) | The url of the blockchain service.  This defaults to ropsten url. | `string` | `"https://ropsten.infura.io/v3/0ead23143b174f6983c76f69ddcf4026"` | no |
| <a name="input_centralLogging"></a> [centralLogging](#input\_centralLogging) | Would you like to enable central logging via cloudwatch logs. | `bool` | `false` | no |
| <a name="input_chain"></a> [chain](#input\_chain) | The name of the blockchain to use, mainnet and ropsten are the only valid options. | `string` | `"ropsten"` | no |
| <a name="input_clandestine_port"></a> [clandestine\_port](#input\_clandestine\_port) | This is the port you want MASQ to listen on for clandestine traffic.  This will be used for your config.toml and SG settings. | `number` | `null` | no |
| <a name="input_conkey"></a> [conkey](#input\_conkey) | The private key to sign consuming transactions. | `string` | `""` | no |
| <a name="input_dbpass"></a> [dbpass](#input\_dbpass) | The password you would like to use for the MASQ DB. | `string` | `"Whynotchangeme123"` | no |
| <a name="input_dnsservers"></a> [dnsservers](#input\_dnsservers) | The DNS servers to use to resolve URLs for requests. | `string` | `"1.0.0.1,1.1.1.1,8.8.8.8,9.9.9.9"` | no |
| <a name="input_earnwallet"></a> [earnwallet](#input\_earnwallet) | The wallet address used for storing payments for services. | `string` | `""` | no |
| <a name="input_gasprice"></a> [gasprice](#input\_gasprice) | The gas price you are willing to pay to settle transactions. | `number` | `50` | no |
| <a name="input_loglevel"></a> [loglevel](#input\_loglevel) | MASQNode Log Level - [off, error, warn, info, debug, trace]. | `string` | `"trace"` | no |
| <a name="input_paymentThresholds"></a> [paymentThresholds](#input\_paymentThresholds) | These are parameters that define thresholds to determine when and how much to pay other Nodes for routing "1000000000\|1200\|1200\|500000000\|21600\|500000000" | `string` | `""` | no |
| <a name="input_ratePack"></a> [ratePack](#input\_ratePack) | These four parameters specify your rates that your Node will use for charging other Nodes for your provided services "1\|10\|2\|20"  | `string` | `""` | no |
| <a name="input_scanIntervals"></a> [scanIntervals](#input\_scanIntervals) | These three intervals describe the length of three different scan cycles running "600\|600\|600" | `string` | `""` | no |
| <a name="input_customnNighbors"></a> [customnNighbors](#input\_customnNighbors) | Node Descriptors for connecting to the MASQ network. Separate with a ','. | `string` | `""` | no |
| <a name="input_centralNighbors"></a> [centralNighbors](#input\_centralNighbors) | Gets official MASQ Node Descriptors. [customnNighbors](#input\_customnNighbors) will be ignored | `bool` | `false` | no |
| <a name="input_instance_count"></a> [instance\_count](#input\_instance\_count) | Number of instances to create. | `number` | `1` | no |
| <a name="input_mnemonic_list"></a> [mnemonic\_list](#input\_mnemonic\_list) | List of mnemonic. | `list` | `[""]` | yes |
| <a name="input_earnwallet_list"></a> [earnwallet\_list](#input\_earnwallet\_list) | List of earnwallets. | `list` | `[""]` | no |
| <a name="input_downloadurl"></a> [downloadurl](#input\_downloadurl) | URL of MASQ bin file, .zip formatt. | `string` | `""` | yes |
| <a name="input_pushDescriptor"></a> [pushDescriptor](#input\_pushDescriptor) | POST's Nodes Descriptor to Cloud_List API | `bool` | `false` | no |
| <a name="input_masterNode"></a> [masterNode](#input\_masterNode) | Use this to set Node as Master. | `bool` | `false` | no |
| <a name="input_cycleDerivation"></a> [cycleDerivation](#input\_cycleDerivation) | Cycles Wallet Derivation path by 1 for each node Created. | `bool` | `false` | no |
| <a name="input_derivationIndex"></a> [derivationIndex](#input\_derivationIndex) | Sets Derivation Index Start. | `number` | `0` | no |
| <a name="input_randomNighbors"></a> [randomNighbors](#input\_randomNighbors) | Will pull a random Nighbor from NodeFinder | `bool` | `false` | no |
| <a name="input_waitTime"></a> [waitTime](#input\_waitTime) | Time Range between Nodes connecting | `string` | `"30-120"` | no |
| <a name="input_nodeFinderChain"></a> [nodeFinderChain](#input\_nodeFinderChain) | Configure NodeFinders chain straing, 'polygon-mumbai',  | `string` | `"polygon-mumbai"` | no |
| <a name="input_nodeFinderSuburb"></a> [nodeFinderSuburb](#input\_nodeFinderSuburb) | Configure NodeFinders Suburb straing.   | `string` | `""` | no |



## Outputs

| Name | Description |
|------|-------------|
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | n/a |
<!-- END_TF_DOCS -->
