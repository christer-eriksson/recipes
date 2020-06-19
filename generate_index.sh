#!/usr/bin/env bash 
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

asciidoctor *.adoc **/*.adoc
