#!/bin/bash


lookup_domain() {
	# read to memory a file of subdomain nouns
	sub_domains=$(cat sub_domains.txt)
	dns_server=$(get_dns_server)
	echo "$sub_domains"|
	while read sub_domain; do
		# random DNS server to use
		dns_server=$(get_dns_server)

		# concat sub_domain, domain proper, and tld
		test_domain=$(echo $sub_domain|sed "s/$/\.$domain/g")

		# perform DNS lookup and only print resolved subdomains
		host -W 1 $test_domain $dns_server|
		grep 'has address'|
		awk {'print $1,$4'}
	done 
}


get_dns_server() {
# return a random public recursive server

	# common public dns servers
	dns_servers="
	209.244.0.3
	209.244.0.4
	64.6.64.6
	64.6.65.6
	8.8.4.4
	8.8.8.8
	9.9.9.9 
	149.112.112.112
	208.67.222.222
      	208.67.220.220
	216.146.35.35
	216.146.36.36
	37.235.1.174
	37.235.1.177";

	# select one at random
	echo $dns_servers|tr " " "\\n"|sort -R|head -1
}




if [ -z "$1" ]; then
	echo "Usage: $0 domain_name"
	exit 1
fi


domain=$1

lookup_domain
