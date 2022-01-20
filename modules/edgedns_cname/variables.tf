variable "dv_records" {
  description = "Dynamic map of our DV keys we need to create"
  type        = map(any)
}

variable "hostnames" {
  description = "Our known list of hostnames where we need to create DV keys for."
  type        = set(string)
}
