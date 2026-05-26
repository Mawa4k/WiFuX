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

# একটি পার্মানেন্ট ব্র্যান্ডিং র‍্যাপার তৈরি করা হচ্ছে
cat << 'PYEOF' > .permanent_brand.py
import os
import sys
import builtins

# আসল ফাংশনগুলোর ব্যাকআপ রাখা
real_print = builtins.print
real_system = os.system

def my_brand():
    real_system("clear")
    real_print("\033[1;32m _    _  _____ ______ _    _ __   __")
    real_print("| |  | ||_   _|  ____| |  | |\ \ / /")
    real_print("| |  | |  | | | |__  | |  | | \ V / ")
    real_print("| |  | |  | | |  __| | |  | |  > <  ")
    real_print("| |__| | _| |_| |    | |__| | / . \ ")
    real_print(" \____/ |_____|_|     \____/ /_/ \_\\\\\033[0m")
    real_print("\033[1;33m-----------------------------------------\033[0m")
    real_print(" ✦ \033[1;36mAuthor   :\033[0m MD MAWA ISLAM")
    real_print(" ✦ \033[1;36mGitHub   :\033[0m Mawa4k")
    real_print(" ✦ \033[1;36mFacebook :\033[0m https://www.facebook.com/mawa4k")
    real_print(" ✦ \033[1;36mWebsite  :\033[0m https://msrmawa.pro.bd")
    real_print("\033[1;33m-----------------------------------------\033[0m")
    real_print(" \033[1;35m★ Version\033[0m : \033[1;32mv2.0 [Target Mode]\033[0m")
    real_print("")
    real_print(" [\033[1;31m!\033[0m] Powered & Modified By Mawa")
    real_print("\033[1;34m-----------------------------------------\033[0m")

def custom_system(command):
    # মেইন ফাইল যদি স্ক্রিন ক্লিয়ার করতে চায়, তবে ক্লিয়ার করার পরপরই আমাদের ব্যানার আবার প্রিন্ট হবে
    if "clear" in command:
        real_system("clear")
        my_brand()
        return 0
    return real_system(command)

def custom_print(*args, **kwargs):
    # আসল ফাইলের ব্যানার বা লেখকের নাম প্রিন্ট করা ব্লক করা হলো
    text = " ".join(map(str, args))
    if "Author" in text or "WiFuX" in text or " Sakibur " in text or "╔══" in text:
        return
    real_print(*args, **kwargs)

# পাইথনের কোর মেকানিজম ওভাররাইড করা
os.system = custom_system
builtins.print = custom_print

if __name__ == "__main__":
    my_brand()
    # মূল অবফাসকেটেড ফাইলটি সরাসরি কারেন্ট সেলে লোড করা
    import main
PYEOF

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

# সরাসরি sudo দিয়ে আমাদের পার্মানেন্ট র‍্যাপারটি রান করা
if [ "\$1" == "menu" ]; then
    sudo python .permanent_brand.py
    exit 0
fi

if [ "\$1" == "old" ]; then
    sudo python w1.py -i wlan0 -K
    exit 0
fi

if [ -z "\$1" ]; then
    sudo python .permanent_brand.py -i wlan0 -K
else
    sudo python .permanent_brand.py "\$@"
fi
EOF

chmod +x "$WIFUX_BIN"
echo -e "\n${GREEN}[✓] Local setup complete! Type 'wifux' to start.${RESET}"
