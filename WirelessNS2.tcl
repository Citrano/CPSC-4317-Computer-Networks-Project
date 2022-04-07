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
set ns_         [new Simulator]

#Open nam trace file
set nf          [open Wireless.nam w]
$ns namtrace-all $nf

#Open tr trace file
set tracefd     [open Wireless.tr w]
$ns_ trace-all $tracefd

#Define different color for data flows.
$ns_ color 1 Blue
$ns_ color 2 Red

#Simple Wireless
#------------------------------------------------------------------------------------------------------

#Setting up the topography object
set topography  [new Topography]

$topo load_flatgrid 500 500

#Creating God Variable
create-god $val(nn)

#Create a specified number of mobilenodes [$val(nn)] and "attach" them to the channel.
#Here two nodes are created: node(0) and node(1).

#Configure Nodes:

$ns_ node-config -adhocRouting $val(rp) \
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

#------------------------------------------------------------------------------------------------------
#End of simple Wireless

#Creates a variable for the needed number of nodes (wants 60 nodes from parameters).
for{set i 0} {$i < $val(nn)} {incr i} {
    set n($i) [$ns node]
    $node_($i) random-motion 0                      ;#disable random motion
}

#Defining a transport agent for sending and attaching transport agent to receiver node.
set udp0 [new Agent/UDP]
$ns_ attach-agent $n(0) $udp0

#Defining a transport agent for receiving and attaching transport agent to receiver node.
set null0 [new Agent/Null]
$ns_ attach-agent $n(3) $null0

#Connecting sending and receiving transport agents.
$ns_ connect $udp0 $null0

#Defining Application instance and attaching transport agent to application agent.
set cbr0 [new Application/Traffic/CBR]
$cbr0 attach-agent $udp0

#Packet size in bytes and interval in seconds definition.
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005

#Schedule Procedures.
$ns_ at 0.5 "$cbr0 start"
$ns_ at 4.5 "$cbr0 stop"

#Call finish procedure - finish at 100 seconds (wants 100 seconds from parameters).
$ns_ at 100.0 "finish"

#Finish procedure
proc finish {} {
    global ns_ nf tracefd
    $ns_ flush-trace

    #Closes the nam trace
    close $nf

    #Closes the trace
    close $tracefd

    exec nam Wireless.nam &
    exit 0
}

puts "Starting Simulation..."
$ns_ run