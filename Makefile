.DEFAULT_GOAL := help

help:
	@echo "Targets:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.PHONY: php-build
php-build: ## Bygger php-image
	docker build -f php-mssql/Containerfile -t php-mssql php-mssql

# .PHONY: php-run
# php-run: build clean  ## Bygger og starter container  på 8080 med html-filer mountet lokalt. Ment for lokal tykklient-utvikling
# 	docker run -d -p 8080:8080 -v ${PWD}/html:/var/www/html -e DB_DATABASE=${DB_DATABASE}  --name php-mssql php-mssql
# 	@echo "Åpne applikasjon på http://localhost:8080/"

.PHONY: php-clean
php-clean:  ## Fjerner kjørende container
	docker rm -f php-mssql || true
