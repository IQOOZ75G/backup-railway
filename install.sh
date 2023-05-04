list=$(cat << EOF
ngrok_authtoken
ngrok_region
password
EOF
)

printf "\n Read config.txt....\n"
while IFS= read -r var; do
    eval ${var}=$(cat ./config.txt | grep -w -a -m1 "${var}" | sed "s/:/ /g" | awk '{print $2}')
    if [[ ${!var} == "" ]] 2> /dev/null || [ -z ${!var} ] 2> /dev/null; then
        echo "Config error!"
        echo "Please edit the config.txt file in repo!"
        exit 1
    else
        echo "${var} OK"
    fi
done < <(printf '%s\n' "$list")

chmod 777 ./ngrok
./ngrok authtoken $ngrok_authtoken > /dev/null 2>&1

printf "\n\n Instaling.....\n"
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add - > /dev/null 2>&1
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list > /dev/null 2>&1
apt update -y > /dev/null 2>&1
apt install apt-transport-https xfce4 xarchiver mesa-utils git xfce4-goodies pv nmap nano apt-utils dialog terminator autocutsel dbus-x11 dbus perl p7zip unzip zip curl tar git python3 python3-pip net-tools openssl tigervnc-standalone-server tigervnc-xorg-extension -y > /dev/null 2>&1
export HOME="$(cd ~/; pwd)"
export DISPLAY=":0"
mkdir ~/.vnc > /dev/null 2>&1
chmod -R 777 ~/.config > /dev/null 2>&1
printf '#!/bin/bash\ndbus-launch &> /dev/null\nautocutsel -fork\nxfce4-session\n' > ~/.vnc/xstartup 2> /dev/null
chmod 777 ~/.vnc/xstartup > /dev/null 2>&1

printf "\n\n Setting up VNC Ubuntu 22.04.....\n"
unset DBUS_LAUNCH
sudo ngrok tcp --region ap 127.0.0.1:5900 &> /dev/null &
vncserver -kill :0 &> /dev/null 2> /dev/null
sudo rm -rf /tmp/* 2> /dev/null
vncpasswd << EOF
${password}
${password}
y
${password}
${password}

EOF

printf "\n\n Starting VNC Ubuntu 22.04.....\n"
sudo ngrok tcp --region ap 127.0.0.1:5900 &> /dev/null &
vncserver -kill :0 &> /dev/null 2> /dev/null
sudo rm -rf /tmp/* 2> /dev/null
vncserver :0
sudo /sbin/sysctl -w net.ipv4.tcp_keepalive_time=10000 net.ipv4.tcp_keepalive_intvl=5000 net.ipv4.tcp_keepalive_probes=100
khanhall="$(service  --status-all 2> /dev/null | grep '\-' | awk '{print $4}')"
while IFS= read -r line; do
    nohup sudo service "$line" start &> /dev/null 2> /dev/null &
done < <(printf '%s\n' "$khanhall")
vncserver -localhost yes -geometry 1280x720 :0
clear
printf "\nYour IP Here: "
curl --silent --show-error http://127.0.0.1:4040/api/tunnels | sed -nE 's/.*public_url":"tcp:..([^"]*).*/\1/p'
export PS1='\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
printf "\n\n"
### This line by kmille36
seq 1 9999999999999 | while read i; do echo -en "\r Running .     $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ..    $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ...   $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ....  $i s /9999999999999 s";sleep 0.1;echo -en "\r Running ..... $i s /9999999999999 s";sleep 0.1;echo -en "\r Running     . $i s /9999999999999 s";sleep 0.1;echo -en "\r Running  .... $i s /9999999999999 s";sleep 0.1;echo -en "\r Running   ... $i s /9999999999999 s";sleep 0.1;echo -en "\r Running    .. $i s /9999999999999 s";sleep 0.1;echo -en "\r Running     . $i s /9999999999999 s";sleep 0.1; done
printf "\n\n\n\n\n Use VNC Viewer to connect!\n\n"
sleep 99999999999999999999999999999999999
