#Kaden Carter, Cody Citrano, Alejandro Figueroa - CPSC 4317 Computer Networks - Dr. Bo Sun
#This Programming Script will demonstrate the simulation of a wireless NS2. While running 64 nodes using 1 traffic pair.
#PARAMETERS
#Nodes: 60
#Frame size: 1,000B
#Traffic: CBR over UDP
#Run Time: 100 seconds

#------------------
#Defining variables
#------------------
#Channel type
set val(chan)   Channel/WirelessChannel
#Radio-propagation model
set val(prop)   Propagation/TwoRayGround
#Network Inferface Type
set val(netif)  Phy/WirelessPhy
#MAC Type
set val(mac)    Mac/802_11
#Interface Queue Type
set val(ifq)    Queue/DropTail/PriQueue
#Link Layer Type
set val(ll)     LL
#Antenna Model
set val(ant)    Antenna/OmniAntenna
#Max Packet in ifq
set val(ifqlen) 50
#Number of Mobilenodes
set val(nn)     64
#Routing Protocol
set val(rp)     AODV
#Size of window
set val(x)      500
#Size of window
set val(y)      500

#Create simulator object
set ns [new Simulator]

#Open tr trace file
set tracefile [open wireless_1.tr w]
$ns trace-all $tracefile

#Open nam trace file
set namfile [open wireless_1.nam w]
$ns namtrace-all-wireless $namfile $val(x) $val(y)

#Topography
set topo [new Topography]
$topo load_flatgrid $val(x) $val(y)

#create God
create-god $val(nn)

#Create a channel
set channel1 [new $val(chan)]
#set channel2 [new $val(chan)]
#set channel3 [new $val(chan)]

#Config nodes
$ns node-config     -adhocRouting $val(rp) \
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

#Nodes (wants 60 nodes from parameters)
for {set i 0} {$i<$val(nn)} {incr i} {
    set n($i) [$ns node]
    $ns initial_node_pos $n($i) 20
    $n($i) random-motion 0
}

#Define initial position
for {set i 0} {$i<$val(nn)} {incr i} {
    set xx [expr rand()*500]
    set yy [expr rand()*500]

    $n($i) set X_ xx
    $n($i) set Y_ yy
    $n($i) set Z_ 0.0
}

#Random moving positions
for {set i 0} {$i < $val(nn)} {incr i} {
        set xx [expr rand()*450]
        set yy [expr rand()*450]
        
        $ns at 1.0 "$n($i) setdest $xx $yy 500.0"
}

#CBR over UDP traffic pair
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set null0 [new Agent/Null]
$ns attach-agent $n(63) $null0
$ns connect $udp0 $null0

#Schedule Procedures
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

#Call finish procedure - finish at 100 seconds (wants 100 seconds from parameters)
$ns at 100.0 "finish"

#Finish procedure
proc finish {} {
    global ns tracefile namfile

    $ns flush-trace

    #Close the trace
    close $tracefile

    #Close the nam trace
    close $namfile

    #Execute nam on the trace file
    exec nam wireless_1.nam &

    exit 0
}

$ns run