#!/bin/bash

# Check if the service actually exists by running a command
if ! command -v chronyd &>/dev/null; then
        printf 'Command chrony not found!\n'
        exit

else
        # If it exists and is active...
        if [ "$(systemctl is-active chrony)" == "active" ]; then
                printf 'Service is up and running!\n'

        # If it exists but is not active... Try to restart
        elif [ "$(systemctl is-active chrony)" == "inactive" ]; then
                printf 'Found stopped service! Trying to restart...\n'

                # Checks if the command actually works
                if ! sudo systemctl start --quiet chrony; then
                        printf 'something went wrong while starting chrony\n'
                        exit
                else
                        printf '...Service started!\n'
                fi

        else
                printf 'Something is wrong. Try running systemctl status chrony\n'
                exit
        fi
fi
