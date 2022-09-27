#!/bin/bash
#====================================================================================================
# Baslik:           hardering.sh
# Kullanim:         ./hardering.sh
# Amaci:            CheckPoint R81.10 surumunda zayif sertifika tiplerini otomatik kapatma.
# Sahibi:           Feridun OZTOK
# Versiyon:         1.1
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
echo *#____________________ Version 1.1 ___________________##*
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
 echo "System Version  : R81.10"
 echo "Script calismaya uygun."
 sistemsurum="Dogru"
else
 echo "Script calismasi icin surum uygun degil!" 
fi
#====================================================================================================
#
#====================================================================================================
#Sistem tipi.
sistemtip=0
if [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
   echo  "System Type     : System Type Gateway"
   sistemtip=1
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
#SSH tarafindaki diffie helman group 1 kapatiliyor.
echo "SSH tarafinda Diffie Hellman Group1 kapatiliyor."
sed -i 's/KexAlgorithms +diffie-hellman-group1-sha1/#KexAlgorithms +diffie-hellman-group1-sha1/' /etc/ssh/templates/sshd_config.templ
/bin/sshd_template_xlate < /config/active
service sshd reload
#====================================================================================================
#
#====================================================================================================
#Gateway icin basit imzalar devre disi birakiliyor.
if [ $sistemtip == 1 ]; then
echo "Multi Portaltarafinda basit imzalar kapatiliyor."
cd $FWDIR/conf
mv multi_portal_cipher_priority.conf multi_portal_cipher_priority.orj
echo "(" >> multi_portal_cipher_priority.conf
echo "        :version (3)" >> multi_portal_cipher_priority.conf
echo "        :tls_1_2_cipher_suites (" >> multi_portal_cipher_priority.conf
echo "                :list_name ("TLS 1.2 Ciphers")" >> multi_portal_cipher_priority.conf
echo "                :allowed (" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA384)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_AES_128_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_ECDSA_WITH_AES_256_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_3DES_EDE_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_RC4_128_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_RC4_128_MD5)" >> multi_portal_cipher_priority.conf
echo "                )" >> multi_portal_cipher_priority.conf
echo "                :forbidden (" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_AES_128_GCM_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_AES_256_GCM_SHA384)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_AES_128_CBC_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_AES_256_CBC_SHA256)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_AES_128_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                        : (TLS_RSA_WITH_AES_256_CBC_SHA)" >> multi_portal_cipher_priority.conf
echo "                )" >> multi_portal_cipher_priority.conf
echo "        )" >> multi_portal_cipher_priority.conf
echo ")" >> multi_portal_cipher_priority.conf
chmod --reference=multi_portal_cipher_priority.orj multi_portal_cipher_priority.conf
fi
#====================================================================================================
#
#====================================================================================================
#Cikis.
exit
#====================================================================================================