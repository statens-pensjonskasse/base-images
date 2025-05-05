# Base images

This repository contains recipies (Containerfiles/Dockerfiles) for building base images for use in SPK.

The container images are currently built using `podman` on internal GitHub Runners.

## ⚙️ Containerfile customisation

The `Containerfiles` take advantage of the `ARG` instruction to allow for customisation of the build process.
Inspect each `Containerfile` for the available arguments.

## 🪨 Rocky Linux 9 minimal

Based on the latest `rockylinux:9-minimal` image.
Used as base images for other images.
We set the timezone to Europe/Oslo and install internal SPK root CA certificates,
as well as adding internal Yum repositories.

Available versions: `9-minimal`

## ☕️ Zulu OpenJDK

Based on the previous Rocky Linux 9 minimal images.
We create both JRE and JDK flavours of the images.

Available versions: `21-jre`, `21-jdk`

## 🪶 Maven

Based on the previous Zulu OpenJDK JDK images.
Only Maven 3.9.9 with Java 21 is supported.

Available version: `3.9.9-zulu-openjdk-21`
