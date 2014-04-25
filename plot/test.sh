watch -n 10 'echo $(date +%H%M%S)$(free -o)" "$(\df /tmp/) >> tmpasd'

sed -e '1i Time str total used free shared buffers cached str total used free str total used free' \
    -e 's/total used free shared buffers cached //g' \
    -e 's/Filesystem 1K-blocks Used Available Use% Mounted on tmpfs /\/tmp: /g' \
    -e 's/\/\w*$//g' \
    -e 's/\w\>%//g' tmpasd > asd.dat

sed -e 's/ *$//g' \
    -e 's/ /\t/g' -i asd.dat
