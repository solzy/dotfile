#!/usr/bin/sh

n="3"
directoryname="lineitem_$n"'0g'
cp -r ./lineitem_10g ./"$directoryname" 
for file in `ls ./"$directoryname"`
do
	echo "replacing lineitem to lineitem$n whitin $directoryname/$file"
	sed -i "s/lineitem/lineitem$n/g" "./$directoryname/$file"
done
