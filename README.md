# CheckPoint SSL Hardering
Bu script Feridun ÖZTOK tarafından CheckPoint R81.10 üzerinde varsayılan açık gelen zayıf şifreleme methotlarının devre dışı bırakılması için yazılmıştır. 

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

İşlerin ters gitmesi ve yedeğinizin olmaması durumunda; expert modda sshd_config_.templ dosyasının tekrar düzenlenmesi ve CLI modunda kapatılan şifreleme metotlarının aktif edilmesi gerekmektedir.

```
vi /etc/ssh/templates/sshd_config.templ
KexAlgorithms +diffie-hellman-group14-sha1 ---> KexAlgorithms +diffie-hellman-group1-sha1
KexAlgorithms +diffie-hellman-group-exchange-sha256 ---> KexAlgorithms +diffie-hellman-group-exchange-sha1
/bin/sshd_template_xlate < /config/active
service sshd reload 
```

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
