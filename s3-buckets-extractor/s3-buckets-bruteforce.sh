#!/bin/bash


bash_source=$(ls -ld ${BASH_SOURCE[0]})
source_dir=$(echo $bash_source | awk -F "-> " '{print $2}')
if [ ${#source_dir} -gt 0 ] ; then
  source_dir=$(dirname $source_dir)"/"
else
  source_dir=$(dirname $(echo $bash_source | awk -F " " '{print $(NF)}'))"/"
fi

source $source_dir"myutils.sh"
source $source_dir"s3-buckets-func.sh"


function usage() {
    echo "Usage: "$0" <wordlist> [<prefix>] [<suffix>]"
    if [ -n "$1" ] ; then
	echo "Error: "$1"!"
    fi
    exit
}

if [ $# -lt 1 ] || [ $# -gt 3 ] ; then
    usage
fi

wordlist=$1

if [ ! -f $wordlist ] ; then
	usage "File not found!"
fi

if [ $# -ge 2 ] ; then
	prefix=$2
fi
if [ $# -eq 3 ] ; then
	suffix=$3
fi

n=0
f="/tmp/s3bf-"$(date +%s)
`echo $(date) > $f`

for w in $(cat $wordlist) ; do
    bucket=$prefix$w$suffix
    #echo -ne $bucket"\r"
    test $bucket
done

rm $f
exit
