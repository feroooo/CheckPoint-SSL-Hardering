#!/bin/bash
#====================================================================================================
# Baslik:           hardering.sh
# Kullanim:         ./hardering.sh
# Amaci:            CheckPoint R81 ve R81.10 surumlerinde zayif sertifika tiplerini otomatik kapatma.
# Sahibi:           Feridun OZTOK
# Versiyon:         1.3
# Tarih:            28 Eylul 2022
#====================================================================================================
#Degiskenler
#====================================================================================================
source /etc/profile.d/CP.sh
MEVCUTSURUM="Script Versiyon  : 1.3"
#====================================================================================================
#show_version_info Fonksiyon
#====================================================================================================
show_version_info()
{
	echo ""
	echo "Script Versiyon  : 1.3"  
	echo "Script Tarihi    : 28 Eylul 2022"  
	echo "Son Guncelleyen  : Feridun OZTOK"
	echo ""
	exit 0
}
#====================================================================================================
#versiyon_kontrol Fonksiyon
#====================================================================================================
versiyon_kontrol()
{
	sed '2,$d' surumyakala.txt > surumazalt.txt
	awk -F"MEVCUTSURUM="  '{print $2}' surumazalt.txt > surumkisa.txt
	sed 's/"//g' surumkisa.txt > surumtemizlenmis.txt
	GUNCELSURUM=$(<surumtemizlenmis.txt)
	rm surum*
	if [[ "$MEVCUTSURUM" == "$GUNCELSURUM" ]]
		then
			echo "$MEVCUTSURUM" "Script calismaya uygun"
         else
			echo "Kullanilan surum guncel degil. Surumun $GUNCELSURUM olmasi gerekiyor."
         echo "./hardering.sh -u komutu ile guncelleyebilirsiniz. Script kapanacak."
         exit
	fi		
}
#====================================================================================================
#show_help_infoFonksiyon
#====================================================================================================
show_help_info()
{
   echo ""
   echo "Bu script, Feridun OZTOK tarafindan Rapid7 taramasi sonucu CheckPoint"
	echo "uzerinde cikan SSL - TLS versiyon aciklarinin giderilmesi icin yazilmistir."
   echo "https://github.com/feroooo/CheckPoint-SSL-Hardering/tree/master"
	echo ""
	echo "Script SMS ve Gateway uzerinde calisabilmektedir."
	echo ""
	echo "Script ./hardering.sh seklinde calisir. Kullanilabilir diger parametreler -v -u -h 'dir"
	echo ""
	echo "./hardering.sh -v ile mecvut scriptin surumunu ogrenebilirsiniz."
	echo "./hardering.sh -u ile script surumunu guncelleyebilirsiniz."
	echo "./hardering.sh -h ve diger tum tuslar su an okudugunuz yardim menusunu getirecektir."
	echo ""
	exit 0
}
#====================================================================================================
#download_updates Fonksiyon
#====================================================================================================
download_updates()
{
	rm hardering.sh
	curl_cli http://dynamic.egisbilisim.com.tr/script/hardering.sh | cat > hardering.sh && chmod 770 hardering.sh
	exit 0
}
#====================================================================================================
#Fonksiyon Tuslari
#====================================================================================================
while getopts ":v :u :h" opt; do
    case "${opt}" in
        h)
            show_help_info
            ;;
        u)
			   download_updates
            ;;
        v)
            show_version_info
            ;;
        *)
            #Catch all for any other flags
            show_help_info
            exit 1
            ;;
    esac
done
#====================================================================================================
#Dosya Kontrol
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
#Database unlock
#====================================================================================================
clish -c "lock database override" >> /dev/null 2>&1
clish -c "lock database override" >> /dev/null 2>&1
#====================================================================================================
#Ekran temizligi
#====================================================================================================
rm surum*
curl_cli http://dynamic.egisbilisim.com.tr/script/hardering.sh | grep "MEVCUTSURUM" > surumyakala.txt
clear
#====================================================================================================
#Reklamlar
#====================================================================================================
echo
echo
echo *#######################################################*
echo *#__________ CheckPoint SSL Hardering Script _________##*
echo *#____________________ Version 1.3 ___________________##*
echo *#_____________ Creator by Feridun OZTOK _____________##*
echo *#_ Egis Proje ve Danismanlik Bilisim Hiz. Ltd. Sti. _##*
echo *#____________ support@egisbilisim.com.tr ____________##*
echo *#######################################################*
echo
echo
#====================================================================================================
#Sistem surum denetimi
#====================================================================================================
current_version=$(cat /etc/cp-release)
sistemsurum=""
if [[ $current_version == *"R81.10"* ]]; then
	echo "Sistem Versiyon  : R81.10 - Script calismaya uygun"
	sistemsurum="CLI"
elif [[ $current_version == *"R81"* ]]; then
	echo "Sistem Versiyon  : R81 - Script calismaya uygun"
	sistemsurum="Klasik"
fi
#====================================================================================================
#Sistem tipi
#====================================================================================================
sistemtip=""
if [[ $($CPDIR/bin/cpprod_util FwIsFirewallModule 2> /dev/null) == *"1"*  ]]; then
   echo  "Sistem Tipi      : Security Gateway"
   sistemtip="Gateway"
elif [[ $($CPDIR/bin/cpprod_util FwIsFirewallMgmt 2> /dev/null) == *"1"*  ]]; then
   echo "Sistem Tipi      : Management Server"
   sistemtip="Management"
fi
#====================================================================================================
#Sistem calisma suresi
#====================================================================================================
up_time=$(clish -c "show uptime")
echo "Sistem Acik      :"$up_time
#====================================================================================================
#Script calistigi zaman versiyon kontrolu yap.
#====================================================================================================
versiyon_kontrol
#====================================================================================================
#R81.10 icin metot degisimi
#====================================================================================================
if [[ "$sistemsurum" == "CLI" ]]; then
	echo
	echo "CLI tarafinda metot degisim islemi basliyor."
	clish -c "set ssh server cipher 3des-cbc off" 
	echo "set ssh server cipher 3des-cbc off" 
	clish -c "set ssh server cipher aes128-cbc off" 
	echo "set ssh server cipher aes128-cbc off" 
	clish -c "set ssh server cipher aes128-ctr on" 
	echo "set ssh server cipher aes128-ctr on" 
	clish -c "set ssh server cipher aes128-gcm@openssh.com on" 
	echo "set ssh server cipher aes128-gcm@openssh.com on" 
	clish -c "set ssh server cipher aes192-cbc off" 
	echo "set ssh server cipher aes192-cbc off" 
	clish -c "set ssh server cipher aes192-ctr on" 
	echo "set ssh server cipher aes192-ctr on" 
	clish -c "set ssh server cipher aes256-cbc off" 
	echo "set ssh server cipher aes256-cbc off" 
	clish -c "set ssh server cipher aes256-ctr on" 
	echo "set ssh server cipher aes256-ctr on" 
	clish -c "set ssh server cipher aes256-gcm@openssh.com on" 
	echo "set ssh server cipher aes256-gcm@openssh.com on" 
	clish -c "set ssh server cipher chacha20-poly1305@openssh.com on" 
	echo "set ssh server cipher chacha20-poly1305@openssh.com on" 
	clish -c "set ssh server cipher rijndael-cbc@lysator.liu.se off"
	echo "set ssh server cipher rijndael-cbc@lysator.liu.se off"
	clish -c "set ssh server mac hmac-md5-96-etm@openssh.com off" 
	echo "set ssh server mac hmac-md5-96-etm@openssh.com off" 
	clish -c "set ssh server mac hmac-md5-etm@openssh.com off" 
	echo "set ssh server mac hmac-md5-etm@openssh.com off" 
	clish -c "set ssh server mac hmac-sha1 off" 
	echo "set ssh server mac hmac-sha1 off" 
	clish -c "set ssh server mac hmac-sha1-96-etm@openssh.com off" 
	echo "set ssh server mac hmac-sha1-96-etm@openssh.com off" 
	clish -c "set ssh server mac hmac-sha1-etm@openssh.com off" 
	echo "set ssh server mac hmac-sha1-etm@openssh.com off" 
	clish -c "set ssh server mac hmac-sha2-256 on" 
	echo "set ssh server mac hmac-sha2-256 on" 
	clish -c "set ssh server mac hmac-sha2-256-etm@openssh.com on" 
	echo "set ssh server mac hmac-sha2-256-etm@openssh.com on" 
	clish -c "set ssh server mac hmac-sha2-512 on" 
	echo "set ssh server mac hmac-sha2-512 on" 
	clish -c "set ssh server mac hmac-sha2-512-etm@openssh.com on" 
	echo "set ssh server mac hmac-sha2-512-etm@openssh.com on" 
	clish -c "set ssh server mac umac-64-etm@openssh.com off" 
	echo "set ssh server mac umac-64-etm@openssh.com off" 
	clish -c "set ssh server mac umac-64@openssh.com off" 
	echo "set ssh server mac umac-64@openssh.com off" 
	clish -c "set ssh server mac umac-128-etm@openssh.com on" 
	echo "set ssh server mac umac-128-etm@openssh.com on" 
	clish -c "set ssh server mac umac-128@openssh.com on" 
	echo "set ssh server mac umac-128@openssh.com on" 
	clish -c "save config"
	echo
	echo "CLI tarafinda metot degisim islemi bitti. Ayarlar kaydedildi."
	echo
fi
#====================================================================================================
#R81 icin metot degisimi
#====================================================================================================
if [[ "$sistemsurum" == "Klasik" ]]; then
	cp /web/templates/httpd-ssl.conf.templ /web/templates/httpd-ssl.conf.orj
	echo
	echo "httpd-ssl.conf.templ icin yazma yetkisi aliniyor."
	chmod u+w /web/templates/httpd-ssl.conf.templ
	echo "SSLCipherSuite metotlari degistiriliyor."
	sed -i 's/SSLCipherSuite HIGH:!RC4:!LOW:!EXP:!aNULL:!SSLv2:!MD5/SSLCipherSuite ECDHE-RSA-AES256-SHA384:AES256-SHA256:!ADH:!EXP:RSA:+HIGH:+MEDIUM:!MD5:!LOW:!NULL:!SSLv2:!eNULL:!aNULL:!RC4:!SHA1/' /web/templates/httpd-ssl.conf.templ
	echo "SSLv3 TLSv1 TLSv1.1 kapatiliyor."
	sed -i 's/SSLProtocol -ALL {ifcmp = $httpd:ssl3_enabled 1}+{else}-{endif}SSLv3 +TLSv1 +TLSv1.1 +TLSv1.2/SSLProtocol -ALL {ifcmp = $httpd:ssl3_enabled 1}+{else}-{endif}TLSv1.2/' /web/templates/httpd-ssl.conf.templ
	echo "httpd-ssl.conf.templ icin yazma yetkisi kaldiriliyor."
	chmod u-w /web/templates/httpd-ssl.conf.templ
	/bin/template_xlate : /web/templates/httpd-ssl.conf.templ /web/conf/extra/httpd-ssl.conf < /config/active
	echo
	echo "httpd servisi yeniden baslatiliyor."
	tellpm process:httpd2
	tellpm process:httpd2 t
	echo
fi
#====================================================================================================
#SSH icin metot degisimi
#====================================================================================================
#Iki surum icinde /etc/ssh/templates/sshd_config.templ editlenecek.
cp /etc/ssh/templates/sshd_config.templ /etc/ssh/templates/sshd_config.orj
echo "SSH tarafindaki diffie helman group 1 group 14 ile degistiriliyor."
sed -i 's/KexAlgorithms +diffie-hellman-group1-sha1/KexAlgorithms +diffie-hellman-group14-sha1/' /etc/ssh/templates/sshd_config.templ
echo "SSH tarafindaki diffie helman group exchange-sha1 exchange-sha256 ile degistiriliyor."
sed -i 's/KexAlgorithms +diffie-hellman-group-exchange-sha1/KexAlgorithms +diffie-hellman-group-exchange-sha256/' /etc/ssh/templates/sshd_config.templ
echo
/bin/sshd_template_xlate < /config/active
echo
echo "ssh servisi yeniden baslatiliyor."
service sshd reload
echo
#====================================================================================================
#Gateway icin cipher_util uyarisi
#====================================================================================================
if [[ "$sistemtip" == "Gateway" ]]; then
	echo "Gateway uzerinde cipher_util ile ilave bir islem yapmaniz gerekmektedir. Asagida listelenen metotlari kapatmaniz tavsiye edilir."
	echo "TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA"
	echo "TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA"
	echo "TLS_RSA_WITH_AES_128_CBC_SHA"
	echo "TLS_RSA_WITH_AES_128_CBC_SHA256"
	echo "TLS_RSA_WITH_AES_128_GCM_SHA256"
	echo "TLS_RSA_WITH_AES_256_CBC_SHA"
	echo "TLS_RSA_WITH_AES_256_CBC_SHA256"
	echo "TLS_RSA_WITH_AES_256_GCM_SHA384"
	echo
	echo "cipher_util kullanimi icin: SK126613"
	echo
fi
#====================================================================================================
#Cikis
#====================================================================================================
exit

