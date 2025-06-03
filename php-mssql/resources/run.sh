#!/bin/bash

set -o errexit

APACHE_RUNDIR=$(mktemp -d) # Erstatter /var/run/httpd, må være eid av app-user, som kan være tilfeldig
APACHE_PIDFILE=${APACHE_RUNDIR}/httpd.pid
export APACHE_RUNDIR APACHE_PIDFILE

# Vi kan eksponere DB_PASSWORD fra en vilkårlig fil (da gjerne en docker secret) som $DB_PASSWORD ved å angi
# filstien i DB_PASSWORD_FILE
if [[ -n "$DB_PASSWORD_FILE" ]] ; then
    if [[ -r "$DB_PASSWORD_FILE" ]] ; then
        echo "\$DB_PASSWORD_FILE er satt, leser DB_PASSWORD fra $DB_PASSWORD_FILE"
        DB_PASSWORD=$(cat $DB_PASSWORD_FILE)
        export DB_PASSWORD
    else
        echo "\$DB_PASSWORD_FILE er satt, men fil \"$DB_PASSWORD_FILE\" finnes ikke. Avslutter."
        exit 1
    fi
fi

# Gjør secrets tilgjengelige som miljøvariable. Kan ikke brukes i Kubernetes, kan derfor disables
if [[ "$EXPOSE_SWARM_SECRETS" = true ]] ; then
    shopt -s nullglob # patterns which match no files expands to a null string

    for file in /run/secrets/* ; do
        echo "Eksponerer secret $(basename "$file") som envvar..."
        eval export $(basename "$file")="$(cat "$file")"
    done
    shopt -u nullglob
fi
# Dersom det finnes en egen run-fil (lagt inn av arvende image), kjør den før vi starter Apache
if [[ -r /run-local.sh ]] ; then
    echo "Kjører /run-local.sh"
    /run-local.sh
fi

exec /usr/sbin/apache2ctl -D FOREGROUND
