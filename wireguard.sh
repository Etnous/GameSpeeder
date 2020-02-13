#!/usr/bin/env bash

#######################################################
# Title: Install WireGuard                            #
# Author: Etnous                                      #
# Blog: https://lala.biz                              #
# Update date: December 11, 2019                      #
#######################################################
#==========Define color==========
Green_font_prefix="\033[32m"
Red_font_prefix="\033[31m"
Yellow_font_prefix="\033[1;33m"
Green_background_prefix="\033[42;37m"
Red_background_prefix="\033[41;37m"
Font_color_suffix="\033[0m"

info=${Green_font_prefix}[Info]${Font_color_suffix}
error=${Red_font_prefix}[Error]${Font_color_suffix}
tip=${Red_font_prefix}[Tip]${Font_color_suffix}
#================================

#chek root
check_root(){
  [[ $EUID -ne 0 ]] && echo -e "${error}This script must be executed as root!" && exit 1
}

#check os
check_os(){
  osfile="/etc/os-release"
  if [ -e $osfile ] && [ $(uname -m) == "x86_64" ]; then
    source $osfile
    case "$ID" in
      centos)
        if [[ $VERSION_ID -ge "7" ]]; then
              os_version="centos"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1
        fi
      ;;
      debian)
        if [[ $VERSION_ID -ge "9" ]]; then
              os_version="debian"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1

        fi
      ;;
      ubuntu)
        if [[ $VERSION_ID == "16.04" ]] || [[ $VERSION_ID == "18.04" ]]; then
              os_version="ubuntu"
              echo -e "${info}${Yellow_font_prefix}Your system is $ID$VERSION_ID.${Font_color_suffix}\n"
        else
              echo -e "${error}${Yellow_font_prefix}Wrong VERSION_ID!${Font_color_suffix}\n" && exit 1
        fi
      ;;
      *)
        echo -e "Wrong ID" && exit 1
      ;;
    esac

  else
    echo -e "${error}${Yellow_font_prefix}This script doesn't support your system!${Font_color_suffix}\n"
  fi
}

check_wireguard(){
  if [[ -d /etc/wireguard ]]; then
      echo -e "WireGuard: ${Green_font_prefix}Installed${Font_color_suffix}\n"
  else
      echo -e "WireGuard: ${Red_font_prefix}NotInstalled${Font_color_suffix}\n"
      jj="notinstalled"
  fi
}

select_location(){
  echo -e "
======WireGuard Auto Install Script======
  Please select server location:
  ${Green_font_prefix}1.${Font_color_suffix} International
  ${Green_font_prefix}2.${Font_color_suffix} China"
  read -e -p "  Num: " location_num
  case $location_num in
  1)
    if [[ $os_version == "centos" ]] && [[ $VERSION_ID == "7" ]]; then
      echo -e 'nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
      rpm -vih https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "centos" ]] && [[ $VERSION_ID == "8" ]]; then
      echo -e 'nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
      rpm -vih https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "debian"  ]] && [[ $VERSION_ID == "9" ]]; then
      echo -e 'nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
      echo 'deb http://deb.debian.org/debian stretch main contrib non-free
            deb-src http://deb.debian.org/debian stretch main contrib non-free
            deb http://deb.debian.org/debian-security/ stretch/updates main contrib non-free
            deb-src http://deb.debian.org/debian-security/ stretch/updates main contrib non-free
            deb http://deb.debian.org/debian stretch-updates main contrib non-free
            deb-src http://deb.debian.org/debian stretch-updates main contrib non-free
            deb http://deb.debian.org/debian stretch-backports main
            deb-src http://deb.debian.org/debian stretch-backports main' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "debian" ]] && [[ $VERSION_ID == "10" ]]; then
      echo -e 'nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
      echo 'deb http://deb.debian.org/debian buster main contrib non-free
            deb-src http://deb.debian.org/debian buster main contrib non-free
            deb http://deb.debian.org/debian-security/ buster/updates main contrib non-free
            deb-src http://deb.debian.org/debian-security/ buster/updates main contrib non-free
            deb http://deb.debian.org/debian buster-updates main contrib non-free
            deb-src http://deb.debian.org/debian buster-updates main contrib non-free
            deb http://deb.debian.org/debian buster-backports main
            deb-src http://deb.debian.org/debian buster-backports main' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "16.04" ]]; then
      echo -e 'nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
      echo 'deb http://us.archive.ubuntu.com/ubuntu/ xenial main restricted
            deb-src http://us.archive.ubuntu.com/ubuntu/ xenial main restricted
            deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
            deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates main restricted
            deb http://us.archive.ubuntu.com/ubuntu/ xenial universe
            deb-src http://us.archive.ubuntu.com/ubuntu/ xenial universe
            deb http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe
            deb-src http://us.archive.ubuntu.com/ubuntu/ xenial-updates universe' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "18.04" ]]; then
      echo -e 'nameserver 1.1.1.1\nnameserver 8.8.8.8\nnameserver 8.8.4.4'> /etc/resolv.conf
      echo 'deb http://us.archive.ubuntu.com/ubuntu/ bionic main restricted
            deb-src http://us.archive.ubuntu.com/ubuntu/ bionic main restricted
            deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted
            deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates main restricted
            deb http://us.archive.ubuntu.com/ubuntu/ bionic universe
            deb-src http://us.archive.ubuntu.com/ubuntu/ bionic universe
            deb http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe
            deb-src http://us.archive.ubuntu.com/ubuntu/ bionic-updates universe' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"
    fi
    ;;
  2)
    if [[ $os_version == "centos" ]] && [[ $VERSION_ID == "7" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      rm -rf /etc/yum.repos.d/CentOS-Base.repo
      wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo &>/dev/null
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "centos" ]] && [[ $VERSION_ID == "8" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      rm -rf /etc/yum.repos.d/CentOS-Base.repo
      wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-8.repo &>/dev/null
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "debian"  ]] && [[ $VERSION_ID == "9" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb http://mirrors.aliyun.com/debian/ stretch main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ stretch main non-free contrib
            deb http://mirrors.aliyun.com/debian-security stretch/updates main
            deb-src http://mirrors.aliyun.com/debian-security stretch/updates main
            deb http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ stretch-updates main non-free contrib
            deb http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ stretch-backports main non-free contrib' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "debian" ]] && [[ $VERSION_ID == "10" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb https://mirrors.aliyun.com/debian  buster main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ buster main non-free contrib
            deb http://mirrors.aliyun.com/debian-security buster/updates main
            deb-src http://mirrors.aliyun.com/debian-security buster/updates main
            deb http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ buster-updates main non-free contrib
            deb http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib
            deb-src http://mirrors.aliyun.com/debian/ buster-backports main non-free contrib' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "16.04" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-security main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-updates main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-proposed main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ xenial-backports main restricted universe multiverse' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"

    elif [[ $os_version == "ubuntu" ]] && [[ $VERSION_ID == "18.04" ]]; then
      echo -e 'nameserver 114.114.114.114\nnameserver 114.114.115.115'> /etc/resolv.conf
      echo 'deb http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
            deb http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-security main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-updates main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-proposed main restricted universe multiverse
            deb-src http://mirrors.aliyun.com/ubuntu/ bionic-backports main restricted universe multiverse' > /etc/apt/sources.list
      echo -e "${info}${Yellow_font_prefix}Successfully change the repository!${Font_color_suffix}"
    fi
    ;;
  esac
}

init_wireguard(){
  if [[ $1 == "a" ]]; then
    echo -e "
======WireGuard Auto Install Script======
  Please input ${Green_font_prefix}WireGuard Listen Port: ${Font_color_suffix}"
    read -e -p "  Port: " WireGuardListenPort
    echo -e "\n  Please input the client name: "
    read -e -p "  Client Name: " client_name
    echo -e "\n  Please input the interface name: "
    read -e -p "  Interface Name: " eth_name
    echo -e "\n  Please input the server ip: "
    read -e -p "  Server IP: " server_ip


  elif [[ $1 == "b" ]]; then
    echo -e "
======WireGuard Auto Install Script======
  Please input ${Green_font_prefix}WireGuard Listen Port: ${Font_color_suffix}"
    read -e -p "  Port: " WireGuardListenPort
    echo -e "\n  Please input the client name: "
    read -e -p "  Client Name: " client_name
    echo -e "\n  Please input the interface name: "
    read -e -p "  Interface Name: " eth_name
    echo -e "\n  Please input the server ip: "
    read -e -p "  Server IP: " server_ip
    echo -e "\n  Please input the ${Green_font_prefix}UdpSpeeder Port: ${Font_color_suffix}"
    read -e -p "  UdpSpeeder Port: " udpspeeder_port
    echo -e "\n  Please input ${Green_font_prefix}PC Gate: ${Font_color_suffix}"
    read -e -p "  PC Gate: " pc_gate


  elif [[ $1 == "c" ]]; then
    echo -e "
======WireGuard Auto Install Script======
  Please input ${Green_font_prefix}WireGuard Listen Port: ${Font_color_suffix}"
    read -e -p "  Port: " WireGuardListenPort
    echo -e "\n  Please input the client name: "
    read -e -p "  Client Name: " client_name
    echo -e "\n  Please input the interface name: "
    read -e -p "  Interface Name: " eth_name
    echo -e "\n  Please input the server ip: "
    read -e -p "  Server IP: " server_ip
    echo -e "\n  Please input the ${Green_font_prefix}UdpSpeeder Port: ${Font_color_suffix}"
    read -e -p "  UdpSpeeder Port: " udpspeeder_port
    echo -e "\n  Please input ${Green_font_prefix}PC Gate: ${Font_color_suffix}"
    read -e -p "  PC Gate: " pc_gate
    echo -e "\n  Please input ${Green_font_prefix}Udp2Raw Port: ${Font_color_suffix}"
    read -e -p "  Udp2Raw Port: " udp2raw_port
  fi

}


install_wireguard(){
  clear

  case $os_version in
  centos)
    cd /root/ && yum update -y
    systemctl stop firewalld
    systemctl disable firewalld
    curl -Lo /etc/yum.repos.d/wireguard.repo https://copr.fedorainfracloud.org/coprs/jdoss/wireguard/repo/epel-7/jdoss-wireguard-epel-7.repo
    yum install epel-release -y
    yum install wireguard-dkms wireguard-tools tar -y
    mkdir /etc/wireguard
    ;;
  debian)
    cd /root && apt update -y
    apt install -y libmnl-dev libelf-dev linux-headers-$(uname -r) build-essential pkg-config git tar resolvconf
    git clone https://github.com/Etnous/wireguard.git
    cd /root/wireguard/src && make && make install
    rm -rf /root/wireguard
    ;;
  ubuntu)
    add-apt-repository ppa:WireGuard/WireGuard
    apt-get update
    apt-get install WireGuard
    ;;
  esac

  mkdir -p /root/wgclient/$client_name
  wg genkey | tee /etc/wireguard/privatekey | wg pubkey > /etc/wireguard/publickey
  wg genkey | tee /root/wgclient/$client_name/p$client_name | wg pubkey > /root/wgclient/$client_name/c$client_name
  sprivate=$(cat /etc/wireguard/privatekey)
  spublic=$(cat /etc/wireguard/publickey)
  cprivate=$(cat /root/wgclient/$client_name/p$client_name)
  cpublic=$(cat /root/wgclient/$client_name/c$client_name)

  cat > /etc/wireguard/wg0.conf <<-EOF
[Interface]
Address = 10.0.0.1/24
PrivateKey = $sprivate
ListenPort = $WireGuardListenPort
PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $eth_name -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $eth_name -j MASQUERADE
DNS=1.1.1.1

#ClientName=$client_name
[Peer]
PublicKey = $cpublic
AllowedIPs = 10.10.10.2/32
EOF

  cat > /root/wgclient/$client_name/$client_name.conf <<-EOF
[Interface]
PrivateKey = $cprivate
Address = 10.10.10.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $spublic
Endpoint = $server_ip:$WireGuardListenPort
AllowedIPs = 0.0.0.0/0
EOF
  rm -rf /root/wgclient/$client_name/p$client_name /root/wgclient/$client_name/c$client_name
  echo "net.ipv4.ip_forward = 1" >> /etc/sysctl.conf && sysctl -p
  cat > /etc/wireguard/config <<-EOF
WireGuardListenPort=$WireGuardListenPort
eth_name=$eth_name
server_ip=$server_ip
EOF
  systemctl enable wg-quick@wg0 && wg-quick up wg0
  if [[ $? -ne 0 ]]; then
    echo -e "${error} Fail to install WireGuard." && exit 1
  else
    echo -e "\n${info} Successfully installed WireGuard. Client file location: /root/wgclient/$client_name/$client_name.conf"
  fi
}

install_wireguard_udpspeeder(){
  install_wireguard
  cd /root
  mkdir -p /root/speeder
  wget -P /root/speeder https://github.com/Etnous/GameSpeeder/releases/download/v1.0/speeder.tar.gz
  tar -zxf /root/speeder/speeder.tar.gz -C /root/speeder
  mv /root/speeder/speederv2_amd64 /usr/src/speederv2
  rm -rf /root/speeder/
  cat > /lib/systemd/system/speeder.service <<-EOF
[Unit]
Description=Udpspeeder
After=network.target

[Service]
Restart=always
Type=simple
ExecStart=/usr/src/speederv2 -s -l0.0.0.0:$udpspeeder_port -r127.0.0.1:$WireGuardListenPort -f2:4 --mode 0 --timeout 0

[Install]
WantedBy=multi-user.target
EOF
  cat > /root/wgclient/$client_name/$client_name-udpspeeder.conf <<-EOF
[Interface]
PrivateKey = $cprivate
PostUp = mshta vbscript:CreateObject("WScript.Shell").Run("cmd /c route add $server_ip mask 255.255.255.255 $pc_gate METRIC 20 & start /b c:/udp/speederv2.exe -c -l0.0.0.0:23455 -r$server_ip:$udpspeeder_port -f2:4 --mode 0 --timeout 0",0)(window.close)
PostDown = route delete $server_ip && taskkill /im speederv2.exe /f
Address = 10.10.10.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $spublic
Endpoint = 127.0.0.1:23455
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
  echo "udpspeeder_port=$udpspeeder_port" >> /etc/wireguard/config
  systemctl enable speeder.service
  systemctl restart speeder.service
  if [[ $? -ne 0 ]]; then
    echo -e "${error} Fail to install WireGuard + UdpSpeeder." && exit 1
  else
    echo -e "\n${info} Successfully installed WireGuard + UdpSpeeder. Client file location: /root/wgclient/$client_name/$client_name-udpspeeder.conf"
  fi
}

install_wireguard_udpspeeder_udp2raw(){
  install_wireguard_udpspeeder
  cd /root
  mkdir -p /root/udp2raw
  wget -P /root/udp2raw/ https://github.com/Etnous/GameSpeeder/releases/download/v1.0/udp2raw.tar.gz
  tar -zxf /root/udp2raw/udp2raw.tar.gz -C /root/udp2raw
  mv /root/udp2raw/udp2raw_amd64 /usr/src/udp2raw
  rm -rf /root/udp2raw
  cat > /lib/systemd/system/udp2raw.service <<-EOF
[Unit]
Description=Udp2Raw
After=network.target

[Service]
Restart=always
Type=simple
ExecStart=/usr/src/udp2raw -s -l0.0.0.0:$udp2raw_port -r 127.0.0.1:$udpspeeder_port --raw-mode faketcp -a -k lala

[Install]
WantedBy=multi-user.target
EOF
  cat > /root/wgclient/$client_name/$client_name-udp2raw.conf <<-EOF
[Interface]
PrivateKey = $cprivate
PostUp = mshta vbscript:CreateObject("WScript.Shell").Run("cmd /c route add $server_ip mask 255.255.255.255 $pc_gate METRIC 20 & start /b c:/udp/udp2raw.exe -c -l127.0.0.1:45678 -r$server_ip:$udp2raw_port --raw-mode faketcp -k lala & start /b c:/udp/speederv2.exe -c -l0.0.0.0:23455 -r127.0.0.1:45678 -f2:4 --mode 0 --timeout 0",0)(window.close)
PostDown = route delete $server_ip && taskkill /im speederv2.exe /f && taskkill /im udp2raw.exe /f
Address = 10.10.10.2/24
DNS = 1.1.1.1

[Peer]
PublicKey = $spublic
Endpoint = 127.0.0.1:23455
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
  echo "udp2raw_port=$udp2raw_port" >> /etc/wireguard/config
  systemctl enable udp2raw.service
  systemctl restart udp2raw.service
  if [[ $? -ne 0 ]]; then
    echo -e "${error} Fail to install WireGuard + UdpSpeeder + Udp2Raw." && exit 1
  else
    echo -e "\n${info} Successfully installed WireGuard + UdpSpeeder + Udp2Raw. Client file location: /root/wgclient/$client_name/$client_name-udp2raw.conf"
  fi
}

update_kernel(){
  select_location
  if [[ $os_version == "centos" ]] && [[ $VERSION_ID == "7" ]]; then
    yum update -y
    rpm --import https://www.elrepo.org/RPM-GPG-KEY-elrepo.org
    rpm -Uvh http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm
    yum -y --enablerepo=elrepo-kernel install kernel-ml-devel kernel-ml
    sed -i "s/GRUB_DEFAULT=saved/GRUB_DEFAULT=0/" /etc/default/grub
    grub2-mkconfig -o /boot/grub2/grub.cfg
    
  elif [[ $os_version == "debian"  ]] && [[ $VERSION_ID == "9" ]]; then
    apt update -y && apt dist-upgrade -yq
    apt install -t stretch-backports linux-image-amd64 linux-headers-amd64 -yq
    apt clean

  else
    echo -e "${tip}  Nothing to update." && exit 1
  fi

  echo -e "\n  ${info} Updated, Reboot right now?"
  read -e -p "[Y/N}: " j
  case $j in
  y|Y)
    reboot
    ;;
  *)
    echo -e "\nCancelled\n" && exit 1
    ;;
  esac
}

add_user(){
  clear
  check_wireguard >/dev/null 2>&1
  [[ $jj == "notinstalled" ]] && echo -e "\n  ${error}You have not installed the WireGuard." && exit 1
  source /etc/wireguard/config

  systemctl list-units | grep speeder.service >/dev/null 2>&1
  if [[ $? -eq 0 ]]; then
    systemctl list-units | grep udp2raw.service >/dev/null 2>&1
    [[ $? -eq 0 ]] && je=udp2raw || je=speeder
  else
    je=wireguard
  fi

  if [[ $je == "wireguard" ]]; then
    echo -e "======WireGuard Auto Install Script======
    Please input the client name."
    read -e -p "  Client Name: " addclient_name
  else
    echo -e "======WireGuard Auto Install Script======
    Please input the client name."
    read -e -p "  Client Name: " addclient_name
    echo -e "\n  Please input ${Green_font_prefix}PC Gate: ${Font_color_suffix}"
    read -e -p "  PC Gate: " pc_gate
  fi

  mkdir -p /root/wgclient/$addclient_name
  wg genkey | tee /root/wgclient/$addclient_name/p$addclient_name | wg pubkey > /root/wgclient/$addclient_name/c$addclient_name
  cprivate=$(cat /root/wgclient/$addclient_name/p$addclient_name)
  cpublic=$(cat /root/wgclient/$addclient_name/c$addclient_name)
  spublic=$(cat /etc/wireguard/publickey)
  ipnum=$(grep Allowed /etc/wireguard/wg0.conf | tail -1 | awk -F '[ ./]' '{print $6}')
  newnum=$((10#${ipnum}+1))
  cat >> /etc/wireguard/wg0.conf <<-EOF
#ClientName=$addclient_name
[Peer]
PublicKey = $cpublic
AllowedIPs = 10.10.10.$newnum/32
EOF

  case $je in
  wireguard)
    add_wireguard
    ;;
  speeder)
    add_wireguard
    add_speeder
    ;;
  udp2raw)
    add_wireguard
    add_speeder
    add_udp2raw
    ;;
  esac
}

add_wireguard(){
  cat > /root/wgclient/$addclient_name/$addclient_name.conf <<-EOF
[Interface]
PrivateKey = $cprivate
Address = 10.10.10.$newnum/24
DNS = 1.1.1.1

[Peer]
PublicKey = $spublic
Endpoint = $server_ip:$WireGuardListenPort
AllowedIPs = 0.0.0.0/0
EOF
  wg-quick down wg0
  wg-quick up wg0
  rm -rf /root/wgclient/$addclient_name/p$addclient_name /root/wgclient/$addclient_name/c$addclient_name
  echo -e "\n ${info} Successfully added. Client file location: /root/wgclient/$addclient_name/$addclient_name.conf"
}

add_speeder(){
  cat > /root/wgclient/$addclient_name/$addclient_name-udpspeeder.conf <<-EOF
[Interface]
PrivateKey = $cprivate
PostUp = mshta vbscript:CreateObject("WScript.Shell").Run("cmd /c route add $server_ip mask 255.255.255.255 $pc_gate METRIC 20 & start /b c:/udp/speederv2.exe -c -l0.0.0.0:23455 -r$server_ip:$udpspeeder_port -f2:4 --mode 0 --timeout 0",0)(window.close)
PostDown = route delete $server_ip && taskkill /im speederv2.exe /f
Address = 10.10.10.$newnum/24
DNS = 1.1.1.1

[Peer]
PublicKey = $spublic
Endpoint = 127.0.0.1:23455
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
  wg-quick down wg0
  wg-quick up wg0
  rm -rf /root/wgclient/$addclient_name/p$addclient_name /root/wgclient/$addclient_name/c$addclient_name
  echo -e "\n ${info} Successfully added. Client file location: /root/wgclient/$addclient_name/$addclient_name-udpspeeder.conf"
}

add_udp2raw(){
  cat > /root/wgclient/$addclient_name/$addclient_name-udp2raw.conf <<-EOF
[Interface]
PrivateKey = $cprivate
PostUp = mshta vbscript:CreateObject("WScript.Shell").Run("cmd /c route add $server_ip mask 255.255.255.255 $pc_gate METRIC 20 & start /b c:/udp/udp2raw.exe -c -l127.0.0.1:45678 -r$server_ip:$udp2raw_port --raw-mode faketcp -k lala & start /b c:/udp/speederv2.exe -c -l0.0.0.0:23455 -r127.0.0.1:45678 -f2:4 --mode 0 --timeout 0",0)(window.close)
PostDown = route delete $server_ip && taskkill /im speederv2.exe /f && taskkill /im udp2raw.exe /f
Address = 10.10.10.$newnum/24
DNS = 1.1.1.1

[Peer]
PublicKey = $spublic
Endpoint = 127.0.0.1:23455
AllowedIPs = 0.0.0.0/0
PersistentKeepalive = 25
EOF
  wg-quick down wg0
  wg-quick up wg0
  rm -rf /root/wgclient/$addclient_name/p$addclient_name /root/wgclient/$addclient_name/c$addclient_name
  echo -e "\n ${info} Successfully added. Client file location: /root/wgclient/$addclient_name/$addclient_name-udp2raw.conf"
}

main(){
  clear
  check_root
  check_os
  echo -e "
======WireGuard Auto Install Script======
 ${Green_font_prefix}1.${Font_color_suffix}  Install WireGuard(Udp Only)
 ${Green_font_prefix}2.${Font_color_suffix}  Install WireGuard & UdpSpeeder(Udp Only)
 ${Green_font_prefix}3.${Font_color_suffix}  Install WireGuard & UdpSpeeder & Udp2Raw(Tcp Only)
 ${Green_font_prefix}4.${Font_color_suffix}  Update Kernel
 ${Green_font_prefix}5.${Font_color_suffix}  Add User
=========================================="
  check_wireguard
  read -e -p "Input number[1-5]:" select_num
  case $select_num in
  1)
    select_location && init_wireguard a && install_wireguard
    ;;
  2)
    select_location && init_wireguard b && install_wireguard_udpspeeder
    ;;
  3)
    select_location && init_wireguard c && install_wireguard_udpspeeder_udp2raw
    ;;
  4)
    update_kernel
    ;;
  5)
    add_user
    ;;
  *)
    echo -e "\n${Red_font_prefix}Cancelled${Font_color_suffix}\n" && exit 1
    ;;
  esac
}
main
