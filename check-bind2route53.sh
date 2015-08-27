#!/bin/bash
## variables
target=$1
NS=$2
domain=$(ruby -e "puts \"$target\".split('.').map(&:capitalize).join.gsub('-', '')")

# path
current=`pwd`
project_path=$current/dig_check_before/$target
result_path=$project_path/result
zone_path=aaa

## function check
check (){
for i in `ls $result_path/*.bind`
do
  file=${i%.*}
  diff -u $file.bind $file.route53
  rc=$?

  if [ ! -s $file.bind ];then rc=`expr $rc + 1` ;fi
  if [ ! -s $file.route53 ];then rc=`expr $rc + 1` ;fi

  if [ 0 -eq $rc ]
  then
    echo -e "\e[32m${file##*/}: success\e[m"
  else
    echo -e "\e[31m${file##*/}: fail\e[m"
  fi
done
}
echo "domain: $domain"

if [ -z $target ] ;then
  echo "example: ./check-bind2route53.sh [target domain] [NS]  ./check-bind2route53.sh example.jp @ns1.google.com"
  exit 1
fi

if [ -z $NS ] ;then
  echo "example: ./check-bind2route53.sh [target domain] [NS]  ./check-bind2route53.sh example.jp @ns1.google.com"
  exit 1
fi

if [ -e $project_path ] ;then
  check
  exit 1
fi

mkdir -p $result_path

# meta
echo "bundle exec bin/convert_zonefile -z $target.  -f $zone_path/$target.zone  | jq -r '.Resources.R53${domain}.Properties.RecordSets[]|\"dig +short \\(.Type)  \\(.Name) >> $result_path/\\(.Name)bind\"' > $project_path/$target.bind.zone" >$project_path/test-$target-bind.sh
echo "bundle exec bin/convert_zonefile -z $target.  -f $zone_path/$target.zone  | jq -r '.Resources.R53${domain}.Properties.RecordSets[]|\"dig +short \\(.Type)  \\(.Name) ${NS}  >> $result_path/\\(.Name)route53\"' > $project_path/$target.route53.zone" >$project_path/test-$target-route53.sh


sh $project_path/test-$target-bind.sh
sh $project_path/test-$target-route53.sh

sed -i '' -e 's/@\.//g' $project_path/$target.bind.zone
sed -i '' -e 's/@\.//g' $project_path/$target.route53.zone

# exec
sh $project_path/$target.bind.zone
sh $project_path/$target.route53.zone

check
