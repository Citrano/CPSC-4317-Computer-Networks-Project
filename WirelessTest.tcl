#Kaden Carter, Cody Citrano, Alejandro Figueroa - CPSC 4317 Computer Networks - Dr. Bo Sun
#This Programming Script will demonstrate the simulation of a wireless NS2.
#PARAMETERS
#Nodes: 60
#Frame size: 1,000B
#Traffic: CBR over UDP
#Run Time: 100 seconds

#------------------
#Defining variables
#------------------
#Channel type
set val(chan)       Channel/WirelessChannel
#Radio-propagation model
set val(prop)       Propagation/TwoRayGround
#Network Inferface Type
set val(netif)      Phy/WirelessPhy
#MAC Type
set val(mac)        Mac/802_11
#Interface Queue Type
set val(ifq)        Queue/DropTail/PriQueue
#Link Layer Type
set val(ll)         LL
#Antenna Model
set val(ant)        Antenna/OmniAntenna
#Max Packet in ifq
set val(ifqlen)     50
#Number of Mobilenodes
set val(nn)         60
#Routing Protocol
set val(rp)         DSDV
#Size of window
set val(x)          500
#Size of window
set val(y)          500
#Allocated time
set val(stop)       100
#CBR traffic
set val(traffic)    cbr
#UDP traffic
set val(traffic)    udp

#Create simulator object
set ns [new Simulator]

#Open nam trace file
set nf [open WirelessNam.nam w]
$ns namtrace-all-wireless $nf $val(x) $val(y)

#Open tr trace file
set tf [open WirelessTrace.tr w]
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
        
        $ns at $now "$n($i) setdest $xx $yy 500.0
    }

    $ns at [expr $now+$time] "destination"
}

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"

$ns at 10.5 "puts \"end simulation\"; $ns halt"

$ns run