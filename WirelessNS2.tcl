#Kaden Carter, Cody Citrano, Alejandro Figueroa - CPSC 4317 Computer Networks - Dr. Bo Sun
#This Programming Script will demonstrate the simulation of a wireless NS2.

set ns [new Simulator]

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

#Node ***Place the needed number of nodes below. Unsure if still 60 or not.
set node_number 