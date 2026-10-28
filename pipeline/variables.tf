variable "environment" {
  description = "Deployment Environment (dev or prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "db_name" {
  description = "Name of the database created in the cluster"
  type        = string
  default     = "appdb"
}