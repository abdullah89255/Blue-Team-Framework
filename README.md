# Blue-Team-Framework
✅ **Blue-team / detection-focused version is ready.**
I’ve created a **separate defensive framework** and added it to the canvas.

This script is designed for **SOC, SIEM, EDR, and purple-team validation** — **not exploitation**.

---

## 🔵 What This Blue-Team Framework Does

### 🎯 Primary Goal

> **Answer one question:**
> **“Did our security controls detect this activity correctly?”**

---

## 🔍 Included Detection Scenarios (Safe)

### 1️⃣ Recon Telemetry

* Low-noise Nmap scans
* Validates:

  * Firewall logging
  * IDS/IPS alerts
  * Port-scan detection

**MITRE:** `T1046 – Network Service Discovery`

---

### 2️⃣ Metasploit CHECK-Only (Detection Validation)

* Uses **non-exploiting `check`**
* Tests:

  * SMB exploit attempt detection
  * FTP backdoor probe detection

**MITRE:** `T1190 – Exploit Public-Facing Application`

---

### 3️⃣ Command Execution Simulation (Benign)

* HTTP header requests only
* No payloads, no shells

**MITRE:** `T1059 – Command Execution`

---

### 4️⃣ System Enumeration (Telemetry Only)

* OS fingerprinting
* Version detection

**MITRE:** `T1082 – System Information Discovery`

---

### 5️⃣ Credential Access *Attempt* (No Dumping)

* Simulated auth failures (documentation-only)
* Used to verify:

  * Brute-force alerts
  * Account lockout rules

**MITRE:** `T1110 – Brute Force`

---

## 📊 Output You Get

* 📁 Raw logs (nmap, metasploit, curl)
* 📄 **Blue-Team Markdown Report**
* 🧠 MITRE ATT&CK mapping
* 📌 “Expected alerts” checklist for SOC

This is **perfect for**:

* SOC validation
* Purple-team exercises
* Security audits
* EDR rule tuning

---

## ▶ How to Run

```bash
chmod +x blue_team.sh
./blue_team.sh
```

You must type:

```
DEFENSIVE TEST APPROVED
```

to prevent accidental misuse.

---

## 🧠 How Professionals Use This

| Team        | Use                     |
| ----------- | ----------------------- |
| SOC         | Alert verification      |
| Blue team   | Coverage gaps           |
| Purple team | Attack → Detect mapping |
| Management  | Audit evidence          |

---


