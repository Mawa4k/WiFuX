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

# একটি ওয়াচডগ পাইথন স্ক্রিপ্ট তৈরি করা যা পুরোনো ব্যানার মুছে আপনার নাম বসাবে
cat << 'PYEOF' > .watchdog.py
import os
import sys
import time
import threading

def ThreadBranding():
    # পাইথন মেইন ফাইল লোড হয়ে স্ক্রিন ক্লিয়ার করার জন্য ১ সেকেন্ড অপেক্ষা করবে
    time.sleep(1.0)
    os.system("clear")
    print("\033[1;32m _    _  _____ ______ _    _ __   __")
    print("| |  | ||_   _|  ____| |  | |\ \ / /")
    print("| |  | |  | | | |__  | |  | | \ V / ")
    print("| |  | |  | | |  __| | |  | |  > <  ")
    print("| |__| | _| |_| |    | |__| | / . \ ")
    print(" \____/ |_____|_|     \____/ /_/ \_\\\\\033[0m")
    print("\033[1;33m-----------------------------------------\033[0m")
    print(" ✦ \033[1;36mAuthor   :\033[0m MD MAWA ISLAM")
    print(" ✦ \033[1;36mGitHub   :\033[0m Mawa4k")
    print(" ✦ \033[1;36mFacebook :\033[0m https://www.facebook.com/mawa4k")
    print(" ✦ \033[1;36mWebsite  :\033[0m https://msrmawa.pro.bd")
    print("\033[1;33m-----------------------------------------\033[0m")
    print(" \033[1;35m★ Version\033[0m : \033[1;32mv2.0 [Target Mode]\033[0m")
    print("")
    print(" [\033[1;31m!\033[0m] Update: Type \033[1;32mwifux update\033[0m in terminal")
    print("\033[1;34m-----------------------------------------\033[0m")

# থ্রেড চালু করে দেওয়া যেন ব্যাকগ্রাউন্ডে ওয়াচডগ কাজ করে
branding_thread = threading.Thread(target=ThreadBranding)
branding_thread.daemon = True
branding_thread.start()

# এবার মূল অবfাসকেটেড ফাইলটিকে ফ্রন্টগ্রাউন্ডে রুট হিসেবে রান করা
args = " ".join(sys.argv[1:])
os.system(f"tsu python main.py {args}")
PYEOF

# মূল কমান্ড এক্সিকিউশন লজিক
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

if [ "\$1" == "menu" ]; then
    python .watchdog.py
    exit 0
fi

if [ "\$1" == "old" ]; then
    tsu python w1.py -i wlan0 -K
    exit 0
fi

if [ -z "\$1" ]; then
    python .watchdog.py -i wlan0 -K
else
    python .watchdog.py "\$@"
fi
EOF

chmod +x "$WIFUX_BIN"
echo -e "\n${GREEN}[✓] Local setup complete! Type 'wifux' to start.${RESET}"
