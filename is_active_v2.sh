#!/bin/bash

# pass the service name as first argument (which is mandatory) and 
# as a second argument yes (if you want to enable the service) or stop (if you want to disable the service)

# service to check if its enabled is equal to the first argument
service=$1

doHaveI=$2

# function to check if the first argument has been passed
function argumentCheck() {
	if [ -z "$service" ]; then
		printf 'Please, provide an argument!!!\n'
		exit
	fi
}

# function to check if the service actually exists
function serviceExists() {
	if ! systemctl cat --no-pager "$service" &>/dev/null; then
		printf 'Service %s does not exist!\n' "$service"
		exit
	fi
}

# function to check if the service is enabled
function isEnabled() {
	if [ "$(systemctl is-enabled "$service")" == "enabled" ]; then
		printf 'Service %s is enabled!\n' "$service"
		exit
	else
		enabled=False
	fi
}

# function containing steps necessary to enable a service
function enableIt() {
	if ! systemctl enable "$service"; then
		printf 'Enabling %s went wrong!\n' "$service"
	fi
}

# function containing steps necessary to disable a service
function disableIt() {
	if ! systemctl disable "$service"; then
		printf 'Disabling %s went wrong!\n' "$service"
	fi
}

# if found a service not enabled, enable it
function doTheThings() {
	if [ "$enabled" == False ] && [ "$doHaveI" == yes ]; then
		enableIt
		printf 'Service %s now enabled!\n' "$service"
	elif [ "$enabled" == False ] && [ "$doHaveI" != yes ]; then
		printf 'Service %s is disabled!\n' "$service"
		printf 'Not enabling %s\n' "$service"
	elif [ "$enabled" == True ] && [ "$doHaveI" == stop ]; then
		disableIt
		printf 'Service %s now disabled!\n' "$service"
	fi
}

# check if arguments are passed
argumentCheck

# check if the service actually exists
serviceExists

# calling the check function
isEnabled

# do the actual stuff
doTheThings
