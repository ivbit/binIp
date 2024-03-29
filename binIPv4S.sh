#!/bin/ash

# Intellectual property information START
# 
# Copyright (c) 2022 Ivan Bityutskiy
# 
# Permission to use, copy, modify, and distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
# 
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
# 
# Intellectual property information END

# Description START
#
# The script converts IPv4 to binary form.
#
# Description END

# Shell settings START
set -o noglob
# Shell settings END

# Define functions START
usage()
{
  >&2 printf 'Usage:\t\t%s\n' "$0 IPv4_address[/Slash]"
  >&2 printf 'Ip range\t%s\n' 'from 0.0.0.0 to 255.255.255.255'
  >&2 printf 'Slash range\t%s\n' 'from 0 to 32'
  >&2 printf 'Example:\t%s\n' '192.168.0.1/24'
  >&2 printf 'Example:\t%s\n' '192.168.1.2'
  exit 1
}
# Define functions END

# Test user's argument START
# Slackware's ash does NOT understand globs like [[:alpha:]], only * ? [a-zA-Z0-9]
[ -z "$1" ] ||
[ "${1%.*}" = "$1" ] ||
[ "${1#*[[:alpha:]]}" != "$1" ] && usage
# Test user's argument END

# Declare variables START
set -- $(printf '%s' "$1" | tr './' ' ')
[ $# -lt 4 ] && usage
part1="$1"
part2="$2"
part3="$3"
part4="$4"
part5="${5:-32}"
[ "$part5" -lt 0 -o "$part5" -gt 32 ] && usage
[ "$part5" -ge 24 -a "$part5" -le 32 ] && uAmount="$(( $part5 + 3 ))"
[ "$part5" -ge 16 -a "$part5" -lt 24 ] && uAmount="$(( $part5 + 2 ))"
[ "$part5" -ge 8 -a "$part5" -lt 16 ] && uAmount="$(( $part5 + 1 ))"
[ "$part5" -ge 0 -a "$part5" -lt 8 ] && uAmount="$part5"
unders=''
counter=1
while [ "$counter" -le "$uAmount" ]
do
  unders="_$unders"
  counter=$(( $counter + 1 ))
done
# Declare variables END

# BEGINNING OF SCRIPT
set -- $(printf '%s' "10 i 2 o $part4 $part3 $part2 $part1 f q" | dc)
bin1="0000000$1"
bin1="$(printf '%s' "$bin1" | tail -c8)."
bin2="0000000$2"
bin2="$(printf '%s' "$bin2" | tail -c8)."
bin3="0000000$3"
bin3="$(printf '%s' "$bin3" | tail -c8)."
bin4="0000000$4"
bin4="$(printf '%s' "$bin4" | tail -c8)/"

>&2 printf '\n%s\n' "${bin1}${bin2}${bin3}${bin4}${part5}"
>&2 printf '%s\n\n' "$unders"

# Shell settings START
set +o noglob
# Shell settings END

# END OF SCRIPT


