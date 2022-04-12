#Alex: found this to be the very basic structure for awk.

BEGIN {
    recv = 0;
    gotime = 1;
    time = 0;
    packet_size = $8;
    time_interval = 2;
}

{
    event = $1
    time = $2
    node_id = $3
    level = $4
    pktType = $7
    packet_size = $8

    if(time>gotime) {
        print gotime, (packet_size * recv * 8.0)/1000;
        gotime+= time_interval;
        recv = 0;
    }

    if ((event = "r") && (pktType == "udp") && (level == "AGT")) {
        recv++;
    }
}

END {
;
}