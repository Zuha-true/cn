set ns [new Simulator]

#Open Trace file and NAM file
set ntrace [open prog1.tr w]
$ns trace-all $ntrace
set namfile [open prog1.nam w]
$ns namtrace-all $namfile

#Finish Procedure
proc Finish {} {
    global ns ntrace namfile

    #Dump all the trace data and close the files
    $ns flush-trace
    close $ntrace
    close $namfile

    #Execute the NAM animation file
    exec nam prog1.nam &

    #Show the number of packets dropped
    exec echo "The number of packet drops is " &
    exec grep -c "d" prog1.tr &
    exit
}

#Create 3 nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]

#Label the nodes
$n0 label "TCP Source"
$n2 label "Sink"

#Set color
$ns color 1 blue

#Create Links between nodes
#(Modify bandwidth to observe packet drop variation)
$ns duplex-link $n0 $n1 100Mb 10ms DropTail
$ns duplex-link $n1 $n2 10Mb 10ms DropTail

#Set Orientation
$ns duplex-link-op $n0 $n1 orient right
$ns duplex-link-op $n1 $n2 orient right

#Set Queue Size
$ns queue-limit $n1 $n2 10

#Transport Layer — TCP & Sink
set tcp0 [new Agent/TCP]
set sink0 [new Agent/TCPSink]

$ns attach-agent $n0 $tcp0
$ns attach-agent $n2 $sink0
$ns connect $tcp0 $sink0

#Application Layer — CBR Traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 set type_ CBR
$cbr0 set packetSize_ 100
$cbr0 set rate_ 1Mb
$cbr0 set random_ false
$cbr0 attach-agent $tcp0

$tcp0 set class_ 1

#Schedule Events
$ns at 0.0 "$cbr0 start"
$ns at 5.0 "Finish"

#Run the Simulation
$ns run
