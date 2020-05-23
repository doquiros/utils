#!/bin/bash
if [ "$DEBUG" = "1" ]; then
  set -x
fi

declare -a valid_formats=( \
"720p50" \
"720p60" \
"1080i50" \
"1080i60" \
"1080p25" \
"1080p30" \
)

declare -A format2ceamode=( \
[720p50]=19 \
[720p60]=4 \
[1080i50]=20 \
[1080i60]=5 \
[1080p25]=33 \
[1080p30]=34 \
)

declare -A format2width=( \
[720p50]=1280 \
[720p60]=1280 \
[1080i50]=1920 \
[1080i60]=1920 \
[1080p25]=1920 \
[1080p30]=1920 \
)

declare -A format2height=( \
[720p50]=720 \
[720p60]=720 \
[1080i50]=1080 \
[1080i60]=1080 \
[1080p25]=1080 \
[1080p30]=1080 \
)

print_usage () {
  echo "$0 format"
  echo "\tformat:      valid values are 720p50, 720p60, 1080i50 and 1080i60"
}

FORMAT=$1

if [ -z "$FORMAT" ]; then
  echo "No format provided"
  print_usage
  exit 1
fi

format_found="0"
format=0
while [ "$format_found" = "0" ]; do
  if [ "${valid_formats[$format]}" = "$FORMAT" ]; then
    format_found="1"
    break
  fi
  format=$((format + 1))
done

if [ "$format_found" = "0" ]; then
  echo "Invalid format"
  print_usage
  exit 1
fi

ceamode=${format2ceamode[$FORMAT]}
width=${format2width[$FORMAT]}
height=${format2height[$FORMAT]}

tvservice --off                  # turn off tv service
tvservice -e "CEA $ceamode HDMI"  # set it on (you will see a black screen)
sudo chvt 2                      # change to different virtual terminal
sudo chvt 1                      # change back to the previous virtual terminal
fbset -g $width $height $width $height 32       # adjust the size of the fram
