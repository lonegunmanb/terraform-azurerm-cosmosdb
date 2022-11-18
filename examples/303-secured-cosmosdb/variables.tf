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

variable "cosmos_enterprise_app_service_principal_object_id" {
  type        = string
  description = "Object id for enterprise application named `Azure Cosmos DB`. Leave this variable `null` would query the object via `azuread` provider, which requires corresponding permission."
  default     = null
}

variable "resource_group_name_read_replica" {
  type        = string
  description = "Read Replica Resource Group Name"
  default     = null
}

variable "location_read_replica" {
  type        = string
  description = "Read Replica Azure Region"
  default     = "northeurope"
}

variable "managed_identity_principal_id" {
  type    = string
  default = null
}

variable "key_vault_name" {
  type        = string
  description = "Name of the Key Vault."
  default     = "standard"
}

variable "sku_name" {
  type        = string
  description = "The Name of the SKU for Key Vault. Possible values are standard and premium"
  default     = "standard"
}

variable "key_vault_key_name" {
  type        = string
  description = "Name of the Key which is going to be created and used for encrytpion."
  default     = "standard"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual Network Name"
  default     = "samplevnet_303"
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

variable "virtual_network_name_read_replica" {
  type        = string
  description = "Virtual Network Name for read replica"
  default     = "samplevnet_rr_303"
}

variable "vnet_address_space_read_replica" {
  type        = list(string)
  description = "VNET Address Prefixes for read replica"
  default     = ["11.0.0.0/16"]
}

variable "subnet_name_read_replica" {
  type        = string
  description = "VNET Subnet Name for read replica"
  default     = "pe_rr_subnet"
}

variable "subnet_prefixes_read_replica" {
  type        = list(string)
  description = "Subnet Address Prefixes for read replica"
  default     = ["11.0.0.0/24"]
}

variable "private_dns_vnet_link_name_read_replica" {
  type        = string
  description = "Private DNS Zone Link Name for read replica"
  default     = "sqlapi_rr_zone_link"
}

variable "dns_zone_group_name_read_replica" {
  type        = string
  description = "Zone Group Name for PE for read replica"
  default     = "pe_rr_zone_group"
}

variable "pe_name_read_replica" {
  type        = string
  description = "Private Endpoint Name for read replica"
  default     = "cosmosdb_rr_pe"
}

variable "pe_connection_name_read_replica" {
  type        = string
  description = "Private Endpoint Connection Name for read replica"
  default     = "pe_rr_connection"
}


variable "log_analytics_workspace_name" {
  type        = string
  description = "Log Analytics Workspace Name"
  default     = "exampleanalyticsforcosmosdb"
}

variable "cosmos_account_name" {
  type    = string
  default = ""
}

variable "cosmos_api" {
  type    = string
  default = "sql"
}

variable "geo_locations" {
  type = list(object({
    geo_location      = string
    failover_priority = number
    zone_redundant    = bool
  }))
  default = [
    {
      geo_location      = "eastus"
      failover_priority = 0
      zone_redundant    = false
    },
    {
      geo_location      = "westus"
      failover_priority = 1
      zone_redundant    = false
    }
  ]
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
