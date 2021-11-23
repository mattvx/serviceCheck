#!/bin/bash

# Check if the service actually exists by running a command
if ! command -v chronyd &>/dev/null; then
        echo "Command chrony not found!"
        exit

else
        # If it exists and is active...
        if [ "$(systemctl is-active chrony)" == "active" ]; then
                echo "Service is up and running!"

        # If it exists but is not active... Try to restart
        elif [ "$(systemctl is-active chrony)" == "inactive" ]; then
                echo "Found stopped service! Trying to restart..."

                # Checks if the command actually works
                if ! sudo systemctl start --quiet chrony; then
                        echo "something went wrong while starting chrony"
                        exit
                else
                        sudo systemctl start --quiet chrony
                        if [ $? = 0 ]; then
                                echo "...Service started!"
                        fi
                fi

        else
                echo "Something is wrong. Try running systemctl status chrony"
                exit
        fi
fi
