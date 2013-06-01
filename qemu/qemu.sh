#!/sbin/runscript
# TODO verbose
#  _checks()
#  _qemu()
#  depend()
#  _ifaces()
#  _services()
#  _configs()

depend() {
    # TODO
    #  move ifs deps to _ifaces()
    need net.tap0 net.tap1
}

start() {
    _checks
    _modules start
    _setup start
    _firewall start
}

stop() {
    _setup stop
    mark_service_stopped $RC_SVCENAME
    /etc/init.d/net.br0 stop
    mark_service_stopping $RC_SVCENAME
    _modules stop
    _firewall stop
}

restart() {
    pass
}

_configs() {
    # TODO
    #  chmod /etc/conf/qemu -> cfg
    #  parse cfgs
    #  make list to
    pass
}

_checks() {

    #  do _checks from
#    /usr/bin/lsof /dev/kvm
#    checkpath -f -m 660 -o root:kvm /dev/kvm
#    checkpath -d -m 755 -o root:root /sys/devices/virtual/net/tap0
#    checkpath -d -m 755 -o root:root /sys/devices/virtual/net/tap1
#    checkpath -d -m 755 -o root:root /sys/devices/virtual/net/br0
#    checkpath -f -m 660 -o root:kvm /path-to-/img.qcow2
    pass
}

_ifaces() {
    # TODO
    #  [create, del, insuse] taps -> cfg
    #   """ /etc/init.d/net.[tap#, br#] """
    pass
}

_services() {
    # TODO
    #  talk to {cifs, nfs} -> cfg
    #   """ deps oslt """
    pass
}

_qemu() {
    # TODO
    #  start-stop-deamon ${VM.sh_lst} ->if (^+x VM*.sh^)<-
    pass
}

_modules() {


    local signal="$1"
    local cmd_= msg_=

    #retah esac
    if [ "${signal}" = 'start' ]; then
        cmd_=''
        msg_=''
    elif [ "${signal}" = 'stop' ]; then
        cmd_='--remove-dependencies'
        msg_='un'
    fi

    ebegin "${msg_}Loading modules"

    # ebegin "Loading the kvm module"
    /sbin/modprobe ${cmd_} kvm
    eend $? "Failed to ${msg_}load the kvm module"

    # ebegin "Loading the kvm_intel module"
    /sbin/modprobe ${cmd_} kvm_intel
    eend $? "Failed to ${msg_}load the kvm_intel module"

    # ebegin "Loading the tun module"
    /sbin/modprobe ${cmd_} tun
    eend $? "Failed to ${msg_}load the tun module"
}

_setup() {

    local signal="$1"
    local cmd_= msg_=

    #retah esac
    if [ "${signal}" = 'start' ]; then
        cmd_=(1 0)
        msg_=(on off)
    elif [ "${signal}" = 'stop' ]; then
        cmd_=(0 1)
        msg_=(off on)
    fi

    ebegin "Turning ${msg_[0]} stuff"

    # ebegin "Turning on ksm"
    /bin/echo "${cmd_[0]}" > /sys/kernel/mm/ksm/run
    eend $? "Failed to turn ${msg_[0]} kms"

    # ebegin "Turning on forwarding for ${IF_LAN} && ${IF_WAN}"
    /sbin/sysctl net.ipv4.conf.${IF_LAN}.forwarding=${cmd_[0]} >/dev/null 2>&1 && \
    /sbin/sysctl net.ipv4.conf.${IF_WAN}.forwarding=${cmd_[0]} >/dev/null 2>&1
    eend $? "Failed to turn ${msg_[0]} forwarding for ${IF_LAN} && ${IF_WAN}"

    # ebegin "Turning off firewall on bridge"
    /sbin/sysctl net.bridge.bridge-nf-call-arptables=${cmd_[1]} >/dev/null 2>&1 && \
    /sbin/sysctl net.bridge.bridge-nf-call-iptables=${cmd_[1]} >/dev/null 2>&1 && \
    /sbin/sysctl net.bridge.bridge-nf-call-ip6tables=${cmd_[1]} >/dev/null 2>&1
    eend $? "Failed to turn ${msg_[1]} firewall on bridge"

    # ebegin "Turning on STP on ${IF_LAN}"
    /bin/echo "${cmd_[0]}" > /sys/class/net/${IF_LAN}/bridge/stp_state
    eend $? "Failed to turn ${msg_[0]} STP on ${IF_LAN}"

#    /bin/ifconfig tap0 up 0.0.0.0 promisc
#    /bin/ifconfig tap1 up 0.0.0.0 promisc
#    /bin/ifconfig br0 up 10.1.1.254 -promisc

}

_firewall() {

    local signal="$1"
    local cmd_= msg_=

    #retah esac
    if [ "${signal}" = 'start' ]; then
        cmd_=(-A -I)
        msg_=(allow on)
    elif [ "${signal}" = 'stop' ]; then
        cmd_=(-D -D)
        msg_=(disallow off)
    fi

    ebegin "Turning ${msg_[1]} firewall rueles"

    iptables -t nat ${cmd_[0]} POSTROUTING -o ${IF_WAN} -s ${NT_LAN} -j MASQUERADE
    eend $? "Failed to ${msg_[0]} masquerade (${IF_WAN})"
    iptables ${cmd_[1]} FORWARD -i ${IF_WAN} -o ${IF_LAN} -j ACCEPT && \
    iptables ${cmd_[1]} FORWARD -i ${IF_LAN} -o ${IF_WAN} -j ACCEPT
    eend $? "Failed to ${msg_[0]} forward (${IF_LAN} <-> ${IF_WAN})"
}
