# CheckPoint SSL Hardering
Bu script Feridun ÖZTOK tarafından CheckPoint R81.10 üzerinde varsayılan açık gelen zayıf şifreleme methotlarının devre dışı bırakılması için yazılmıştır. 


İşlerin ters gitmesi durumunda; expert modda sshd_config_.templ dosyasının tekrar düzenlenmesi ve CLI modunda kapatılan şifreleme methotlarının aktif edilmesi gerekmektedir.

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

