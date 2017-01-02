#!/bin/bash

#ATTENTION, laisser le fichier websites_bash.txt dans le meme repertoire que ce script


#definition de la limite maximum pour le random en fonction du nombre d URLS
#renseignees dans le fichier websites_bash.txt

RANGE=$(cat websites_bash.txt | wc -l)


# definition de fonctions, une pour l aide et une pour la generation aleatoire d une URL

show_help()
{
     echo "-l nombre d iterations a effectuer\
           -s debut des addresses generees\
           -e fin des adresses generees\
           -p proxy et port sous la forme proxy:port\
           -a trois premiers digits de l adresse ip d origine\
           -h affiche ce message d aide"}
 }

genranurl()
{
     number=$RANDOM
     let "number %= $RANGE"
     URL=$(sed -n "$number p" ./websites_bash.txt)
}

#valeur par defaut pour les parametres 

num_loops=10
start_addr=2
end_addr=31
proxy='10.1.0.28:3129'
addr_first_digits='10.1.28'

#prise en compte des parametres

while getopts "h?l:s:e:p:a:" opt; do
    case "$opt" in
    h|\?)
        show_help
        exit 0
        ;;
    l)  num_loops=$OPTARG
        ;;
    s)  start_addr=$OPTARG
        ;;
    e)  end_addr=$OPTARG
        ;;
    p)  proxy=$OPTARG
        ;;
    a)  addr_first_digits=$OPTARG
        ;;
    esac
done

#rappel des valeurs affectees aux parametres

echo $num_loops
echo $start_addr
echo $end_addr
echo $proxy



num_int="0"

for n in $(seq 1 $num_loops)
do
    for i in $(seq $start_addr $end_addr)
    do
        genranurl
        ifconfig eth0:$num_int $addr_first_digits.$i/16
#        ifconfig eth0:$num_int 10.1.28.$i/16
        num_int=$((num_int+1))
        wget --bind-address=$addr_first_digits.$i $URL -e use_proxy=yes -e http_proxy=$proxy -O /dev/null &
#        wget --bind-address=10.1.28.$i $URL -e use_proxy=yes -e http_proxy=$proxy &
    done
done


