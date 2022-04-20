LanRouter set debug_ 0

#Create simulator object
set ns [new Simulator]

#Open nam trace file
set nf [open wired_4.nam w]
$ns namtrace-all $nf

#Open tr trace file
set tf [open wired_4.tr w]
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
    exec nam wired_4.nam &
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

#Schedule Procedures
$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"
$ns at 0.5 "$cbr1 start"
$ns at 4.5 "$cbr1 stop"
$ns at 0.5 "$cbr2 start"
$ns at 4.5 "$cbr2 stop"
$ns at 0.5 "$cbr3 start"
$ns at 4.5 "$cbr3 stop"

#Call finish procedure - finish at 100 seconds (wants 100 seconds from parameters)
$ns at 100.0 "finish"

#Runs the simulation
$ns run