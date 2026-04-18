variable "workload" {
  type        = string
  description = "Workload or platform layer name used in resource naming."
}

variable "location" {
  type        = string
  description = "Resource location for Azure resources."
  default     = "uksouth"
}

variable "location_short" {
  type        = string
  description = "Short Azure region code (e.g. uks, ukw)."
  default     = "uks"
}

variable "instance" {
  type        = string
  description = "Two-digit instance number (e.g. 01)."
  default     = "01"
}

variable "environment" {
  type        = string
  description = "Name of Azure environment."
  default     = "dev"
}
