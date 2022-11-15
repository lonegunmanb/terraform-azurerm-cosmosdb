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
  default = "gremlin"
}
variable "gremlin_dbs" {
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
variable "gremlin_graphs" {
  type = map(object({
    graph_name            = string
    db_name               = string
    partition_key_path    = string
    partition_key_version = number
    default_ttl_seconds   = string
    graph_throughput      = number
    graph_max_throughput  = number
    index_policy_settings = object({
      indexing_automatic = bool
      indexing_mode      = string
      included_paths     = list(string)
      excluded_paths     = list(string)
      composite_indexes = map(object({
        indexes = set(object({
          index_path  = string
          index_order = string
        }))
      }))
      spatial_indexes = map(object({
        spatial_index_path = string
      }))
    })
    conflict_resolution_policy = object({
      mode      = string
      path      = string
      procedure = string
    })
    unique_key = list(string)
  }))
  default = {
    one = {
      graph_name                        = "graph1"
      db_name                           = "dbautoscale"
      partition_key_path                = "/Example"
      partition_key_version             = 2
      default_ttl_seconds               = 86400
      graph_throughput                  = 400
      graph_max_throughput              = null
      index_policy_settings             = {
        indexing_automatic        = true
        indexing_mode             = "consistent"
        included_paths            = ["/*"]
        excluded_paths            = ["/\"_etag\"/?"]
        composite_indexes         = {
          compositeindexesone             = {
            indexes  = [
              {
                index_path  = "/container/name"
                index_order = "Ascending"
              },
              {
                index_path  = "/container/id"
                index_order = "Ascending"
              }
            ]
          }
        }
        spatial_indexes = {
          one = {
            spatial_index_path = "/*"
          }
        }
      }
      conflict_resolution_policy  = null
      unique_key =  ["/container/id"]
    },
    two = {
      graph_name                        = "graph2"
      db_name                           = "dbnoautoscale"
      partition_key_path                = "/Example"
      partition_key_version             = 2
      default_ttl_seconds               = 86400
      graph_throughput                  = null
      graph_max_throughput              = 1000
      index_policy_settings             = {
        indexing_automatic        = true
        indexing_mode             = "consistent"
        included_paths            = ["/*"]
        excluded_paths            = ["/\"_etag\"/?"]
        composite_indexes         = null
        spatial_indexes = null
      }
      conflict_resolution_policy  = null
      unique_key = ["/container/id"]
    }
  }
}