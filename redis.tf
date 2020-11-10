module "redis" {
  source  = "umotif-public/elasticache-redis/aws"
  version = "1.0.1"

  name_prefix           = "jango-${var.Environment}"
  number_cache_clusters = 2
  node_type             = "cache.t3.small"

  engine_version             = "5.0.6"
  port                       = 6379
  maintenance_window         = "mon:03:00-mon:04:00"
  snapshot_window            = "04:00-06:00"
  snapshot_retention_limit   = 7
  automatic_failover_enabled = true

  at_rest_encryption_enabled = true
  transit_encryption_enabled = true
  auth_token                 = "1234567890asdfghjkl"

  apply_immediately = true
  family            = "redis5.0"
  description       = "Test elasticache redis."

  subnet_ids = module.vpc.private_subnets
  vpc_id     = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]

  parameter = [
    {
      name  = "repl-backlog-size"
      value = "16384"
    }
  ]

  tags = {
    Project = "jango"
  }
}
