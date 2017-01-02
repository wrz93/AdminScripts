#!/bin/sh


## Script de mise à jour vers Olfeo SSL 05 - SHA256
## FA - Consulting 20/12/16


# Creation des repertoires

echo Creation des repertoires de sauvegarde...
sleep 1
echo  /tmp/upgradessl/conf sera le repertoire pour la configuration du Squid.
sleep 1
echo  /tmp/upgradessl/conf sera le repertoire pour les certificats du Squid.
sleep 1
mkdir /tmp/upgradessl
mkdir /tmp/upgradessl/conf
mkdir /tmp/upgradessl/certificates

# Copie des fichiers de configuration et des certificats

echo Copie de la configuration Squid...
sleep 1
cp /opt/olfeossl/etc/squid3/squid3.conf /tmp/upgradessl/conf/
echo Copie des certificats utilises par le Squid...
cp /opt/olfeossl/etc/squid3/certs/*.pem /tmp/upgradessl/certificates/

# Desinstallation de l'Olfeo SSL

echo Desinstallation en cours...
dpkg -r --force-depends olfeossl-3.3
sleep 3
dpkg -r --force-depends olfeossl-3.3-cgi
sleep 3
dpkg -r --force-depends  olfeossl-3.3-client
sleep 3
dpkg -r --force-depends olfeossl-3.3-common
sleep 3
dpkg -r --force-depends olfeossl-3.3-dbg
sleep 3
dpkg -r --force-depends olfeossl-3.3-langpack 
sleep 3
dpkg -r --force-depends olfeossl-3.3-purge
sleep 3
echo Desinstallation terminée
echo Voici le contenu des repertoires :
ls -l /tmp/upgradessl/conf/ ; ls -l /tmp/upgradessl/certificates/

# Installation de l'Olfeo SSL 05 - SHA256

echo Installation en cours...
sleep 2
dpkg -i *.deb ; apt-get update ;apt-get -f install -y
sleep 5

echo Installation terminée
sleep 2

# Restauration de la configuration et des certificats

echo Restauration de la configuration Squid...
cp /tmp/upgradessl/conf/squid3.conf /opt/olfeossl/etc/squid3/
sleep 2
echo Restauration des certificats...
cp /tmp/upgradessl/certificates/*.pem /opt/olfeossl/etc/squid3/certs/
sleep 2

# Lancement de l'Olfeo SSL

/etc/init.d/olfeossl-3.3 restart
echo Migration terminee, service demarre. 








