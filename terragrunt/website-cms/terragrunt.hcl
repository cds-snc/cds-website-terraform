
include {
  path = find_in_parent_folders()
}

terraform {
  source = "../../components//website-cms"
}

inputs = {
  domain_name       = "strapi.cdssandbox.xyz"
  billing_tag_key   = "CostCentre"
  billing_tag_value = "WebsiteCMS"  
}
