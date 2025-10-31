#!/usr/bin/env bash

function get-script-dir {
    # Resolve possible symlinks to script file
    src=$0
    while [ -h "$src" ]; do
        dir=$(cd -P "$(dirname "$src")" && pwd)
        src=$(readlink "$src")
        # If it's not an absolute path, then append it
        if [[ $src != /* ]]; then
            src=$dir/$src
        fi
    done

    # Get the full traversal required
    dir=$(cd -P "$(dirname "$src")" && pwd)
    echo "$dir"
}

# Get the directory
scriptdir=$(get-script-dir)
tsgbackenddir="$scriptdir/tsg3macroservice"
tsgdbdir="$scriptdir/db"
#tsgclientidpath="$scriptdir/client-id.txt"
#tsgclientsecretpath="$scriptdir/client-secret.txt"

#if [ ! -f "$tsgclientidpath" ]; then
#    echo "ERROR: Missing client-id.txt at $tsgclientidpath"
#    echo "You will need to set up a Google Oauth client at the Google Cloud Dashboard."
#    exit 1
#fi

#export GOOGLE_CLIENT_ID=$(cat "$tsgclientidpath")

#if [ ! -f "$tsgclientsecretpath" ]; then
#    echo "ERROR: Missing client-secret.txt at $tsgclientsecretpath"
#    echo "You will need to set up a Google Oauth client at the Google Cloud Dashboard."
#    exit 1
#fi

#export GOOGLE_CLIENT_SECRET=$(cat "$tsgclientsecretpath")

function after-db {
    # Navigate to the back-end directory
    cd "$tsgbackenddir"
    # Clean the workspace, build the back-end, and run the back-end
    ./mvnw clean package spring-boot:run
}

function await-live {
    # Wait for a listening TCP connection on server port
    # This will indicate the database is online
    retrycount=30
    until $(lsof -i @0.0.0.0:5432 | grep -q '(LISTEN)') || [ $retrycount -eq 0 ]; do
        retrycount=$((retrycount-1))
        echo
        echo "Waiting for database server; will retry $retrycount more times."
        sleep 1
    done

    echo
    echo "WOOHOO: Database is live"
    echo
    sleep 1
    echo "Starting back-end"
    echo

    # Give the database a moment to settle after going live on the network
    sleep 1

    # Run the back-end function
    after-db
}

function start-db {
    # Go into the database directory
    cd $tsgdbdir
    # Start the database
    docker compose up
}

function end-java-process {
    if [ "$2" = "grep" ]; then
        echo "Skipping grep command"
    else
        kill $1
    fi
}

if ! [ $(docker ps | grep -q 'tsg-stage3-db') ]; then
    # Branch to have the back-end wait for the database,
    # and also make sure that termination reaches both branches
    await-live &
    start-db

    javasearch=$(ps -o pid,command | grep 'tsg-stage3')

    # Searching for the java process will also return our search process,
    # so filter that, lol
    while read -r line; do
        end-java-process $line
    done <<< "$javasearch"

    # Wait for all the logs to pass before showing the prompt again
    sleep 1
    echo
    echo
else
    echo "Database container is already up."
    echo

    # Run the backend function
    after-db

    # Wait for logs here, too
    sleep 1
    echo
    echo
fi
