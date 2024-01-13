variable "aws_region" {
  type = string
}
variable "task_cpu" {
  type    = number
  default = 1024
}

variable "task_memory" {
  type    = number
  default = 2048
}

variable "aws_ecr_url" {
  type = string
}

variable "container_image_version" {
  type    = string
  default = "latest"
}

variable "cloudwatch_log_group_name" {
  type = string
}
variable "cloudwatch_log_prefix" {
  type = string
}
