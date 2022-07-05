variable "vpc_id" {
  type        = string
  description = "The VPC ID if you are not using default VPC."
  default     = ""
}
variable "instance_role" {
  type        = string
  description = "The name of the Instance Role you want to use, shouldn't need to be set unless you are doing something custom."
  default     = ""
}
variable "subnet_id" {
  type        = string
  description = "The subnet that you want the instance to deploy to, if you don't supply one, it will grab one from your VPC automatically."
  default     = ""
}
variable "instance_type" {
  type        = string
  description = "The instance type you would like to deploy."
  default     = "t3.micro"
}

variable "clandestine_port" {
  type        = number
  default     = null
  description = "This is the port you want MASQ to listen on for clandestine traffic.  This will be used for your config.toml and SG settings."
}
variable "name" {
  type        = string
  description = "The name you would like to give the instance.  This is purely for use inside of AWS, it won't show on the MASQ Network."
  default     = "MASQNode"
}
variable "chain" {
  type        = string
  description = "The name of the blockchain to use, eth-mainnet, eth-ropsten, polygon-mainnet, and polygon-mumbai are the only valid options."
  default     = "polygon-mumbai"
}
variable "bcsurl" {
  type        = string
  description = "The url of the blockchain service.  This defaults to ropsten url."
  default     = "https://ropsten.infura.io/v3/0ead23143b174f6983c76f69ddcf4026"
}
variable "dbpass" {
  type        = string
  description = "The password you would like to use for the MASQ DB."
  default     = "Whynotchangeme123"
}
variable "dnsservers" {
  type        = string
  description = "The DNS servers to use to resolve URLs for requests."
  default     = "1.0.0.1,1.1.1.1,8.8.8.8,9.9.9.9"
}
variable "gasprice" {
  type        = number
  description = "The gas price you are willing to pay to settle transactions."
  default     = 50
}
variable "paymentThresholds" { 
  type        = string
  description = "These are parameters that define thresholds to determine when and how much to pay other Nodes for routing"
  default     = ""
}
variable "ratePack" { 
  type        = string
  description = "These four parameters specify your rates that your Node will use for charging other Nodes for your provided services"
  default     = ""
}
variable "scanIntervals" { 
  type        = string
  description = "These three intervals describe the length of three different scan cycles running"
  default     = ""
}
variable "centralLogging" {
  type        = bool
  description = "Would you like to enable central logging via cloudwatch logs."
  default     = false
}
variable "customnNighbors" {
  type        = string
  description = ""
  default     = "Node Descriptors for connecting to the MASQ network. Separate with a ','"
}
variable "centralNighbors" {
  type        = bool
  description = "Gets official MASQ Node Descriptors"
  default     = true
}
variable "instance_count" {
  type        = number
  description = "Number of instances to create"
  default = 1
}

variable "mnemonic_list" {
  type        = list
  description = "List of mnemonic"
  default     = [""]
}
variable "earnwallet_list" {
  type = list
  description = "Array list of earnwallet"
  default = [""]
}
variable "downloadurl" {
  type        = string
  description = "URL of MASQ bin file, .zip formatt"
  default     = ""
}
variable "key_name" {
  type        = string
  description = "The name of the AWS Key Pair you want to use."
  default     = ""
}
variable "masterNode" {
  type        = bool
  description = "Is a Master Node"
  default     = false
}
variable "pushDescriptor" { 
  type        = bool
  description = "POST's the Descriptor to Cloud Node API"
  default     = false
}
variable "cycleDerivation" { 
  type        = bool
  description = "Cycles Wallet Derivation path"
  default     = false
}
variable "derivationIndex" { 
  type        = number
  description = "Index Derivation Cycle Starts from"
  default     = 0
}
variable "randomNighbors" {   
  type        = bool
  description = "Will pull a random Nighbor from NodeFinder"
  default     = false
}
