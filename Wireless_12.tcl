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
set tracefile [open wireless_12.tr w]
$ns trace-all $tracefile

#Open nam trace file
set namfile [open wireless_12.nam w]
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

#CBR over UDP traffic pair 1
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0
set null0 [new Agent/Null]
$ns attach-agent $n(63) $null0
$ns connect $udp0 $null0

#CBR over UDP traffic pair 2
set udp1 [new Agent/UDP]
$ns attach-agent $n(1) $udp1
set cbr1 [new Application/Traffic/CBR]
$cbr1 set packetSize_ 1000
$cbr1 set interval_ 0.005
$cbr1 attach-agent $udp1
set null1 [new Agent/Null]
$ns attach-agent $n(62) $null1
$ns connect $udp1 $null1

#CBR over UDP traffic pair 3
set udp2 [new Agent/UDP]
$ns attach-agent $n(2) $udp2
set cbr2 [new Application/Traffic/CBR]
$cbr2 set packetSize_ 1000
$cbr2 set interval_ 0.005
$cbr2 attach-agent $udp2
set null2 [new Agent/Null]
$ns attach-agent $n(61) $null2
$ns connect $udp2 $null2

#CBR over UDP traffic pair 4
set udp3 [new Agent/UDP]
$ns attach-agent $n(3) $udp3
set cbr3 [new Application/Traffic/CBR]
$cbr3 set packetSize_ 1000
$cbr3 set interval_ 0.005
$cbr3 attach-agent $udp3
set null3 [new Agent/Null]
$ns attach-agent $n(60) $null3
$ns connect $udp3 $null3

#CBR over UDP traffic pair 5
set udp4 [new Agent/UDP]
$ns attach-agent $n(4) $udp4
set cbr4 [new Application/Traffic/CBR]
$cbr4 set packetSize_ 1000
$cbr4 set interval_ 0.005
$cbr4 attach-agent $udp4
set null4 [new Agent/Null]
$ns attach-agent $n(59) $null4
$ns connect $udp4 $null4

#CBR over UDP traffic pair 6
set udp5 [new Agent/UDP]
$ns attach-agent $n(5) $udp5
set cbr5 [new Application/Traffic/CBR]
$cbr5 set packetSize_ 1000
$cbr5 set interval_ 0.005
$cbr5 attach-agent $udp5
set null5 [new Agent/Null]
$ns attach-agent $n(58) $null5
$ns connect $udp5 $null5

#CBR over UDP traffic pair 7
set udp6 [new Agent/UDP]
$ns attach-agent $n(6) $udp6
set cbr6 [new Application/Traffic/CBR]
$cbr6 set packetSize_ 1000
$cbr6 set interval_ 0.005
$cbr6 attach-agent $udp6
set null6 [new Agent/Null]
$ns attach-agent $n(57) $null6
$ns connect $udp6 $null6

#CBR over UDP traffic pair 8
set udp7 [new Agent/UDP]
$ns attach-agent $n(7) $udp7
set cbr7 [new Application/Traffic/CBR]
$cbr7 set packetSize_ 1000
$cbr7 set interval_ 0.005
$cbr7 attach-agent $udp7
set null7 [new Agent/Null]
$ns attach-agent $n(56) $null7
$ns connect $udp7 $null7

#CBR over UDP traffic pair 9
set udp8 [new Agent/UDP]
$ns attach-agent $n(8) $udp8
set cbr8 [new Application/Traffic/CBR]
$cbr8 set packetSize_ 1000
$cbr8 set interval_ 0.005
$cbr8 attach-agent $udp8
set null8 [new Agent/Null]
$ns attach-agent $n(55) $null8
$ns connect $udp8 $null8

#CBR over UDP traffic pair 10
set udp9 [new Agent/UDP]
$ns attach-agent $n(9) $udp9
set cbr9 [new Application/Traffic/CBR]
$cbr9 set packetSize_ 1000
$cbr9 set interval_ 0.005
$cbr9 attach-agent $udp9
set null9 [new Agent/Null]
$ns attach-agent $n(54) $null9
$ns connect $udp9 $null9

#CBR over UDP traffic pair 11
set udp10 [new Agent/UDP]
$ns attach-agent $n(10) $udp10
set cbr10 [new Application/Traffic/CBR]
$cbr10 set packetSize_ 1000
$cbr10 set interval_ 0.005
$cbr10 attach-agent $udp10
set null10 [new Agent/Null]
$ns attach-agent $n(53) $null10
$ns connect $udp10 $null10

#CBR over UDP traffic pair 12
set udp11 [new Agent/UDP]
$ns attach-agent $n(11) $udp11
set cbr11 [new Application/Traffic/CBR]
$cbr11 set packetSize_ 1000
$cbr11 set interval_ 0.005
$cbr11 attach-agent $udp11
set null11 [new Agent/Null]
$ns attach-agent $n(52) $null11
$ns connect $udp11 $null11

#Schedule Procedures
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 0.5 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 4.5 "$cbr2 stop"
$ns at 0.5 "$cbr3 start"
$ns at 4.5 "$cbr3 stop"
$ns at 0.5 "$cbr4 start"
$ns at 4.5 "$cbr4 stop"
$ns at 0.5 "$cbr5 start"
$ns at 4.5 "$cbr5 stop"
$ns at 0.5 "$cbr6 start"
$ns at 4.5 "$cbr6 stop"
$ns at 0.5 "$cbr7 start"
$ns at 4.5 "$cbr7 stop"
$ns at 0.5 "$cbr8 start"
$ns at 4.5 "$cbr8 stop"
$ns at 0.5 "$cbr9 start"
$ns at 4.5 "$cbr9 stop"
$ns at 0.5 "$cbr10 start"
$ns at 4.5 "$cbr10 stop"
$ns at 0.5 "$cbr11 start"
$ns at 4.5 "$cbr11 stop"

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