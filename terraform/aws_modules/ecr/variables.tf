variable "name" {
  type        = string
  description = "Name of the repository"
}
variable "image_tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  default     = "IMMUTABLE"
}
variable "scan_on_push" {
  type        = string
  description = "Indicates whether images are scanned after being pushed to the repository (true) or not scanned (false)"
  default     = "true"
}
variable "tags" {
  type        = map(any)
  default     = {}
  description = "Additional tags (e.g. map(`BusinessUnit`,`XYZ`)"
}