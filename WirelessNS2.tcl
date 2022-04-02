#Kaden Carter, Cody Citrano, Alejandro Figueroa - CPSC 4317 Computer Networks - Dr. Bo Sun
#This Programming Script will demonstrate the simulation of a wireless NS2.

#Create simulator object
set ns [new Simulator]

#Define different color for data flows.
$ns color 1 Blue
$ns color 2 Red

#Open nam trace file
set nf [open out.nam w]
$ns namtrace-all $nf

#Finish procedure
proc finish {} {
    global ns nf
    $ns flush-trace
    #Close the trace
    close $nf
    #Execute nam on the trace file
    exec nam out.nam &
    exit 0
}

#Nodes (wants 60 nodes from parameters)
set node_number 60

#UDP agent attachment
set udp0 [new Agent/UDP]
$ns attach-agent $n(0) $udp0

#CBR Traffic UDP attachment
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1000
$cbr0 set interval_ 0.005
$cbr0 attach-agent $udp0

#Null agent
set null0 [new Agent/Null]
$ns attach-agent $n(3) $null0

#Connect source with sink
$ns connect $udp0 $null0

#Schedule Procedures - finish at 100 seconds (wants 100 seconds from parameters)
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

#Call finish procedure - finish at 100 seconds (wants 100 seconds from parameters)
$ns at 100.0 "finish"

#Runs the simulation
$ns run