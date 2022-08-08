variable "name" {
  description = "Name to be used on all the resources as identifier"
  type        = string
}

variable "container_insights" {
  description = "Enable or disable Container Insights"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to instance profile role"
  type        = map(string)
  default     = {}
}
