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
set val(chan)           Channel/WirelessChannel     ;#Channel type
set val(prop)           Propagation/TwoRayGround    ;#Radio-propagation model
set val(netif)          Phy/WirelessPhy             ;#Network Inferface Type
set val(mac)            Mac/802_11                  ;#MAC Type
set val(ifq)            Queue/DropTail/PriQueue     ;#Interface Queue Type
set val(ll)             LL                          ;#Link Layer Type
set val(ant)            Antenna/OmniAntenna         ;#Antenna Model
set val(ifqlen)         50                          ;#Max Packet in ifq
set val(nn)             60                          ;#Number of Mobilenodes
set val(rp)             AODV                        ;#Routing Protocol

#Initialize Global Variables
set ns         [new Simulator]

#Open nam trace file
set nf          [open Out.nam w]
$ns namtrace-all $nf

#Open tr trace file
set tr          [open Wireless.tr w]
$ns trace-all $tr

#Define different color for data flows.
$ns color 1 Blue
$ns color 2 Red

#Setting up the topography object
set topo        [new Topography]

$topo load_flatgrid 500 500

#Creating God Variable
create-god $val(nn)

#Create a specified number of mobilenodes [$val(nn)] and "attach" them to the channel.
#Here two nodes are created: node(0) and node(1).

#Configure Nodes:

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
                -movementTrace OFF \

for {set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
    $n($i) random-motion 0                      ;#disable random motion
}

for {set i 0} {$i < $val(nn)} {incr i} {
    $ns initial_node_pos $n($i) 20
}

#Defining a transport agent for sending and attaching transport agent to receiver node.
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

#Defining a transport agent for receiving and attaching transport agent to receiver node.
set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0

#Connecting sending and receiving transport agents.
$ns connect $udp0 $null0

#Defining Application instance and attaching transport agent to application agent.
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

#Packet size in bytes and interval in seconds definition.
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005

#Schedule Procedures.
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

#Call finish procedure - finish at 100 seconds (wants 100 seconds from parameters).
$ns at 100.0 "finish"

#Finish procedure
proc finish {} {
    global ns nf tr
    $ns flush-trace

    #Closes the nam trace
    close $nf

    #Closes the trace
    close $tr

    exec nam Out.nam &
    exit 0
}

puts "Starting Simulation..."
$ns run