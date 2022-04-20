LanRouter set debug_ 0

#Create simulator object
set ns [new Simulator]

#Open nam trace file
set nf [open wired_1.nam w]
$ns namtrace-all $nf

#Open tr trace file
set tf [open wired_1.tr w]
$ns trace-all $tf

#Finish procedure
proc finish {} {
    global ns nf tf
    $ns flush-trace
    #Close the nam trace
    close $nf
    #Close the trace
    close $tf
    #Execute nam on the trace file
    exec nam wired_1.nam &
    exit 0
}

#Nodes (wants 60 nodes from parameters)
set node_number 64
for {set i 0} {$i<$node_number} {incr i} {
    set n($i) [$ns node]
}

#Link
for {set i 0} {$i < $node_number} {incr i} {
    set lan [$ns newLan "$n($i) $n([expr ($i+1)%7])" 1Mb 10ms LL Queue/DropTail MAC/Csma/Cd]
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

#Runs the simulation
$ns run