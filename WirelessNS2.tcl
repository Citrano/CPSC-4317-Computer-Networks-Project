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
set val(nn)             2                           ;#Number of Mobilenodes
set val(rp)             DSDV                        ;#Routing Protocol

#Initialize Global Variables
set ns_         [new Simulator]
set tracefd     [open Wireless.tr w]
$ns_ trace-all $tracefd

#Setting up the topography object
set topography  [new Topography]

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

for{set i 0} {$i < $val(nn)} {incr i} {
    set node_($i) [$ns_ node]
    $node_($i) random-motion 0                      ;#disable random motion
}

#Provide initial (X, Ym for now Z = 0) co-ordinates for mobilenodes.

$node_(0) set X_ 5.0
$node_(0) set Y_ 2.0
$node_(0) set Z_ 0.0

$node_(1) set X_ 390.0
$node_(1) set Y_ 385.0
$node_(1) set Z_ 0.0

#Now produce some simple node movements
#Node_(1) starts to move towards node(0)

$ns_ at 50.0 "$node_(1) setdest 25.0 20.0 15.0"
$ns_ at 10.0 "$node_(0) setdest 20.0 18.0 1.0"

#Node_(1) then starts to move away from node_(0).
$ns_ 100.0 "$node_(1) setdest 490.0 480.0 15.0"

#Setup traffic flow between nodes
#TCP connections between node_(0) and node_(1)

set tcp {new Agent/TCP}
$tcp set class_ 2
set sink [new Agent/TCPSink]
$ns_ attach-agent $node_(0) $tcp
$ns_ attach-agent $node_(1) $sink
$ns_ connect $tcp $sink
set ftp [new Application/FTP]
$ftp attach-agent $tcp
$ns_ at 10.0 "$ftp start"

#Tell nodes when the simulation ends
for{set i 0}{$i < $val(nn)}{incr i} {
    $ns_ at 150.0 "$node_($i) reset";
}
$ns_ at 150.0 "stop"
$ns_ at 150.01 "puts \"NS EXITING...\" ; $ns_ halt"
proc stop {} {
    global ns_ tracefd
    $ns_ flush-trace
    close $tracefd
}

puts "Starting Simulation..."
$ns_ run