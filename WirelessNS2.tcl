#Kaden Carter, Cody Citrano, Alejandro Figueroa - CPSC 4317 Computer Networks - Dr. Bo Sun
#This Programming Script will demonstrate the simulation of a wireless NS2.

#Create simulator object
set ns [new Simulator]

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

#This is how we connect nodes BETWEEN link and Drop place something link node like $n0 $n1 1Mb 100ms
$ns duplex-link DropTail

#Call finish procedure - finish at 100 seconds (wants 100 seconds from parameters)
$ns at 100.0 "finish"

#Runs the simulation
$ns run