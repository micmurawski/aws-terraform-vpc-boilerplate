#
# Configuration
#

PROJECT_NAME = example-aws-vpc
AWS_REGION ?= us-east-1
TERRAFORM_BACKEND_KEY= $(PROJECT_NAME)/terraform.tfstate

include build/makefile/root.mk
include build/makefile/terraform.mk

export TF_VAR_environment=$(ENVIRONMENT)
export TF_VAR_stage=$(STAGE)
export TF_VAR_base_domain_name=$(BASE_DOMAIN_NAME)

test: terraform_validate

.PHONY: project_name
project_name:
	@echo -n $(PROJECT_NAME)
