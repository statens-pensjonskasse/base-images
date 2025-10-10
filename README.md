# Base images

This repository contains recipies (Containerfiles/Dockerfiles) for building base images for use in SPK.

The container images are currently built using `podman` on internal GitHub Runners.

## ⚙️ Containerfile customisation

The `Containerfiles` take advantage of the `ARG` instruction to allow for customisation of the build process.
Inspect each `Containerfile` for the available arguments.

## 🪨 Rocky Linux 8 and 9

Based on the latest `rockylinux` images.
Primarily used as base images for other images.
We set the timezone to Europe/Oslo and install internal SPK root CA certificates,
as well as adding, but not enabling, internal Yum repositories.

Available versions:

* `8`
* `8-minimal`
* `9`
* `9-minimal`

### Yum repositories

As default, only standard external yum repositories are enabled, no internal SPK repos.
That means you can use it on cloud runners.

If you need to install SPK-RPMs, you need to build on our internal runners,
enable the SPK repos, and disable the mirrorlist in the standard repos.
The repo config can be done by running the script `yum-switch-to-internal-repos.sh`
in your build file, as root, before `dnf install`.

## ☕️ Zulu OpenJDK

Based on the previous Rocky Linux 9 minimal images.
We create both JRE and JDK flavours of the images.

Available versions: `21-jre`, `25-jre`, `21-jdk`, `25-jdk`

## 🪶 Maven

Based on the previous Zulu OpenJDK JDK images.
Only Maven 3.9.11 with Java 25 is supported.

Available version: `3.9.11-zulu-openjdk-25`

## 🟩 Node.js

Based on the Rocky Linux 9 minimal images.

We provide two versions of this image:

* Standard image with Node.js and npm
* Builder image with additional development packages including git, gcc-c++,
  and GUI-related dependencies for headless browser testing

Available versions: `22`, `22-builder`, `24`, `24-builder`

## 🐍 Python

Based on the Rocky Linux 9 minimal images.
Includes the specified Python version with pip, MSSQL ODBC driver, and Poetry for dependency management.

Available versions: `3.11`, `3.12, 3.13, 3.14`

## 🐘 PHP

Based on the plain ubuntu 22.04 image. Runs as non-root (User "app", uid 1000)
Includes the specified PHP version with MSSQL ODBC driver.

Available version: `8.3`

## 🐹 Go

Based on the Rocky Linux 9 minimal images.
Includes the specified Go version.

Available versions: `1.25.0`
