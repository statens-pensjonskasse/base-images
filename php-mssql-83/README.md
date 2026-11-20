# Base-php-mssql

Tilbyr en apache-installasjon med mod_php som har innebygd støtte for Microsoft SQL Server, som er
nødvendig for å koble seg til kasper-databasen. PHP har ikke støtte for det som default, man må kompilere selv.

Det er ikke nødvendig å bruke dette imaget hvis du ikke trenger tilgang til MSSQL. Det finnes offisielle PHP-images som kan egne seg bedre enn denne.

"base" betyr at imaget er ment brukt som utgangspunkt for bygging av faktiske applikasjoner, dvs. brukt i FROM.

Apache er konfigurert til å vise .php-filer uten at man angir filendelsen. Dvs. angir man /filnavn vil /filnavn.php vises dersom den finnes.

Loggingen fra Apache er tilpasset SPK standard.

# Bruk

I utgangspunktet skal det bare være å sette ServerName i Apache med:

```Dockerfile
ENV SERVER_NAME <appnname>
```

og ADDe html-filer under /var/www/html.

*Husk at /run.sh er ENTRYPOINT*
*Dersom du trenger egne tilpasninger, legg til fila /run-local.sh og gjør den excecutable. Hvis den finnes, vil den eksekveres før apache starter*

## Bruk i Kubernetes

Hvis en tjeneste skal kjøre i kubernetes går vår swarm-tilpasning for å eksponere secrets i beina på kubernetes sin løsning for secrets.
Vi må derfor disable eksponering av secrets (evt. overstyre ENTRYPOINT, men da på egen risiki)

Det gjøres ved å sette miljøvariabelen EXPOSE_SWARM_SECRETS til false. Merk at utviklerne typisk ikke trenger forholde seg til denne,
det skal håndteres av deploy-rammeverket.

## Databasepassord

For å slippe å ha oppstartskode i applikasjonene som bruker dette imaget, håndterer vi det hemmelige databasepassordet i base-imaget.
Derfor, i applikasjonskoden, bruk variabelen DB_PASSWORD for databasepassord.
Under utvikling, med kjente passord, kan verdien sendes inn direkte med -e, men det er sikkerhetsmessig utrygt.

For kjøring i produksjon eller på Docker Swarm, der vi ikke sender inn hemmeligheter som miljøvariabler av sikkerhetshensyn, men bruker Docker Swarm Secrets,
skal man angi filen som databasepassordet ligger i med ENV-variablen DB_PASSWORD_FILE. Da blir innholdet i angitt fil tilgjengeliggjort for applikasjonen
i variabelen DB_PASSWORD.
Siden det gjøres av init-scriptet blir den ikke synlig utenfra.
Så i Docker Swarm setter vi typisk `DB_PASSWORD_FILE=/run/secrets/kasper_topp_password`

## Autentisering

Trenger du autentisering er mod_ldap og mod_authnz_ldap inkludert.

MErk at hver applikasjon skal ha sin eegn AD-bruker den kan autentidere med.

ADD en configfil i `/etc/apache2/sites-enabled/` ala

```httpd
    <Directory /var/www/html/secure>
        AllowOverride None

        <Files ~ "^\.ht">
            Order allow,deny
            Deny from all
            Satisfy All
        </Files>
    </Directory>

    <Location /secure>
        AuthName "TODO Applikasjon - skrivetilgang"
        AuthType Basic
        AuthBasicProvider ldap
        AuthLDAPBindDN ${AD_BIND_USER}
        AuthLDAPBindPassword ${<APPLIKASJON>_SA_PASSWORD}
        AuthLDAPURL "ldaps://mdc11.spk.no mdc12.spk.no mdc13.spk.no/ou=spk,dc=spk,dc=no?sAMAccountName?sub?(objectClass=user)"
        Require ldap-filter memberof:1.2.840.113556.1.4.1941:=${REQUIRED_AD_GROUP}
    </Location>
```

Der du må endre navn på variabelen ${\<APPLIKASJON>_SA_PASSWORD}, og sette variablene med riktige verdier.

Legg også til i Dockerfile miljøvariabelen som styrer hvem som skal ha tilgang, siden det kan være forskjellig i ulike miljøer:

```Dockerfile
ENV REQUIRED_AD_GROUP CN=App-Cron-Admin,OU=Applikasjon,OU=Grupper,DC=spk,DC=no
```

Se Cron Admin-appen for eksempel.

# Bygging lokalt

Bruk `make build` for å bygge og `make run-shell` for å få et shell i containeren med en random bruker.

`make run` starter webserveren lokalt på port 8080

# Bygging og push til SPK dockerhub

Gjøres av Jenkins pipeline.