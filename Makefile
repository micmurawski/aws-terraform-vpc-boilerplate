#
# Configuration
#

PROJECT_NAME = example-aws-vpc
AWS_REGION ?= us-east-1
TERRAFORM_BACKEND_KEY= $(PROJECT_NAME)/terraform.tfstate

include build/makefile/root.mk
include build/makefile/terraform.mk

export TF_VAR_environment=$(FM_ENVIRONMENT)
export TF_VAR_stage=$(FM_STAGE)
export TF_VAR_base_domain_name=$(FM_BASE_DOMAIN_NAME)

test: terraform_validate

.PHONY: project_name
project_name:
	@echo -n $(PROJECT_NAME)
