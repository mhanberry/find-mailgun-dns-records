SHELL = /bin/bash

all: dev/genpop dev/vault dev/logs prod/genpop prod/vault vault-eu-dev-crossaccountsignin aggregate-results

clean:
	rm -rf resource-record-sets results all-domains.txt

dev/genpop:
	./main.sh $@

dev/vault:
	./main.sh $@

dev/logs:
	./main.sh $@

prod/genpop:
	./main.sh $@

prod/vault:
	./main.sh $@

vault-eu-dev-crossaccountsignin:
	./main.sh $@

aggregate-results:
	./aggregate-results.sh
