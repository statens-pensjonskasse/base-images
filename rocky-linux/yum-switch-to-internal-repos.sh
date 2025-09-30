#!/bin/bash
[[ -n "$DEBUG" ]] && set -x  # turn -x on if DEBUG is set to a non-empty string
set -o errexit # Avslutter umiddelbart hvis et statement returnerer false

cd /etc/yum.repos.d

sed -i 's/^mirrorlist=/#mirrorlist=/' [Rr]ocky*.repo
sed -i 's/^#baseurl=/baseurl=/' [Rr]ocky*.repo epel*.repo
sed -i 's/^metalink=/#metalink=/' [Rr]ocky*.repo

cp -vp /etc/yum.repos-internal.d/* .
rm -v docker-ce.repo microsoft-prod.repo epel*.repo
