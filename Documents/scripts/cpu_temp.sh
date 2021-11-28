#!/bin/bash

# instale o font-awesome para usar esses unicodes
ICONn="\uf2ca" # icon for normal temperatures
ICONm="\uf2c8" # icon for max temperatures
ICONc="\uf2c7" # icon for critical temperatures

# sensors command and parse goes here
content=$(sensors -j)
temp=$(jq '.["atk0110-acpi-0"]["CPU Temperature"].temp1_input' <<< "${content}")
max=$(jq '.["atk0110-acpi-0"]["CPU Temperature"].temp1_max' <<< "${content}")
crit=$(jq '.["atk0110-acpi-0"]["CPU Temperature"].temp1_crit' <<< "${content}")


if [ "$temp" -lt "$max" ] ; then
    printf "$ICONn%s°C" "$temp"
 elif [ "$temp" -lt "$crit" ] ; then
     printf "$ICONm%s°C" "$temp"
  else
      printf "$ICONc%s°C" "$temp"
fi

