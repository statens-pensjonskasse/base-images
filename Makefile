.DEFAULT_GOAL := help

help:
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: php-build
php-build: ## Bygger php-image
	docker build -f php-mssql/Containerfile -t php-mssql php-mssql

.PHONY: php-run-shell
php-run-shell: php-build ## Bygger og starter shell i container
	docker run -it --rm --entrypoint /bin/bash --name php-mssql php-mssql:latest

# .PHONY: php-clean
# php-clean:  ## Fjerner kjørende container
# 	docker rm -f php-mssql || true
