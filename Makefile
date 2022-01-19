.DEFAULT_GOAL := help

.PHONY: lint-yaml
lint-yaml: ## run yaml lint
	@echo "...running yaml lint"
	@pip3 install yamllint --quiet
	@yamllint .
	@echo "...ok!"

.PHONY: lint-ansible
lint-ansible: ## run ansible lint
	@echo "...running ansible lint"
	@pip3 install ansible-lint ansible --quiet
	@ansible-lint
	@echo "...ok!"

.PHONY: lint
lint: lint-yaml lint-ansible ## run yaml and ansible lint

.PHONY: help
help: ## Display this help
	@echo "Usage:\n  make \033[36m<target>\033[0m"
	@awk 'BEGIN {FS = ":.*##"}; \
		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } \
		/^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } \
		/^###@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
