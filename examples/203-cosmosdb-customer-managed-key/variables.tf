variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = null
}

variable "cosmos_enterprise_app_service_principal_object_id" {
  type    = string
  description = "Object id for enterprise application named `Azure Cosmos DB`. Leave this variable `null` would query the object via `azuread` provider, which requires corresponding permission."
  default = null
}

variable "location" {
  type        = string
  description = "Azure Region"
  default     = "eastus"
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
    sql_unique_key             = list(string)
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