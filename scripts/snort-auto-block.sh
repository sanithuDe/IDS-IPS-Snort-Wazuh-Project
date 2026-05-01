#!/b	in/bash
in/bash

LOG_FILE="/var/log/snort/alert"
TEST_BLOCK_IP="192.168.85.129"

echo "[*] Starting Snort Auto Block System..."

#TEST BLOCK (for checking iptables)
echo "[*] Testing block for $TEST_BLOCK_IP"

iptables -C INPUT -s "$TEST_BLOCK_IP" -j DROP 2>/dev/null || \
iptables -A INPUT -s "$TEST_BLOCK_IP" -j DROP

logger "snort-block: TEST_BLOCKED attacker_ip=$TEST_BLOCK_IP"

echo "[*] Test block added for $TEST_BLOCK_IP"
echo "[*] Monitoring Snort alerts..."

#MAIN LOOP
tail -Fn0 "$LOG_FILE" | while read line
do
    SRC_IP=$(echo "$line" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -1)

    if [ -z "$SRC_IP" ]; then
        continue
    fi

    #ICMP Ping
    if echo "$line" | grep -q "ALERT_ICMP_PING"; then
        echo "[PING DETECTED] from $SRC_IP"
        logger "snort-block: ICMP_BLOCKED attacker_ip=$SRC_IP"

    #ICMP Flood
    elif echo "$line" | grep -q "ALERT_ICMP_FLOOD"; then
        echo "[FLOOD DETECTED] Blocking $SRC_IP"
        iptables -C INPUT -s "$SRC_IP" -j DROP 2>/dev/null || iptables -A INPUT -s "$SRC_IP" -j DROP
        logger "snort-block: ICMP_FLOOD_BLOCKED attacker_ip=$SRC_IP"

    #Nmap SYN Scan
    elif echo "$line" | grep -q "ALERT_NMAP_SYN"; then
        echo "[NMAP SCAN DETECTED] Blocking $SRC_IP"
        iptables -C INPUT -s "$SRC_IP" -j DROP 2>/dev/null || iptables -A INPUT -s "$SRC_IP" -j DROP
        logger "snort-block: NMAP_BLOCKED attacker_ip=$SRC_IP"

    #Port Scan
    elif echo "$line" | grep -q "ALERT_PORT_SCAN"; then
        echo "[PORT SCAN DETECTED] Blocking $SRC_IP"
        iptables -C INPUT -s "$SRC_IP" -j DROP 2>/dev/null || iptables -A INPUT -s "$SRC_IP" -j DROP
        logger "snort-block: PORTSCAN_BLOCKED attacker_ip=$SRC_IP"
    fi

done
