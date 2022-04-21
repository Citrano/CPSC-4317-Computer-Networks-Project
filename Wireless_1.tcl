#this is for the first wireless tcl file
set val(chan)   Channel/WirelessChannel
set val(prop)   Propagation/TwoRayGround
set val(netif)  Phy/WirelessPhy
set val(mac)    Mac/802_11
set val(ifq)    Queue/DropTail/PriQueue
set val(ll)     LL
set val(ant)    Antenna/OmniAntenna
set val(ifqlen) 50
set val(nn)     6
set val(rp)     AODV
set val(x)      500
set val(y)      500

set ns [new Simulator]

set tracefile [open wireless_1.tr w]
$ns trace-all $tracefile

set namfile [open wireless_1.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)

set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

create-god $val(nn)

set channel1 [new $val(chan)]
set channel2 [new $val(chan)]
set channel3 [new $val(chan)]

$ns node-config -adhocRouting $val(rp) \
  -llType $val(ll) \
  -macType $val(mac) \
  -ifqType $val(ifq) \
  -ifqLen $val(ifqlen) \
  -antType $val(ant) \
  -propType $val(prop) \
  -phyType $val(netif) \
  -topoInstance $topo \
  -agentTrace ON \
  -macTrace ON \
  -routerTrace ON \
  -movementTrace ON \
  -channel $channel1

for {set i 0} {$i<$val(nn)} {incr i} {
    set n($i) [$ns node]
    $ns initial_node_pos $n($i) 20
    $n($i) random-motion 0
}

for {set i 0} {$i<$val(nn)} {incr i} {
    set xx [expr rand()*500]
    set yy [expr rand()*500]

    $n($i) set X_ xx
    $n($i) set Y_ yy
    $n($i) set Z_ 0.0
}

set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set null0 [new Agent/Null]
$ns attach-agent $n(5) $null0
$ns connect $udp0 $null0

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 100.0 "finish"

proc finish {} {
    global ns tracefile namfile
    $ns flush-trace
    close $tracefile
    close $namfile
    exec nam wireless_1.nam &
    exit 0
}

$ns run