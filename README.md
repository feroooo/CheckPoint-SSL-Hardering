# CheckPoint SSL Hardering
CheckPoint R81.10 üzerinde varsayılan açık gelen zayıf şifreleme methotlarının devre dışı bırakılması için yazılmıştır. İşlerin ters gitmesi durumunda 


```
/etc/ssh/templates/sshd_config.templ içinde bulunan 

```
"KexAlgorithms +diffie-hellman-group14-sha1" satırı "KexAlgorithms +diffie-hellman-group1-sha1" 
"KexAlgorithms +diffie-hellman-group-exchange-sha256" satırı "KexAlgorithms +diffie-hellman-group-exchange-sha1" değiştirilip 
/bin/sshd_template_xlate < /config/active
service sshd reload 
```
komutları çalıştırılarak SSH tarafı toparlanabilir. Aynı şekilde 
