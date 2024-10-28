variable "cluster_id" {}
variable "elasticache_engine" {}
variable "node_type" {}
variable "num_cache_nodes" {}
variable "parameter_group_name" {}
variable "elasticache_engine_version" {}
variable "port" {}
variable "subnet_ids" { type = list(string) }
// variable "security_group_ids" { type = list(string) }
variable "maintenance_window" {}
variable "snapshot_window" {}
variable "snapshot_retention_limit" {}
variable "automatic_failover_enabled" {}
variable "at_rest_encryption_enabled" {}
variable "transit_encryption_enabled" {}
variable "apply_immediately" {}
variable "vpc_id" {}
