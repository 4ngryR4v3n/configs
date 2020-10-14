#!/bin/bash

#
# Digital Ocean
#

# Config

user="root"
ip="157.245.232.195"
tunnelport="8089"

# Open a remote shell

function droplet()
{
	ssh $user@$ip
}

# Open a tunnel for Burp to proxy all requests through. Remember to configure your SOCKS proxy in Burp to 127.0.0.1:PORT

function proxytunnel()
{
	ssh -C -D $tunnelport $user@$ip &
	pid=$!

	echo -e "Proxy tunnel running as user \e[1m\e[32m$user\e[0m on port \e[1m\e[32m$tunnelport\e[0m at address \e[1m\e[32m$ip\e[0m"
	read -p "Press ENTER to kill"

	kill -9 $pid
}
