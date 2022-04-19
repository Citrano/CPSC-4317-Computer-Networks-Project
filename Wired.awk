{
    event = $1;
    time = $2;
    node_id = $3;
    pkt_size = $6;
    level = $4;

    if (event == "h" && $5 == "cbr") {
        sent++;
        if (!startTime || (time < startTime)) {
            startTime = time;
        }
    }

    if (event == "r" && $5 == "cbr") {
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