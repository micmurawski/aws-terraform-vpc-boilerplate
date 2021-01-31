#
# Public Variables
#

TERRAFORM_DIR = infra/terraform
TFENV_VERSION = 2.0.0

#
# Functions
#

terraform_get_output  = $(shell cat $(TERRAFORM_STATE_CACHE) | $(JQ) .$(1).value)

#
# Private Variables
#

TFENV_DIR := $(if $(shell command -v tfenv),$(shell dirname $$(dirname $$(command -v tfenv))),$(CACHE_DIR)/tfenv)
TFENV ?= $(TFENV_DIR)/bin/tfenv
TERRAFORM ?= $(TFENV_DIR)/bin/terraform
TERRAFORM_BACKEND_COFNIG?="bucket=$(TERRAFORM_BUCKET),region=$(AWS_REGION),key=$(TERRAFORM_BACKEND_KEY)"

TERRAFORM_STATE_CACHE := $(CACHE_DIR)/$(TERRAFORM_WORKSPACE_NAME)-state.json

TERRAFORM_FILES := $(shell find $(TERRAFORM_DIR) -type f -iname "*.tf")

#
# Integration with root makefile
#

setup: terraform_init
deploy: terraform_apply
test: terraform_validate
destroy: terraform_destroy
clean: terraform_clean
distclean: terraform_distclean

#
# Targets
#

.PHONY: terraform_plan
terraform_plan: $(TERRAFORM) terraform_init infra/terraform/tfplan.out
	@


infra/terraform/tfplan.out: $(CACHE_DIR) $(TERRAFORM_FILES) terraform_init
	env | sort | grep TF_VAR
	cd infra/terraform && $(TERRAFORM) plan -out tfplan.out


.PHONY: terraform_apply
terraform_apply: terraform_plan
ifneq ($(ALLOW_DEPLOY),true)
	$(error "Cannot apply Terraform when ALLOW_DEPLOY is false")
endif
	cd infra/terraform && $(TERRAFORM) apply -auto-approve tfplan.out
	rm infra/terraform/tfplan.out

.PHONY: terraform_refresh
terraform_refresh: $(TERRAFORM) terraform_validate terraform_init
ifneq ($(ALLOW_DEPLOY),true)
	$(error "Cannot apply Terraform when ALLOW_DEPLOY is false")
endif
	cd infra/terraform && $(TERRAFORM) refresh


.PHONY: terraform_destroy
terraform_destroy: $(TERRAFORM) terraform_init
ifneq ($(ALLOW_DEPLOY),true)
	$(error "Cannot destroy Terraform state when ALLOW_DEPLOY is false")
endif
	cd infra/terraform && $(TERRAFORM) destroy -auto-approve


.PHONY: terraform_validate
terraform_validate: export AWS_DEFAULT_REGION=$(AWS_REGION)
terraform_validate: infra/terraform/backend.tf $(TERRAFORM) terraform_init
	cd infra/terraform && $(TERRAFORM) validate


.PHONY: terraform_init
terraform_init: $(TERRAFORM)
	cd infra/terraform && $(TERRAFORM) init -backend-config=$(TERRAFORM_BACKEND_COFNIG) -backend=$(ALLOW_DEPLOY)
ifeq ($(ALLOW_DEPLOY),true)
	cd infra/terraform && $(TERRAFORM) workspace select $(TERRAFORM_WORKSPACE_NAME) || $(TERRAFORM) workspace new $(TERRAFORM_WORKSPACE_NAME)
endif


.PHONY: terraform_state
terraform_state: $(TERRAFORM_STATE_CACHE)
	@:


# State should be redownloaded on each separate invocation of make.
.PHONY: $(TERRAFORM_STATE_CACHE)
$(TERRAFORM_STATE_CACHE): terraform_init
ifneq ($(ALLOW_DEPLOY),true)
	$(error "Cannot download Terraform state when ALLOW_DEPLOY is false")
endif
	cd infra/terraform && $(TERRAFORM) output -json | tee "$@"


.PHONY: terraform_clean
terraform_clean:
	rm -rf infra/terraform/.terraform
	rm -rf infra/terraform/tfplan.out


.PHONY: terraform_distclean
terraform_distclean:
	rm -rf $(CACHE_DIR)/tfenv

#
# Install Terraform
#

$(TFENV_DIR):
	curl -L "https://github.com/tfutils/tfenv/archive/v$(TFENV_VERSION).tar.gz" -o "/tmp/tfenv.tar.gz"
	mkdir -p $(TFENV_DIR)
	cd $(TFENV_DIR) && tar xzvf /tmp/tfenv.tar.gz --strip 1


$(TERRAFORM): $(TFENV_DIR)
	cd infra/terraform && PATH="$(PATH):$(TFENV_DIR)/bin" && $(TFENV) install $(shell cat infra/terraform/.terraform-version || printf "latest")
	cd infra/terraform && PATH="$(PATH):$(TFENV_DIR)/bin" && $(TFENV) use $(shell cat infra/terraform/.terraform-version || printf "latest")


.PHONY: terraform_fmt
terraform_fmt: $(TERRAFORM)
	cd infra/terraform && $(TERRAFORM) fmt -recursive
