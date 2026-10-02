# 🌐 GoogleCloudShellVPN

> Automated Tailscale VPN, exit node routing, and SSH provisioning toolkit for Google Cloud Shell ephemeral environments.

![Bash](https://img.shields.io/badge/Language-Bash%20%2F%20Shell-4EAA25?logo=gnu-bash&logoColor=white)
![Tailscale](https://img.shields.io/badge/VPN-Tailscale-24292E?logo=tailscale&logoColor=white)
![Google Cloud Shell](https://img.shields.io/badge/Platform-Google%20Cloud%20Shell-4285F4?logo=google-cloud&logoColor=white)
![Status](https://img.shields.io/badge/Status-Active-brightgreen)
![License](https://img.shields.io/badge/License-MIT-blue)

---

## 📖 Overview

**GoogleCloudShellVPN** is an automated deployment and lifecycle management toolkit designed to run Tailscale within Google Cloud Shell environments. It transforms Google Cloud Shell's free Linux containers into private, secure, and globally accessible Tailscale exit nodes with Tailscale SSH enabled.

Because Cloud Shell containers are ephemeral and reset after inactivity, this toolkit solves state persistence by synchronizing node keys and credentials from persistent home storage, injecting background startup hooks into `.bashrc`, and running automated 5-minute Git synchronization loops.

---

## ✨ Features

- **Zero-Install Portable Tailscale**: Bundles precompiled Linux x86_64 `tailscale` and `tailscaled` binaries, allowing immediate execution without requiring package manager installations or root package repo alterations.
- **Exit Node & Mesh Routing**: Advertises Cloud Shell as a full network exit node (`--advertise-exit-node`) with subnet route acceptance (`--accept-routes`) and Tailscale SSH support (`--ssh`).
- **State & Credential Persistence**: Automatically backs up and restores `tailscaled.state` and configuration between persistent user storage (`${HOME}/tailscale`) and `/var/lib/tailscale` with strict permissions (`chmod 700`).
- **Interactive Shell Auto-Start**: Installs a non-intrusive background execution hook in `${HOME}/.bashrc` to guarantee instant VPN activation whenever a Cloud Shell session is opened.
- **Embedded Tailscale Web Console**: Launches `tailscale web` in the background with dedicated output logging (`tailscale-web.log`) for graphical connection administration.
- **Automated Git Sync Loop**: Includes `sync.sh` and `sync_loop.sh` to stage, commit, and push repository changes every 300 seconds (5 minutes) with an interactive terminal countdown display.

---

## 🛠️ Tech Stack

- **Platform**: [Google Cloud Shell](https://cloud.google.com/shell) (Debian Linux Container)
- **Networking Engine**: [Tailscale](https://tailscale.com/) (WireGuard mesh protocol)
- **Scripting & Automation**: Bash Shell Scripting
- **Version Control**: Git

---

## 📁 Project Structure

```
GoogleCloudShellVPN/
├── start.sh              # Master launch, auto-start injection & daemon setup
├── sync.sh               # One-time Git staging, commit & push script
├── sync_loop.sh          # Continuous 5-minute background sync daemon
├── tailscale/            # Persisted state directory (tailscaled.state, configs)
└── tailscale-bin/        # Bundled x86_64 Tailscale & Tailscaled executables
```

---

## 🚀 Getting Started

### Prerequisites

- A Google account with access to [Google Cloud Shell](https://shell.cloud.google.com/)
- A free [Tailscale account](https://login.tailscale.com/)

### 1. Clone into Google Cloud Shell

Open your Google Cloud Shell terminal and run:

```bash
git clone https://github.com/AryansDevStudios/GoogleCloudShellVPN.git
cd GoogleCloudShellVPN
```

### 2. Make Scripts Executable

```bash
chmod +x start.sh sync.sh sync_loop.sh tailscale-bin/tailscale tailscale-bin/tailscaled
```

### 3. Launch Tailscale VPN

```bash
./start.sh
```

During the initial run, Tailscale will display an authentication URL. Open the link in your browser to authorize the Cloud Shell instance in your Tailnet.

### 4. Enable Exit Node in Tailscale Admin

1. Open the [Tailscale Admin Console](https://login.tailscale.com/admin/machines).
2. Locate your Cloud Shell machine name.
3. Click the `...` menu, select **Edit route settings**, and approve **Use as exit node**.

### 5. Continuous Sync Daemon (Optional)

To keep your local repository changes and Tailscale states synchronized to Git every 5 minutes:

```bash
./sync_loop.sh
```

---

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to open an issue or submit a pull request.

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).
