variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = null
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "westeurope"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual Network Name"
  default     = "samplevnet_202"
}

variable "vnet_address_space" {
  type        = list(string)
  description = "VNET Address Prefixes"
  default     = ["10.0.0.0/16"]
}

variable "subnet_name" {
  type        = string
  description = "VNET Subnet Name"
  default     = "pe_subnet"
}

variable "subnet_prefixes" {
  type        = list(string)
  description = "Subnet Address Prefixes"
  default     = ["10.0.0.0/24"]
}

variable "private_dns_vnet_link_name" {
  type        = string
  description = "Private DNS Zone Link Name"
  default     = "sqlapi_zone_link"
}

variable "dns_zone_group_name" {
  type        = string
  description = "Zone Group Name for PE"
  default     = "pe_zone_group"
}

variable "pe_name" {
  type        = string
  description = "Private Endpoint Name"
  default     = "cosmosdb_pe"
}

variable "pe_connection_name" {
  type        = string
  description = "Private Endpoint Connection Name"
  default     = "pe_connection"
}

variable "cosmos_account_name" {
  type    = string
  default = ""
}

variable "cosmos_api" {
  type    = string
  default = "sql"
}

variable "sql_dbs" {
  type = map(object({
    db_name           = string
    db_throughput     = number
    db_max_throughput = number
  }))
  default = {
    one = {
      db_name           = "dbnoautoscale"
      db_throughput     = 400
      db_max_throughput = null
    },
    two = {
      db_name           = "dbautoscale"
      db_throughput     = null
      db_max_throughput = 1000
    }
  }
}
variable "sql_db_containers" {
  type = map(object({
    container_name           = string
    db_name                  = string
    partition_key_path       = string
    partition_key_version    = number
    container_throughout     = number
    container_max_throughput = number
    default_ttl              = number
    analytical_storage_ttl   = number
    indexing_policy_settings = object({
      sql_indexing_mode = string
      sql_included_path = string
      sql_excluded_path = string
      composite_indexes = map(object({
        indexes = set(object({
          path  = string
          order = string
        }))
      }))
      spatial_indexes = map(object({
        path = string
      }))
    })
    sql_unique_key = list(string)
    conflict_resolution_policy = object({
      mode      = string
      path      = string
      procedure = string
    })
  }))
  default = {
    one = {
      container_name           = "container1"
      db_name                  = "dbnoautoscale"
      partition_key_path       = "/container/id"
      partition_key_version    = 2
      container_throughout     = 400
      container_max_throughput = null
      default_ttl              = null
      analytical_storage_ttl   = null
      indexing_policy_settings = {
        sql_indexing_mode = "consistent"
        sql_included_path = "/*"
        sql_excluded_path = null
        composite_indexes = {
          compositeindexone = {
            indexes = [
              {
                path  = "/container/name"
                order = "Ascending"
              },
              {
                path  = "/container/id"
                order = "Ascending"
              }
            ]
          }
        }
        spatial_indexes = {
          spatialindexone = {
            path = "/*"
          }
        }
      }
      sql_unique_key             = ["/container/id"]
      conflict_resolution_policy = null
    }
    two = {
      container_name           = "container1"
      db_name                  = "dbautoscale"
      partition_key_path       = "/container/id"
      partition_key_version    = 2
      container_throughout     = 500
      container_max_throughput = null
      default_ttl              = null
      analytical_storage_ttl   = null
      indexing_policy_settings = {
        sql_indexing_mode = "consistent"
        sql_included_path = "/*"
        sql_excluded_path = "/excluded/?"
        composite_indexes = {}
        spatial_indexes   = {}
      }
      sql_unique_key             = ["/container/id"]
      conflict_resolution_policy = null
    }
  }
}