variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default = null
}

variable "location" {
  type        = string
  description = "Azure Region"
  default = "eastus"
}

variable "cosmos_account_name" {
  type = string
  default = ""
}
variable "cosmos_api" {
  type = string
  default = "table"
}
variable "tables" {
  type = map(object({
    table_name           = string
    table_throughput     = number
    table_max_throughput = number
  }))
  default = {
    one = {
      table_name           = "tablenoautoscale"
      table_throughput     = 400
      table_max_throughput = null
    },
    two = {
      table_name           = "tableautoscale"
      table_throughput     = null
      table_max_throughput = 1000
    }
  }
}