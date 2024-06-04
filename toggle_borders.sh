#!/usr/bin/env zsh

file_path=~/.config/borders/switch

flags=($(awk '{ print $NF }' $file_path))

toggle_setting() {
  local setting=$1
  local bool_value=$2
  sed -i "" "s/${setting}:.*/${setting}: ${bool_value}/" $file_path
}

if [[ ${flags[0]} = ${flags[1]} && ${flags[1]} = "on" ]]; then
  toggle_setting "borders" "off"
  borders width=0
  toggle_setting "padding" "off"
  yabai -m space --toggle padding
  yabai -m space --toggle gap
elif [[ ${flags[0]} = ${flags[1]} && ${flags[1]} = "off" ]]; then
  toggle_setting "borders" "on"
  borders width=5
  toggle_setting "padding" "on"
  yabai -m space --toggle padding
  yabai -m space --toggle gap
elif [[ ${flags[0]} = "off" && ${flags[1]} = "on" ]]; then
  toggle_setting "padding" "on"
  yabai -m space --toggle padding
  yabai -m space --toggle gap
elif [[ ${flags[0]} = "on" && ${flags[1]} = "off" ]]; then
  toggle_setting "padding" "off"
  yabai -m space --toggle padding
  yabai -m space --toggle gap
fi

awk '{ print $1, $NF }' $file_path
