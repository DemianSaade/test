asd_1='zxc1.dsa1'
asd_2='zxc2.dsa2'
asd_3='zxc3.dsa3'
asd_4='zxc4.dsa4'

line='-------------------------------'
IFS="
"

z=${asd_2##*.}
x=${!asd_@}
c=${x//asd_/}

echo $line
echo $z
echo $x
echo $c

TIMEFORMAT=%R
#time arr=({1..100})

echo $line
