check_environment:
	@test "${ENVIRONMENT}" || (echo '$$ENVIRONMENT name required' && exit 1)

clean:
	@rm -rf plan .terraform

init:
	@terraform init -get=true \
		-backend-config "key=jango/${ENVIRONMENT}/tfstate.json";


plan: check_environment clean init
	set -e; \
	terraform plan \
		--out plan  \
		-var-file=environments/${ENVIRONMENT}.tfvars;

apply:
	set -e; \
	test -e plan || (echo 'Run `make plan` before running `make apply`' && exit 1)
	terraform apply plan

destroy: check_environment clean init
	set -e; \
	terraform destroy \
		-var-file=environments/${ENVIRONMENT}.tfvars;

.PHONY: check_environment clean init plan apply destroy
