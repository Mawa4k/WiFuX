#!/data/data/com.termux/files/usr/bin/bash

GREEN="\033[1;32m"
YELLOW="\033[1;33m"
RESET="\033[0m"

echo -e "${GREEN}[+] Setting up local WiFuX environment...${RESET}"

echo -e "${GREEN}[+] Installing Python dependencies...${RESET}"
pip install -r requirements.txt --break-system-packages

chmod +x main.py

echo -e "${GREEN}[+] Setting up 'wifux' command...${RESET}"

BIN_DIR="$PREFIX/bin"
WIFUX_BIN="$BIN_DIR/wifux"
SCRIPT_DIR="$(pwd)"

cat > "$WIFUX_BIN" <<EOF
#!/data/data/com.termux/files/usr/bin/bash
cd "$SCRIPT_DIR" || exit

# লুপ ট্রিক: পাইথন পুরোপুরি চালু হওয়ার পর আপনার ব্যানারটি ওভাররাইট করবে
show_my_banner() {
    local pid=\$1
    while kill -0 \$pid 2>/dev/null; do
        sleep 2.0
        clear
        echo -e "\033[1;32m _    _  _____ ______ _    _ __   __"
        echo -e "| |  | ||_   _|  ____| |  | |\ \ / /"
        echo -e "| |  | |  | | | |__  | |  | | \ V / "
        echo -e "| |  | |  | | |  __| | |  | |  > <  "
        echo -e "| |__| | _| |_| |    | |__| | / . \ "
        echo -e " \____/ |_____|_|     \____/ /_/ \_\\\\\033[0m"
        echo -e "\033[1;33m-----------------------------------------\033[0m"
        echo -e " ✦ \033[1;36mAuthor   :\033[0m MD MAWA ISLAM"
        echo -e " ✦ \033[1;36mGitHub   :\033[0m Mawa4k"
        echo -e " ✦ \033[1;36mFacebook :\033[0m https://www.facebook.com/mawa4k"
        echo -e " ✦ \033[1;36mWebsite  :\033[0m https://msrmawa.pro.bd"
        echo -e "\033[1;33m-----------------------------------------\033[0m"
        echo -e " \033[1;35m★ Version\033[0m : \033[1;32mv2.0 [Target Mode]\033[0m"
        echo ""
        echo -e " [\033[1;31m!\033[0m] Update: Type \033[1;32mwifux update\033[0m in terminal"
        echo -e "\033[1;34m-----------------------------------------\033[0m"
        break
    done
}

# Update Logic
if [ "\$1" == "update" ]; then
    echo -e "\033[1;32m[+] Fetching latest updates from Mawa4k's GitHub...\033[0m"
    git reset --hard HEAD > /dev/null 2>&1
    git pull origin main

    echo -e "\033[1;32m[+] Checking for new requirements...\033[0m"
    pip install -r requirements.txt --break-system-packages > /dev/null 2>&1

    chmod +x main.py

    echo -e "\033[1;32m[+] Re-applying wifux command setup...\033[0m"
    bash install.sh > /dev/null 2>&1

    echo -e "\033[1;32m[✓] WiFuX updated successfully!\033[0m"
    exit 0
fi

# Help Logic
if [ "\$1" == "help" ]; then
    python help.py
    exit 0
fi

# Fix Logic
if [ "\$1" == "fix" ]; then
    bash fix.sh
    exit 0
fi

# Contact Logic
if [ "\$1" == "contact" ]; then
    python contact.py
    exit 0
fi

# Menu Logic
if [ "\$1" == "menu" ]; then
    tsu python main.py &
    PY_PID=\$!
    show_my_banner \$PY_PID
    wait \$PY_PID
    exit 0
fi

# Old Logic
if [ "\$1" == "old" ]; then
    tsu python w1.py -i wlan0 -K &
    PY_PID=\$!
    show_my_banner \$PY_PID
    wait \$PY_PID
    exit 0
fi

# Run Logic
if [ -z "\$1" ]; then
    tsu python main.py -i wlan0 -K &
    PY_PID=\$!
    show_my_banner \$PY_PID
    wait \$PY_PID
else
    tsu python main.py "\$@" &
    PY_PID=\$!
    show_my_banner \$PY_PID
    wait \$PY_PID
fi
EOF

chmod +x "$WIFUX_BIN"

echo -e "\n${GREEN}[✓] Local setup complete!${RESET}"
