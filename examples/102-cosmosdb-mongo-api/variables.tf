variable "resource_group_name" {
  type        = string
  description = "Resource Group Name"
  default     = null
}

variable "location" {
  type        = string
  description = "Azure Region"
  default = "westeurope"
}

variable "cosmos_account_name" {
  type    = string
  default = ""
}
variable "cosmos_api" {
  type    = string
  default = "mongo"
}
variable "mongo_dbs" {
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
variable "mongo_db_collections" {
  type = map(object({
    collection_name           = string
    db_name                   = string
    default_ttl_seconds       = string
    shard_key                 = string
    collection_throughout     = number
    collection_max_throughput = number
    analytical_storage_ttl    = number
    indexes = map(object({
      mongo_index_keys   = list(string)
      mongo_index_unique = bool
    }))
  }))
  default = {
    one = {
      collection_name           = "collection1"
      db_name                   = "dbautoscale"
      default_ttl_seconds       = "2592000"
      shard_key                 = "MyShardKey"
      collection_throughout     = 400
      collection_max_throughput = null
      analytical_storage_ttl    = null
      indexes                   = {
        indexone                = {
          mongo_index_keys          = ["_id"]
          mongo_index_unique        = true
        }
      }
    },
    two = {
      collection_name           = "collection2"
      db_name                   = "dbnoautoscale"
      default_ttl_seconds       = "2592000"
      shard_key                 = "MyShardKey"
      collection_throughout     = 400
      collection_max_throughput = null
      analytical_storage_ttl    = null
      indexes                   = {
        indextwo                = {
          mongo_index_keys          = ["_id"]
          mongo_index_unique        = true
        }
      }
    }
  }
}