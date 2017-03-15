#!/bin/bash

#README:
#Criar um arquivo nome: "PropretiesLatest" com conteudo exemplo: "be-exemplo-00.tar.gz"

JOB_NAME="ProjectMVP-CodePull"
URL_NEXUS="http://<ip>:8081"
URL_JENKINS="http://127.0.0.1:8080"
FILE=./PropretiesLatest
NEXUS=$(curl -s $URL_NEXUS/repository/npm-releases/"$PROJECT")
NEXUS_LATEST=$(echo "$NEXUS" | grep '[0-9]' | sed 's/[-.]/ /g' | awk '{print $(NF-2)}')
LATEST=$(cat "$FILE" | grep '[0-9]' | sed 's/[-.]/ /g' | awk '{print $(NF-2)}')
PROJECT="be-exemplo"
#echo "$LATEST"
#echo "$NEXUS_LATEST"

if [[ $NEXUS_LATEST > $LATEST ]]; then
  #echo "Versao nova para deploy" ;
  curl -s "$URL_NEXUS"/repository/npm-releases/"$PROJECT" > "$FILE"
  #echo "be-exemplo" > "$FILE"
  VERSION=$(cat "$FILE" | cut -d "." -f 1)
  `java -jar jenkins-cli.jar -s "$URL_JENKINS" build "$JOB_NAME" -p VERSION_LATEST="$VERSION"`
fi
