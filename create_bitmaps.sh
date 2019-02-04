#!/usr/bin/env bash

set -ex

google_blue="#4285F4"

TEMPLATE=$(cat <<EOF

!definelong GCP___SPRITE__(alias,name,container='rectangle')
skinparam container<<name>> {
  BackgroundColor White
  BorderColor White
  Shadowing false
}
PUML_ENTITY(container,$google_blue,__SPRITE__,alias,name)
!enddefinelong
EOF
)

IFS=$'\n'; set -f
for file in $(find "./GCP Icons" -name '*.png'); do
    base=$(basename $file)
    name=$(echo "${base%.*}" | sed 's/[ -]//g')
    outfile="${file%.png}.puml"
    java -jar plantuml.jar -encodesprite 16z "$file" | sed "s/\\\$[a-zA-Z]\+/\\\$$name/" > $outfile
    echo "$TEMPLATE" | sed "s/__SPRITE__/$name/g" >> $outfile
done
unset IFS; set +f
