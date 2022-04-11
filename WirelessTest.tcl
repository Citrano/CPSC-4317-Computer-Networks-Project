#Define variables

set val(chan)       Channel/WirelessChannel
set val(prop)       Propagation/TwoRayGround
set val(netif)      Phy/WirelessPhy
set val(mac)        Mac/802_11
set val(ifq)        Queue/DropTail/PriQueue
set val(ll)         LL
set val(ant)        Antenna/OmniAntenna
set val(ifqlen)     50
set val(nn)         60
set val(rp)         DSDV
set val(x)          500
set val(y)          500
set val(stop)       100
set val(traffic)    cbr
set val(traffic)    udp

#Create simulator object
set ns [new Simulator]

#Open nam trace file
set nf [open Wireless.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

#Open tr trace file
set tf [open Out.tr w]
$ns trace-all $tf

#Topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

# create god
set god_ [create-god $val(nn)]

# config nodes
$ns node-config -adhocRouting $val(rp) \
                -llType $val(ll) \
                -macType $val(mac) \
                -ifqType $val(ifq) \
                -ifqLen $val(ifqlen) \
                -antType $val(ant) \
                -propType $val(prop) \
                -phyType $val(netif) \
                -channelType $val(chan) \
                -topoInstance $topo \
                -agentTrace ON \
                -routerTrace ON \
                -macTrace ON \
                -movementTrace ON

#Nodes (wants 60 nodes from parameters)
for {set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
}

#Define initial position 
for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $n($i) 30
}

#Stop procedure
proc stop {} {
    global ns nf tf
    $ns flush-trace
    close $nf
    close $tf
    exec nam Wireless.nam &
}

#Random moving positions
proc destination {} {
    global ns val n
    set time 1.0
    set now [$ns now]
    for {set i 0} {$i < $val(nn)} {incr i} {
        set xx [expr rand()*400]
        set yy [expr rand()*250]
        $ns at $now "$n($i) setdest $xx $yy 0.0
    }

    $ns at [expr $now+$time] "destination"
}

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"

$ns at 10.5 "puts \"end simulation\"; $ns halt"

$ns run