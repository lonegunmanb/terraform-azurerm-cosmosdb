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
  default = "cassandra"
}

variable "cassandra_keyspaces" {
  type = map(object({
    keyspace_name           = string
    keyspace_throughput     = number
    keyspace_max_throughput = number
  }))
  default = {
    one = {
      keyspace_name           = "keyspacenoautoscale"
      keyspace_throughput     = 400
      keyspace_max_throughput = null
    },
    two = {
      keyspace_name           = "keyspaceautoscale"
      keyspace_throughput     = null
      keyspace_max_throughput = 1000
    }
  }
}

variable "cassandra_tables" {
  type = map(object({
    table_name             = string
    keyspace_name          = string
    default_ttl_seconds    = string
    analytical_storage_ttl = number
    table_throughout       = number
    table_max_throughput   = number
    cassandra_schema_settings = object({
      column = map(object({
        column_key_name = string
        column_key_type = string
      }))
      partition_key = map(object({
        partition_key_name = string
      }))
      cluster_key = map(object({
        cluster_key_name     = string
        cluster_key_order_by = string
      }))
    })
  }))
  default = {
    one = {
      keyspace_name        = "keyspaceautoscale"
      table_name           = "table1"
      default_ttl_seconds  = "86400"
      analytical_storage_ttl = null
      table_throughout     = 400
      table_max_throughput = null
      cassandra_schema_settings = {
        column  = {
          columnone = {
            column_key_name      = "loadid"
            column_key_type      = "uuid"
          },
          columntwo = {
            column_key_name      = "machine"
            column_key_type      = "uuid"
          },
          columnthree = {
            column_key_name      = "mtime"
            column_key_type      = "int"
          }
        }
        partition_key = {
          partition_key_one = {
            partition_key_name   = "loadid"
          }
        }
        cluster_key = null
      }
    },
    two = {
      keyspace_name        = "keyspacenoautoscale"
      table_name           = "table2"
      default_ttl_seconds  = "86400"
      analytical_storage_ttl = null
      table_throughout     = 400
      table_max_throughput = null
      cassandra_schema_settings = {
        column  = {
          columntwo = {
            column_key_name      = "loadid"
            column_key_type      = "uuid"
          }
        }
        partition_key = {
          partition_key_two = {
            partition_key_name   = "loadid"
          }
        }
        cluster_key = null
      }
    }
  }
}