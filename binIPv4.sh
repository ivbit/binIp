#!/usr/bin/dash

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
  >&2 echo "Usage:\t\t$0 IPv4_address[/Slash]"
  >&2 echo 'Ip range\tfrom 0.0.0.0 to 255.255.255.255'
  >&2 echo 'Slash range\tfrom 0 to 32'
  >&2 echo 'Example:\t192.168.0.1/24'
  >&2 echo 'Example:\t192.168.1.2'
  exit 1
}
# Define functions END

# Test user's argument START
[ -z "$1" ] ||
[ "${1%.*}" = "$1" ] ||
[ "${1#*[[:alpha:]]}" != "$1" ] && usage
# Test user's argument END

# Declare variables START
set -- $(echo "$1" | tr '[./]' ' ')
[ $# -lt 4 ] && usage
part1="$1"
part2="$2"
part3="$3"
part4="$4"
part5="${5:-32}"
[ "$part5" -lt 0 -o "$part5" -gt 32 ] && usage
[ "$part5" -ge 24 -a "$part5" -le 32 ] && uAmount="$(( part5 + 3 ))"
[ "$part5" -ge 16 -a "$part5" -lt 24 ] && uAmount="$(( part5 + 2 ))"
[ "$part5" -ge 8 -a "$part5" -lt 16 ] && uAmount="$(( part5 + 1 ))"
[ "$part5" -ge 0 -a "$part5" -lt 8 ] && uAmount="$part5"
unders=''
counter=1
while [ "$counter" -le "$uAmount" ]
do
  unders="_$unders"
  : $(( counter += 1 ))
done
# Declare variables END

# BEGINNING OF SCRIPT
set -- $(echo "10 i 2 o $part4 $part3 $part2 $part1 f q" | dc)
bin1="0000000$1"
bin1="$(echo -n "$bin1" | tail -c 8)/"
bin2="0000000$2"
bin2="$(echo -n "$bin2" | tail -c 8)."
bin3="0000000$3"
bin3="$(echo -n "$bin3" | tail -c 8)."
bin4="0000000$4"
bin4="$(echo -n "$bin4" | tail -c 8)."

>&2 echo "${bin1}${bin2}${bin3}${bin4}${part5}"
>&2 echo "$unders"

# Shell settings START
set +o noglob
# Shell settings END

# END OF SCRIPT


