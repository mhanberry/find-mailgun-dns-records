#!/bin/bash

set -e

ls results |
	xargs -I {} egrep '^\t' results/{} |
	sed 's/^\t//g' |
	sort |
	uniq > all-domains.txt

echo Aggregate results have been written to all-domains.txt
