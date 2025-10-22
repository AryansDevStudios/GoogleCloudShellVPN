#!/bin/bash

echo "=== Starting Tailscale setup ==="
echo "Using PATH: $PATH"
echo

# Detect the current user's home directory dynamically
USER_HOME="${HOME}"
BIN_DIR="${USER_HOME}/tailscale-bin"
CONFIG_SRC="${USER_HOME}/tailscale"
LOG_DIR="${USER_HOME}"

# Verify tailscale binaries exist
if [ ! -f "${BIN_DIR}/tailscaled" ] || [ ! -f "${BIN_DIR}/tailscale" ]; then
    echo "❌ Error: tailscaled or tailscale not found in ${BIN_DIR}"
    exit 1
fi

# Stop any existing Tailscale daemon
echo "Stopping any existing tailscaled processes..."
sudo pkill -f tailscaled 2>/dev/null

# Copy configuration files to the correct location
echo "Copying configuration files..."
sudo mkdir -p /var/lib/tailscale
sudo cp -r "${CONFIG_SRC}/"* /var/lib/tailscale/ 2>/dev/null
sudo chown -R root:root /var/lib/tailscale
sudo chmod 700 /var/lib/tailscale

# Start the tailscaled daemon
echo
echo "Starting tailscaled..."
sudo "${BIN_DIR}/tailscaled" 2>&1 | tee "${LOG_DIR}/tailscaled.log" &

# Allow time for initialization
sleep 3

# Bring Tailscale online with desired settings
echo
echo "Running tailscale up..."
sudo "${BIN_DIR}/tailscale" up \
  --advertise-exit-node \
  --accept-routes \
  --accept-dns=false \
  --ssh &

# Display status
echo
echo "Tailscale status:"
sudo "${BIN_DIR}/tailscale" status

# Start the Web Console
echo
echo "Starting Web Console..."
sudo nohup "${BIN_DIR}/tailscale" web > "${LOG_DIR}/tailscale-web.log" 2>&1 &
echo "Web Console started (check log: ${LOG_DIR}/tailscale-web.log)"

echo
echo "=== ✅ Tailscale startup complete ==="
