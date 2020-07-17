#!/usr/bin/env bash 
IMAGE_NAME="recipies"
REGISTRY="localhost:32000"

[ -d target ] && rm -rf target 

echo "= Recipes " > recipes.adoc

echo "" >> recipes.adoc
echo "== Index" >> recipes.adoc
echo "" >> recipes.adoc

oldfolder=""
for name in **/*.adoc ; do
    folder=$(dirname $name)
    title=$(cat $name | grep -P "^=\ " | sed s/'^= '//)
    if [[ x$folder != x$oldfolder ]]; then 
      echo "=== $folder" >> recipes.adoc
      echo "" >> recipes.adoc
    fi
    echo "<<$name#$title, $title>>" >> recipes.adoc
    echo "" >> recipes.adoc
    oldfolder=$folder
done
cp recipes.adoc index.adoc

asciidoctor *.adoc **/*.adoc

mkdir target
find . -name '*.html' -exec cp --parents \{\} target \;

podman build -t ${IMAGE_NAME} .
podman tag ${IMAGE_NAME} ${REGISTRY}/${IMAGE_NAME}
podman push ${REGISTRY}/${IMAGE_NAME}

find . -name '*.html' -exec rm {} \;