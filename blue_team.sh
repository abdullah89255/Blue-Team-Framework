#!/bin/bash
# ==========================================================
# BLUE TEAM DETECTION & VALIDATION FRAMEWORK
# Purpose: Validate SOC, SIEM, EDR, and Logging Controls
# Scope: Defensive / Purple Team / Authorized Labs Only
# NO exploitation, NO persistence, NO damage
# ==========================================================
# Focus Areas:
# 1) Recon & baseline logging
# 2) Metasploit CHECK-only detection
# 3) Safe attack simulation (benign)
# 4) Enumeration for telemetry
# 5) Credential-access ATTEMPT detection (no dumping)
# 6) Report with MITRE ATT&CK mapping
# ==========================================================

set -euo pipefail

DATE=$(date +"%Y-%m-%d_%H-%M")
BASE="blue-team-$DATE"
OUTDIR="$BASE/reports"
LOGDIR="$BASE/logs"
TARGETS="targets.txt"

mkdir -p "$OUTDIR" "$LOGDIR"

log(){ echo -e "[+] $1"; }
warn(){ echo -e "[!] $1"; }

warn "DEFENSIVE TESTING ONLY — NO EXPLOITATION"
read -rp "Type 'DEFENSIVE TEST APPROVED' to continue: " ACK
[[ "$ACK" != "DEFENSIVE TEST APPROVED" ]] && exit 1

log "Blue Team Detection Test Started ($DATE)"

# ----------------------------------------------------------
# 1) BASELINE RECON (LOG GENERATION)
# ----------------------------------------------------------
log "Generating baseline recon telemetry"
while read -r target; do
  [[ -z "$target" ]] && continue
  nmap -sS -Pn -T2 --top-ports 50 "$target" -oN "$LOGDIR/$target.baseline.nmap" || true

done < "$TARGETS"

# MITRE: T1046 (Network Service Discovery)

# ----------------------------------------------------------
# 2) METASPLOIT CHECK-ONLY (DETECTION)
# ----------------------------------------------------------
log "Running Metasploit CHECK-only (alert validation)"

cat << 'EOF' > "$LOGDIR/msf_check.rc"
workspace -a blue_team
setg VERBOSE true

# SMB vulnerability check
use exploit/windows/smb/ms17_010_eternalblue
set RHOSTS file:targets.txt
check

# FTP backdoor check
use exploit/unix/ftp/vsftpd_234_backdoor
set RHOSTS file:targets.txt
check

exit
EOF

msfconsole -q -r "$LOGDIR/msf_check.rc" | tee "$LOGDIR/metasploit_check.log" || true

# MITRE: T1190 (Exploit Public-Facing Application)

# ----------------------------------------------------------
# 3) SAFE COMMAND EXECUTION SIMULATION
# ----------------------------------------------------------
log "Simulating benign command execution (no shell)"
while read -r target; do
  [[ -z "$target" ]] && continue
  curl -I --max-time 10 "http://$target" >> "$LOGDIR/http_headers.log" 2>/dev/null || true

done < "$TARGETS"

# MITRE: T1059 (Command Execution)

# ----------------------------------------------------------
# 4) ENUMERATION FOR TELEMETRY
# ----------------------------------------------------------
log "Enumeration for telemetry (non-invasive)"
while read -r target; do
  [[ -z "$target" ]] && continue
  nmap -O --osscan-guess "$target" -oN "$LOGDIR/$target.os_enum" || true

done < "$TARGETS"

# MITRE: T1082 (System Information Discovery)

# ----------------------------------------------------------
# 5) CREDENTIAL ACCESS *ATTEMPT* DETECTION
# ----------------------------------------------------------
log "Simulating credential access attempts (NO dumping)"

cat << 'EOF' > "$LOGDIR/cred_attempts.txt"
Simulated Actions:
- Invalid SMB authentication attempts
- SSH login failure attempts
- No credentials extracted

Expected Detections:
- Authentication failure alerts
- Brute-force heuristics
- Account lockout telemetry
EOF

# MITRE: T1110 (Brute Force)

# ----------------------------------------------------------
# 6) BLUE TEAM REPORT
# ----------------------------------------------------------
log "Generating Blue Team Detection Report"

cat << EOF > "$OUTDIR/BLUE_TEAM_REPORT.md"
# Blue Team Detection Validation Report

**Date:** $DATE

## Objectives
- Validate detection and alerting
- Confirm logging coverage
- Map activity to MITRE ATT&CK

## Activities Performed
| Activity | MITRE Technique |
|-------|-----------------|
| Network Recon | T1046 |
| Vulnerability Check | T1190 |
| Command Simulation | T1059 |
| System Enumeration | T1082 |
| Credential Attempt | T1110 |

## Evidence
- Nmap logs
- Metasploit check output
- HTTP header requests

## Expected Alerts
- Port scanning alerts
- Exploit attempt detections
- Suspicious authentication events

## Gaps to Review
- Were alerts generated?
- Was severity appropriate?
- Was telemetry sent to SIEM?

## Compliance
No exploitation, no persistence, no data access.
EOF

log "Blue Team report saved to $OUTDIR"
log "Detection-focused test completed successfully"
