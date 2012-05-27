#! /usr/bin/env bash

PATH="${PATH}:./bash-oauth"

# include twitter OAuth functionality
. bash-oauth/TwitterOAuth.sh

# get credentials for twitter
. credential

# set screen_name of user which home_timeline to observe
user="syranez"

# set directory in which temporary data is placed
directory="/dev/shm/twitter/notification";
# set directory in which shell data json structure is created
root_node="tmp"

if [ -d "${directory}/${root_node}" ]; then
    rm -r "${directory}/${root_node}"
fi

TO_statuses_home_timeline "json" "${user}" 1

if [[ $? != 0 ]]; then
    echo "did not work."$?
    exit 1
fi

# create shell json structure
php ./shell-json/shelljson.php --root="${root_node}" --directory="${directory}" "${TO_ret}";

if [ ! $? -eq 0 ]; then
    echo "Could not convert data to shell-json: $?";
    exit $?;
fi

# check if new tweet is available
current=$(cat "${directory}/${root_node}/0/id")
if [[ -e "${directory}/last" ]]; then
    last=$(cat "${directory}/last")

    if [[ "${last}" == "${current}" ]]; then
        exit 0;
    fi
fi

# Remember tweet id
echo "${current}" > "${directory}/last"

# save tweet text and user
user=$(cat "${directory}/${root_node}/0/user/screen_name")
tweet=$(cat "${directory}/${root_node}/0/text")

# cleanup
rm -r "${directory}/${root_node}"

notify-send "${user}: ${tweet}"
