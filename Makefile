REPO := amancevice/$(shell basename $$PWD)

ENDPOINT = http://$$(REPO=$(REPO) docker-compose port lambda 8080)/2015-03-31/functions/function/invocations

all: test validate

clean:
	rm -rf .terraform

clobber: clean
	rm -rf .terraform.lock.hcl

test:
	pipenv run pytest

up:
	pipenv run lambda-gateway -p 3000 src.index.proxy

validate: | .terraform
	terraform fmt -check
	AWS_REGION=us-east-1 terraform validate

.PHONY: all clean clobber test up validate

.terraform:
	terraform init
