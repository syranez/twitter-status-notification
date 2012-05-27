#! /usr/bin/env bash

PATH="${PATH}:./bash-oauth"

# include twitter OAuth functionality
. bash-oauth/TwitterOAuth.sh

# get credentials for twitter
. credential

# set screen_name of user which home_timeline to observe
user="syranez"
status="Hihi, ist das ein Test oder ein Tweet?"

TO_statuses_update "json" "${status}"

if [[ $? != 0 ]]; then
    echo "did not work."$?
    exit 1
fi
