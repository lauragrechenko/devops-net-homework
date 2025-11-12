#!/usr/bin/env python3
import json, os, time, re
from datetime import datetime

def mem_info():
    vals = {}
    with open("/proc/meminfo") as f:
        for line in f:
            m = re.match(r"(\w+):\s+(\d+)", line)
            if m:
                vals[m.group(1)] = int(m.group(2))  # in kB
    total_kb = vals.get("MemTotal", 0)
    avail_kb = vals.get("MemAvailable", 0)
    used_kb = max(total_kb - avail_kb, 0)
    used_pct = round((used_kb / total_kb) * 100.0, 1) if total_kb else 0.0
    return {
        "mem_total_mb": round(total_kb / 1024, 1),
        "mem_used_mb": round(used_kb / 1024, 1),
        "mem_used_percent": used_pct,
    }

def disk_root():
    st = os.statvfs("/")
    total = st.f_frsize * st.f_blocks
    avail = st.f_frsize * st.f_bavail
    used = total - avail
    used_pct = round((used / total) * 100.0, 1) if total else 0.0
    return {
        "disk_root_total_gb": round(total / (1024**3), 2),
        "disk_root_used_gb": round(used / (1024**3), 2),
        "disk_root_used_percent": used_pct,
    }

def main():
    ts = int(time.time())
    row = {"timestamp": ts}
    row.update(mem_info())
    row.update(disk_root())

    log_name = datetime.now().strftime("%y-%m-%d") + "-awesome-monitoring.log"
    log_path = os.path.join("/var/log", log_name)

    with open(log_path, "a", buffering=1) as f:
        f.write(json.dumps(row, separators=(",", ":")) + "\n")

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        err_name = datetime.now().strftime("%y-%m-%d") + "-awesome-monitoring.log.err"
        with open(os.path.join("/var/log", err_name), "a") as ef:
            ef.write(f"{int(time.time())} {repr(e)}\n")
