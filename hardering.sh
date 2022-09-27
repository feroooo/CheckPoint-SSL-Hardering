#!/bin/bash
#====================================================================================================
# Baslik:           hardering.sh
# Kullanim:         ./hardering.sh
# Amaci:            CheckPoint R81.10 surumunda zayif sertifika tiplerini otomatik kapatma.
# Sahibi:           Feridun OZTOK
# Versiyon:         1.2
# Tarih:            27 Eylul 2022
#====================================================================================================
#
#====================================================================================================
#Degiskenler
source /etc/profile.d/CP.sh
#====================================================================================================
#
#====================================================================================================
#Cihaz kurulur kurulmaz bu script calistirilsa asagidaki dosyalarin sistem uzerinde olması germekte.
#Bu dosyalar expert uzerinden cli komutlarını cagirmak icin bize yardimci olacak.
file="/var/log/egis/g_bash"
if [ -f "$file" ]
then
 echo "$file found."
else
 echo 'HAtest="$2 $3 $4 $5 $6 $7 $8 $9"' > /var/log/egis/g_bash
 echo "echo \$HAtest > /var/log/g_command.txt"  >> /var/log/egis/g_bash
 echo "\$CPDIR/bin/cprid_util -server \$1 putfile -local_file /var/log/g_command.txt -remote_file /var/log/g_command.txt" >> /var/log/egis/g_bash
 echo "\$CPDIR/bin/cprid_util -server \$1 -verbose rexec -rcmd /bin/bash -f /var/log/g_command.txt" >> /var/log/egis/g_bash
 chmod 777 /var/log/egis/g_bash
fi
file="/var/log/egis/g_cli"
if [ -f "$file" ]
then
 echo "$file found."
else
 echo 'HAtest="$2 $3 $4 $5 $6 $7 $8 $9"' > /var/log/egis/g_cli
 echo "echo \$HAtest > /var/log/g_command.txt"  >> /var/log/egis/g_cli
 echo "\$CPDIR/bin/cprid_util -server \$1 putfile -local_file /var/log/g_command.txt -remote_file /var/log/g_command.txt" >> /var/log/egis/g_cli
 echo "\$CPDIR/bin/cprid_util -server \$1 -verbose rexec -rcmd /bin/clish -f /var/log/g_command.txt" >> /var/log/egis/g_cli
 chmod 777 /var/log/egis/g_cli
fi
file="/bin/c"
if [ -f "$file" ]
then
 echo "$file found."
else
 echo "echo \$@ > /var/log/clish.txt" > /bin/c
 echo "clish -f /var/log/clish.txt" >> /bin/c
 chmod 770 /bin/c
fi
#====================================================================================================
#
#====================================================================================================
#Database i serbes birakiyoruz.
clish -c "lock database override" >> /dev/null 2>&1
clish -c "lock database override" >> /dev/null 2>&1
#====================================================================================================
#
#====================================================================================================
#Ekran temizligi
clear
#====================================================================================================
#
#====================================================================================================
#Reklamlar
echo
echo
echo *#######################################################*
echo *#__________ CheckPoint SSL Hardering Script _________##*
echo *#____________________ Version 1.2 ___________________##*
echo *#_____________ Creator by Feridun OZTOK _____________##*
echo *#_ Egis Proje ve Danismanlik Bilisim Hiz. Ltd. Sti. _##*
echo *#____________ support@egisbilisim.com.tr ____________##*
echo *#######################################################*
echo
echo
#====================================================================================================
#
#====================================================================================================
#Sistem surum denetimi.
current_version=$(cat /etc/cp-release)
sistemsurum=""
if [[ $current_version == *"R81.10"* ]]; then
 echo "System Version  : R81.10 - Script calismaya uygun"
 sistemsurum="Dogru"
else
 echo "Script calismasi icin surum uygun degil!" 
fi
#====================================================================================================
#
#====================================================================================================
#Sistem tipi.
if [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
   echo  "System Type     : System Type Gateway"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
   echo "System Type     : Management Server"
fi
#====================================================================================================
#
#====================================================================================================
#Sistem calisma suresi.
up_time=$(clish -c "show uptime")
echo "System Uptime   :"$up_time
#====================================================================================================
#
#====================================================================================================
if [[ $sistemsurum=="Dogru" ]]; then
echo "CLI tarafinda basit imzalar kapatiliyor."
clish -c "set ssh server cipher 3des-cbc off" 
clish -c "set ssh server cipher aes128-cbc off" 
clish -c "set ssh server cipher aes128-ctr on" 
clish -c "set ssh server cipher aes128-gcm@openssh.com on" 
clish -c "set ssh server cipher aes192-cbc off" 
clish -c "set ssh server cipher aes192-ctr on" 
clish -c "set ssh server cipher aes256-cbc off" 
clish -c "set ssh server cipher aes256-ctr on" 
clish -c "set ssh server cipher aes256-gcm@openssh.com on" 
clish -c "set ssh server cipher chacha20-poly1305@openssh.com on" 
clish -c "set ssh server cipher rijndael-cbc@lysator.liu.se off"
clish -c "set ssh server mac hmac-md5-96-etm@openssh.com off" 
clish -c "set ssh server mac hmac-md5-etm@openssh.com off" 
clish -c "set ssh server mac hmac-sha1 off" 
clish -c "set ssh server mac hmac-sha1-96-etm@openssh.com off" 
clish -c "set ssh server mac hmac-sha1-etm@openssh.com off" 
clish -c "set ssh server mac hmac-sha2-256 on" 
clish -c "set ssh server mac hmac-sha2-256-etm@openssh.com on" 
clish -c "set ssh server mac hmac-sha2-512 on" 
clish -c "set ssh server mac hmac-sha2-512-etm@openssh.com on" 
clish -c "set ssh server mac umac-64-etm@openssh.com off" 
clish -c "set ssh server mac umac-64@openssh.com off" 
clish -c "set ssh server mac umac-128-etm@openssh.com on" 
clish -c "set ssh server mac umac-128@openssh.com on" 
clish -c "save config"
fi
#====================================================================================================
#
#====================================================================================================
#Tekrar database i serbes birakiyoruz.
clish -c "lock database override" >> /dev/null 2>&1
clish -c "lock database override" >> /dev/null 2>&1
#====================================================================================================
#SSH tarafindaki diffie helman group 1 group 14 ile degistiriliyor.
#SSH tarafindaki diffie helman group exchange-sha1 exchange-sha256 1ile degistiriliyor
if [[ $sistemsurum=="Dogru" ]]; then
echo "SSH tarafinda Diffie Hellman Group1 kapatiliyor."
sed -i 's/KexAlgorithms +diffie-hellman-group1-sha1/KexAlgorithms +diffie-hellman-group14-sha1/' /etc/ssh/templates/sshd_config.templ
sed -i 's/KexAlgorithms +diffie-hellman-group-exchange-sha1/KexAlgorithms +diffie-hellman-group-exchange-sha256/' /etc/ssh/templates/sshd_config.templ
/bin/sshd_template_xlate < /config/active
service sshd reload
fi
#====================================================================================================
#
#====================================================================================================
#Cikis.
exit
#====================================================================================================