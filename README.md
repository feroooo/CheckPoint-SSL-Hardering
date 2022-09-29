# CheckPoint SSL Hardering
Bu script Feridun ÖZTOK tarafından CheckPoint R81 ve R81.10 üzerinde varsayılan açık gelen zayıf şifreleme metotlarının devre dışı bırakılması için yazılmıştır. 

R81 için uygulanan makale <a href="https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk147272" target="_blank">sk147272</a>

Script ile düzenlenmeyen multi_portal_cipher_priority.conf dosyasını için expert modda cipher_util uygulamasını kullanmanız gerekmektedir. Rapid7 ile yapılan zafiyet taraması sonucu aşağıdaki metotları devre dışı bırakabilirsiniz.
İlgili döküman <a href="https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk126613" target="_blank">sk126613</a>


```
TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA
TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA
TLS_RSA_WITH_AES_128_CBC_SHA
TLS_RSA_WITH_AES_128_CBC_SHA256
TLS_RSA_WITH_AES_128_GCM_SHA256
TLS_RSA_WITH_AES_256_CBC_SHA
TLS_RSA_WITH_AES_256_CBC_SHA256
TLS_RSA_WITH_AES_256_GCM_SHA384
```

Sistem üzerinde özel tanım ya da HotFix olabileceğini göz önününde bulundurarak işlemleri gerçekleştirin. Elinizde mutlaka sağlam bir yedek olmasına dikkat edin.

İşlerin ters gitmesi ve yedeğinizin olmaması durumunda; expert ve CLI'da işletim sisteminize uygun çözümleri uygulamanız gerekmektedir.

# SSH geri alma yöntemi 1
```
rm /etc/ssh/templates/sshd_config.templ
cp /etc/ssh/templates/sshd_config.orj /etc/ssh/templates/sshd_config.templ
rm /etc/ssh/templates/sshd_config.orj
/bin/sshd_template_xlate < /config/active
service sshd reload 
```

# SSH geri alma yöntemi 2
```
vi /etc/ssh/templates/sshd_config.templ
KexAlgorithms +diffie-hellman-group14-sha1 ---> KexAlgorithms +diffie-hellman-group1-sha1
KexAlgorithms +diffie-hellman-group-exchange-sha256 ---> KexAlgorithms +diffie-hellman-group-exchange-sha1
/bin/sshd_template_xlate < /config/active
service sshd reload 
```

# R81 geri alma yöntemi 1

```
rm /web/templates/httpd-ssl.conf.templ
cp /web/templates/httpd-ssl.conf.orj /web/templates/httpd-ssl.conf.templ
rm /web/templates/httpd-ssl.conf.orj
```

# R81 geri alma yöntemi 2
```
chmod u+w /web/templates/httpd-ssl.conf.templ
vi /web/templates/httpd-ssl.conf.templ
SSLCipherSuite HIGH:!RC4:!LOW:!EXP:!aNULL:!SSLv2:!MD5 ---> SSLCipherSuite ECDHE-RSA-AES256-SHA384:AES256-SHA256:!ADH:!EXP:RSA:+HIGH:+MEDIUM:!MD5:!LOW:!NULL:!SSLv2:!eNULL:!aNULL:!RC4:!SHA1
SSLProtocol -ALL {ifcmp = $httpd:ssl3_enabled 1}+{else}-{endif}TLSv1.2 ---> SSLProtocol -ALL {ifcmp = $httpd:ssl3_enabled 1}+{else}-{endif}SSLv3 +TLSv1 +TLSv1.1 +TLSv1.2
chmod u-w /web/templates/httpd-ssl.conf.templ
```

# R81.10 geri alma yöntemi
```
set ssh server cipher 3des-cbc on
set ssh server cipher aes128-cbc on 
set ssh server cipher aes192-cbc on 
set ssh server cipher aes256-cbc on 
set ssh server cipher rijndael-cbc@lysator.liu.se on
set ssh server mac hmac-md5-96-etm@openssh.com on 
set ssh server mac hmac-md5-etm@openssh.com on 
set ssh server mac hmac-sha1 on 
set ssh server mac hmac-sha1-96-etm@openssh.com on 
set ssh server mac hmac-sha1-etm@openssh.com on 
set ssh server mac umac-64-etm@openssh.com on 
set ssh server mac umac-64@openssh.com on 
save config
```

Saygılarımla.
