#!/bin/bash

#check if nmap is installed

if ! command -v nmap --version &> /dev/null; then
 
		echo "You need to instal nmap program to use this script.
	        To install use one of the next commands:	
		# yum install nmap     [On CentOS/RHEL]
		# apt install nmap     [On Debian/Ubuntu]
		# zypper install nmap  [On OpenSuse]
		# pacman -S nmap      [On Arch Linux]"
		
		exit 0
fi

#list all networks
networks=($(ip a | grep -w inet | awk '{print $2}'| grep -v 127))


#-all agrument function code: check IP addresses and symbolic names for all networks from the list above
all () {

	for i in $networks
	do
	nmap -sn $i
done
}                                     

#-target argument function code: check all ports regardless firewall for chosen IP address
target () {
	if [[ $(all) == *"$ip_addr"* ]]; then
		nmap -Pn $ip_addr	
	else echo "There's no such IP address in this network. Please, check existing ip addresses using --all argument"
	fi
	
}

#check arguments
case $1 in
	"")           #empty argument
                echo "
        --all: 
                displays the IP addresses and symbolic names of
                all hosts in the current subnet
        --target [ip address]: 
                displays a list of open system TCP ports"
		;;
	--all)        #-all argument
              all
	      ;;

      --target)      #-target argument
	       if [[ $# -eq 2 ]]; then 
	       ip_addr=$2
		       target
       		
       		else echo "Please, add ip address after --target" 
		fi

	 	;;

       *)            #wrong argument
                echo "Wrong key argument. Please, use either --all or --target [ip address]"
esac


	
