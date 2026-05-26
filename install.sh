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

# স্ক্রিন ক্লিয়ার করে আপনার ব্যানার দেখানো
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
echo -e " [\033[1;31m!\033[0m] Powered & Modified By Mawa"
echo -e "\033[1;34m-----------------------------------------\033[0m"
echo -e "${GREEN}[+] Initializing secure core environment...${RESET}"

# ২ সেকেন্ডের বিরতি যেন ইউজার আপনার ব্যানারটি দেখতে পারে
sleep 2.0

# Update Logic
if [ "\$1" == "update" ]; then
    echo -e "\033[1;32m[+] Fetching latest updates from Mawa4k's GitHub...\033[0m"
    git reset --hard HEAD > /dev/null 2>&1
    git pull origin main
    pip install -r requirements.txt --break-system-packages > /dev/null 2>&1
    chmod +x main.py
    bash install.sh > /dev/null 2>&1
    echo -e "\033[1;32m[✓] WiFuX updated successfully!\033[0m"
    exit 0
fi

if [ "\$1" == "help" ]; then
    python help.py
    exit 0
fi

if [ "\$1" == "fix" ]; then
    bash fix.sh
    exit 0
fi

if [ "\$1" == "contact" ]; then
    python contact.py
    exit 0
fi

# 'tsu -c' এর বদলে সরাসরি 'sudo' বা 'su -c' দিয়ে ফ্রন্টগ্রাউন্ডে রান করা
if [ "\$1" == "menu" ]; then
    sudo python main.py
    exit 0
fi

if [ "\$1" == "old" ]; then
    sudo python w1.py -i wlan0 -K
    exit 0
fi

if [ -z "\$1" ]; then
    sudo python main.py -i wlan0 -K
else
    sudo python main.py "\$@"
fi
EOF

chmod +x "$WIFUX_BIN"
echo -e "\n${GREEN}[✓] Local setup complete! Type 'wifux' to start.${RESET}"
