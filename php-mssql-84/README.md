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

Bruk `make php-build` for å bygge og `make php-run-shell` for å få et shell i containeren.

# Bygging og publisering

Bygg gjøres av workflow på alle brancher. På main gjøres i tillegg publisering av image.
