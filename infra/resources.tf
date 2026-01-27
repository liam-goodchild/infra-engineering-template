resource "null_resource" "placeholder" {
  triggers = {
    prefix       = local.prefix
    prefix_short = local.prefix_short
    st_naming    = jsonencode(local.st_naming)
    tags         = jsonencode(local.tags)
  }
}
