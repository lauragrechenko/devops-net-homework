#!/usr/bin/env bash
set -euo pipefail

# Creates/starts 3 Multipass VMs for a Redis Cluster lab.

VMS=(vm1 vm2 vm3)

CPUS="${CPUS:-1}"
MEM="${MEM:-1G}"
DISK="${DISK:-5G}"
IMAGE="${IMAGE:-22.04}"   # Ubuntu 22.04
CLOUD_INIT="${CLOUD_INIT:-./cloud-init.yaml}"

ensure_vm() {
  local name="$1"

  if multipass info "$name" >/dev/null 2>&1; then
    echo "$name exists"
    return
  fi

  echo "creating $name..."
  
  multipass launch --name "$name" --cpus "$CPUS" --memory "$MEM" --disk "$DISK" --cloud-init "$CLOUD_INIT" "$IMAGE"
}

start_vm() {
  local name="$1"
  local state
  state="$(multipass info "$name" 2>/dev/null | awk -F': ' '/State/ {print $2}')"

  if [[ "$state" == "Running" ]]; then
    echo "▶ $name already running"
  else
    echo "▶ starting $name..."
    multipass start "$name"
  fi
}

for vm in "${VMS[@]}"; do
  ensure_vm "$vm"
  start_vm "$vm"
done

echo
echo "VM IPs:"
for vm in "${VMS[@]}"; do
  ip="$(multipass info "$vm" | awk -F': ' '/IPv4/ {print $2; exit}')"
  echo "  $vm: $ip"
done