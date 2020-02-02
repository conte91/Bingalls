#!/bin/sh

centrafrase() {
  frase="$1"
  header="########################################################"
  n=`echo "$frase" | wc -c`
  nh=`echo "$header" | wc -c`

  spazisx=$(( ($nh-$n-2) / 2 ))
  spazidx=$(( ($nh-$spazisx-$n-2) ))

  echo "$header"
  echo -n "#"
  for i in `seq 1 $spazisx`
  do
    echo -n " "
  done
  echo -n "$frase"
  for i in `seq 1 $spazidx`
  do
    echo -n " "
  done
  echo "#"
  echo "$header"
}

prendifoto () {
  giorni=$1
  numero=$((giorni))
  pagina=$(wget 'http://www.bing.com/HPImageArchive.aspx?format=xml&idx='"$numero"'&n=1&mkt='"$2"  -O  - 2>/dev/null)

  immagine=$(echo "$pagina"|  sed -e 's:.*<url>\([^<]*\)</url>.*:www.bing.com/\1:')

  echo $immagine

  echo "La tua immagine si trova qui -> $immagine"
  data=`date +%Y-%m-%d -d "$giorni days ago"`
  echo "La data e' $data"
  newname=$(basename ${immagine} | sed -e "s:\([^_]*\)_.*:${data}_\1.jpg:")
  echo "La tua immagine si salva qui -> ${newname}"
  wget "${immagine}" -O ${cartelladovefarecose}/"${newname}"
}

centrafrase "Sono proprio felice di scaricare le immagini oggi"

cartelladovefarecose=~/Pictures/Wallpapers/Varie/Bing

quantigiorni=0

while :
do
  quantigiornifa=$(($quantigiorni - 1))
  quando=`date '+%Y-%m-%d' -d "$quantigiornifa days ago"`

  command="ls ${cartelladovefarecose}/${quando}_*"
  if $command >/dev/null 2>/dev/null
  then
    echo "Good"
    break
  else
    echo "$quantigiorni mancapagarli"
  fi

  if [ $quantigiorni -ge 9 ]
  then
    echo "Too many giornis"
    break
  fi

  quantigiorni=$(( $quantigiorni + 1 ))
done

if [ $quantigiorni -eq 0 ] 
then
  exit
fi

centrafrase "Ti mancano la bellezza di $quantigiorni immagini"

for giornifa in `seq -1 $((quantigiorni-2))`
do
  centrafrase "Prendifoto di $giornifa giorni fa..."
  prendifoto $giornifa $1
done
