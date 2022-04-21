#Kaden Carter, Cody Citrano, Alejandro Figueroa - CPSC 4317 Computer Networks - Dr. Bo Sun
#This Programming Script will demonstrate the simulation of a wireless NS2. While running 64 nodes using 1 traffic pair.
#PARAMETERS
#Nodes: 60 (We tested it with 24 and 64 nodes. We decided to leave it at 64 to match traffic pairs.)
#Frame size: 1,000B
#Traffic: CBR over UDP
#Run Time: 100 seconds

{
    event = $1;
    time = $2;
    node_id = $3;
    pkt_size = $8;
    level = $4;

    if (event == "s" && level == "AGT") {
        sent++;
        if (!startTime || (time < startTime)) {
            startTime = time;
        }
    }

    if (event == "r" && level == "AGT") {
        receive++;
        if (time > stopTime) {
            stopTime = time;
        }
        recvdSize += pkt_size;
    }
}

END{
    printf("sent_packets\t %d\n",sent);
    printf("received_packets %d\n",receive);
    printf("Average Throughput[bps] = %.2f\tStartTime=%.2f\tStopTime = %.2f\n", ((recvdSize*8)/(stopTime-startTime)),startTime,stopTime);
}