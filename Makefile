fmt:
	terraform fmt -recursive components && terragrunt hclfmt

apply-website-cms:
	cd terragrunt/website-cms &&\
	terragrunt apply-all --terragrunt-non-interactive

plan-website-cms:
	cd terragrunt/website-cms &&\
	terragrunt plan-all --terragrunt-non-interactive
