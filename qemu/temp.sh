asd1='asd1.dsa1'
asd2='asd2.dsa2'
asd3='asd3.dsa3'
asd4='asd4.dsa4'

line='-------------------------------'
IFS="
"

z=${asd2##*.}
x=${!asd*}
c=''

echo $line
echo $z

TIMEFORMAT=%R
time arr=({1..100})

echo ${arr[10]}
#######################################3
echo $line

name1_bin='/opt/bin1'
name2_bin='/opt/bin2'
name3_bin='/opt/bin3'

bin_args_ord=''

name1_if1='opt1 opt2'
