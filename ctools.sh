#!/bin/bash

## TESTS RESEAUX
## FA - Consulting - start  23/12/16
## FA - Consulting - update 02/01/2017

## VARIABLES

RANGE=$(cat websites_pierre.txt | wc -l)
SITEDETEST=www.google.fr
IPDETEST=8.8.8.8
RESULTATIP=
RESULTATDNS=
RESULTATSITESANSPROXY=

HEIGHT=25
WIDTH=60
CHOICE_HEIGHT=7
BACKTITLE="OLFEO BOITE A OUTILS"
TITLE="[MENU]"
MENU="Choissiez l'une des options suivantes"
OPTIONS=(1 "Verifier la latence ICMP"
         2 "Verifier la latence DNS "
         3 "Verifier la latence HTTP"
	 4 "Verifier la latence HTTP avec PROXY"
	 5 "Lancer l'ensemble des tests"
	 6 "Generer de la navigation aleatoire vers un PROXY")


CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)


# LES ARGUMENTS DU SCRIPT


#while getopts "h?l:s:e:p:a:" opt; do
#    case "$opt" in
#   h|\?)
#        show_help
#        exit 0
#        ;;
#    l)  num_loops=$OPTARG
#        ;;
#    s)  start_addr=$OPTARG
#        ;;
#    e)  end_addr=$OPTARG
#        ;;
#    p)  proxy=$OPTARG
#        ;;
#    a)  addr_first_digits=$OPTARG
#        ;;
#    esac
# done




## LES FONCTIONS

GENANURL()
{
     number=$RANDOM
     let "number %= $RANGE"
     URL=$(sed -n "$number p" ./websites_pierre.txt)
}


#SHOW_HELP()
#{
#     echo "-l nombre d iterations a effectuer\
#           -s debut des addresses generees\
#           -e fin des adresses generees\
#           -p proxy et port sous la forme proxy:port\
#           -a trois premiers digits de l adresse ip d origine\
#           -h affiche ce message d aide"}
# }


## INSTALLATION DES OUTILS
echo "Installation des outils..." 
apt-get install -f -y -m dig curl dialog
clear

## MENU ET CHOIX

#dialog --clear --backtitle "Olfeo boite a outils" --title "[MENU]" --menu "Choissiez une des options suivantes :" 25 50 5 \ 1 "Verifier la latence ICMP" \ 2 "Verifier la latence DNS" \ 3 "Verifier la latence HTTP" \ 4 "Vérifier la latence HTTP Proxy" \ 5 "Lancer l'ensemble des tests"


case $CHOICE in
        1)	echo "Lancement des tests ICMP..."           
		RESULTATIP=$(ping -c 3 $IPDETEST | grep rtt | awk -F" " '{print $4}' | awk -F"/" '{print $3}')
		echo "Voici le resultat des tests ICMP (8.8.8.8)(ms) : $RESULTATIP"

            ;;
        2)	echo "Lancement des tests DNS..."
		RESULTATDNS=$(dig $SITEDETEST | grep "Query time" | awk -F' ' '{print $4}')
		echo "Voici le resultat des tests DNS (www.google.fr)(ms) : $RESULTATDNS"

            ;;
        3)	echo "Test de navigation sans Proxy..."
		RESULTATSITESANSPROXY=$(curl --silent   --write-out "Delay: %{time_total} s, TCP connection delay: %{time_connect},  Negociation delay: %{time_starttransfer}\n" \
       --output /dev/null https://www.google.fr/)
		echo "Voici le resultat des tests HTTP(www.google.fr) : $RESULTATSITESANSPROXY"

            ;;
	4)	echo "Veuillez entrer l'adresse ip et le port du PROXY (ex: 127.0.0.1:3129):"
		read PROXY
		echo "La navigation sera effectuee sur le service suivant $PROXY"
		echo "Test de navigation avec Proxy..."
		   
	    ;;
	5)     	echo "Lancement de l'ensemble des tests..."
		echo "Lancement des tests ICMP..."
                RESULTATIP=$(ping -c 3 $IPDETEST | grep rtt | awk -F" " '{print $4}' | awk -F"/" '{print $3}')
                echo "Voici le resultat des tests ICMP (8.8.8.8)(ms) : $RESULTATIP"
		echo "Lancement des tests DNS..."
                RESULTATDNS=$(dig $SITEDETEST | grep "Query time" | awk -F' ' '{print $4}')
                echo "Voici le resultat des tests DNS (www.google.fr)(ms) : $RESULTATDNS"
		echo "Test de navigation sans Proxy..."
                RESULTATSITESANSPROXY=$(curl --silent   --write-out "Delay: %{time_total} s, TCP connection delay: %{time_connect},  Negociation delay: %{time_starttransfer}\n" \
       --output /dev/null https://www.google.fr/)
                echo "Voici le resultat des tests HTTP(www.google.fr) : $RESULTATSITESANSPROXY"

	    ;;
	6)	echo "Veuillez entrer l'adresse ip et le port du PROXY (ex: 127.0.0.1:3129):"
		read PROXY
		echo "La navigation sera effectuee sur le service suivant $PROXY"
     		echo "Generation de trafic Internet, presser CTRL+C pour arrêter ou killall wget"
		sleep 3
		while true;
		do
		GENANURL 
		wget http://$URL -e use_proxy=yes -e http_proxy=$PROXY -O /dev/null & 
		done 
            ;; 
esac

