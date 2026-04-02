
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
  cbs_satellite_bucket_name = "cbs-satellite-${local.inputs.account_id}"  
}
