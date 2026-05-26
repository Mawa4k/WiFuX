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

# একটি র‍্যাপার পাইথন স্ক্রিপ্ট তৈরি করা যা মেইন ফাইলের বিল্ট-ইন প্রিন্ট ও ক্লিয়ার লজিক ইন্টারসেপ্ট করবে
cat << 'PYEOF' > .run_wrapper.py
import os
import sys
import builtins

# আসল প্রিন্ট ফাংশনটি ব্যাকআপ রাখা হচ্ছে
real_print = builtins.print

def custom_print(*args, **kwargs):
    # স্ক্রিপ্ট যখনই স্ক্রিন ক্লিয়ার করতে চাইবে বা কোনো ব্যানার প্রিন্ট করতে যাবে
    # আমরা আমাদের নিজস্ব কাস্টম ব্যানারটি সেখানে পুশ করব
    text = " ".join(map(str, args))
    if "Author" in text or "WiFuX" in text or " Sakibur " in text:
        return # পুরোনো ব্যানার বা লেখকের নাম প্রিন্ট হওয়া ব্লক করা হলো
    real_print(*args, **kwargs)

# বিল্ট-ইন প্রিন্ট ফাংশনকে আমাদের কাস্টম ফাংশন দিয়ে রিপ্লেস করা
builtins.print = custom_print

def show_brand():
    os.system("clear")
    real_print("\033[1;32m _    _  _____ ______ _    _ __   __")
    real_print("| |  | ||_   _|  ____| |  | |\ \ / /")
    real_print("| |  | |  | | | Antiquated  | | \ V / ")
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
    real_print(" [\033[1;31m!\033[0m] Update: Type \033[1;32mwifux update\033[0m in terminal")
    real_print("\033[1;34m-----------------------------------------\033[0m")

if __name__ == "__main__":
    show_brand()
    # ফ্রন্টগ্রাউন্ডে কোনো ব্যাকগ্রাউন্ড থ্রেড বা সাব-শেল ছাড়াই মেইন মডিউল ইমপোর্ট করা
    import main
PYEOF

# মূল কমান্ড এক্সিকিউশন লজিক (ফ্রন্টগ্রাউন্ড এক্সিকিউশন নিশ্চিত করা)
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

# সরাসরি ইন্টারঅ্যাক্টিভ এনভায়রনমেন্টে রুট প্রিভিলেজ সহ রান করা
tsu python .run_wrapper.py "\$@"
EOF

chmod +x "$WIFUX_BIN"
echo -e "\n${GREEN}[✓] Local setup complete! Type 'wifux' to start.${RESET}"
