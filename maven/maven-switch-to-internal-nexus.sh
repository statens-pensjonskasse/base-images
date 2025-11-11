#!/bin/bash
# Kjør dette scriptet som root for å konfigurere Maven til å bruke intern Nexus

[[ -n "$DEBUG" ]] && set -x  # turn -x on if DEBUG is set to a non-empty string
set -o errexit # Avslutter umiddelbart hvis et statement returnerer false

if ! wget http://yum.spk.no/pub/maven-artifacts/settings.xml ; then
    echo "Failed to download settings.xml"
    exit 1
fi
mv settings.xml /opt/apache-maven-latest3/conf/settings.xml
chmod 644 /opt/apache-maven-latest3/conf/settings.xml
echo "Switched to internal Nexus"
