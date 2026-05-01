# IDS-IPS-Snort-Wazuh-Project
# Automated IDS/IPS using Snort, iptables and Wazuh

This project demonstrates a small real-world Intrusion Detection and Prevention System using Snort, iptables and Wazuh.

The system detects suspicious network activities such as ICMP ping attempts, ICMP flood attacks, Nmap SYN scans and port scans. When an attack is detected, a Bash script automatically extracts the attacker IP address from Snort alerts and blocks the attacker using iptables. The blocking action is also logged and forwarded to the Wazuh dashboard for centralized monitoring.

## Project Architecture

Attacker Machine → Victim Machine → Snort Detection → Auto Block Script → iptables Firewall → Wazuh Agent → Wazuh Server Dashboard

## Machines Used

1. Kali Linux Attacker
2. Ubuntu Victim Machine
3. Wazuh Server

## Main Features

- ICMP ping detection
- ICMP flood detection
- Nmap SYN scan detection
- Port scan detection
- Automatic attacker IP blocking
- Wazuh dashboard alert display
- Custom Wazuh rule descriptions

## Deployment Guide

### 1. Victim Machine

Install Snort and Wazuh Agent.

Add Snort rules to:

/etc/snort/rules/local.rules

Run Snort:

sudo snort -A fast -q -i ens37 -c /etc/snort/snort.conf -l /var/log/snort

Run auto-block script:

sudo bash /usr/local/bin/snort-auto-block.sh

### 2. Wazuh Server

Add custom rules to:

/var/ossec/etc/rules/local_rules.xml

Restart Wazuh manager:

sudo systemctl restart wazuh-manager

### 3. Attacker Machine

Test attacks:

ping VICTIM_IP

sudo ping -f VICTIM_IP

sudo nmap -sS -Pn VICTIM_IP

## Important Note

This project is for educational and lab testing purposes only. Use it only in a controlled environment where you have permission to test. Do not run scans or attacks against public systems or networks without authorization.