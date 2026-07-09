#!/bin/sh
sign=$1
amount=$2

if [ -z "$sign" ] || [ "$sign" != "+" -a "$sign" != "-" ]; then
  echo "usage: $0 +|-"
  exit 1
fi

if [ -z "$amount" ]; then
  amount=0.05
fi

file=~/.config/alacritty/alacritty.toml

current_opacity=$(\
      echo "$(grep -oP "^opacity\s*=\s*(1|(0?(\.[0-9]+)))" \
        $file | \
        sed -e "s/opacity\s*=\s*//"\
      ) $sign $amount" | bc | \
      awk '{printf "%03.2f\n", ($0 < 0 ? 0 : ($0 > 1 ? 1 : $0))}')

echo "opacity = $current_opacity"

sed -i -e "/opacity /s/[0-9]\(\.[0-9]*\)*/$current_opacity/" $file

