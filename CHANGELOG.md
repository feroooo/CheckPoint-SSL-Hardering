<body>
  <h1>Change Log</h1>

<p><h2>Sürüm V1.3 - 28 Eylül 2022</h2></p>
<p><h3>Eklenen</h3></p>
<p>R81 için httpd-ssl.conf.templ dosyasını düzenleme özelliği eklendi.</p>
<p>Sürüm kontrol eklendi.</p>
<p>Sürüm güncelleme fonksiyonu eklendi. ./hardering.sh -u</p>
<p>Sürüm bilgisi öğrenme fonksiyonu eklendi. ./hardering.sh -v</p>
<p>Yardım menüsü eklendi. ./hardering.sh -h</p>
<p>Değiştirilen dosyaların işlem öncesi kopyası alınmaya başladı.</p>
<p><h3>Çıkarılan</h3></p>
<p>N/A</p>
<p><h3>Değiştirilen</h3></p>
<p>N/A</p>

<p><h2>Sürüm V1.2 - 27 Eylül 2022</h2></p>
<p><h3>Eklenen</h3></p>
<p>SSH server için "KexAlgorithms +diffie-hellman-group-exchange-sha1" "KexAlgorithms +diffie-hellman-group-exchange-sha256" ile değiştirilmesi için "sed -i 's/KexAlgorithms +diffie-hellman-group-exchange-sha1/KexAlgorithms +diffie-hellman-group-exchange-sha256/' /etc/ssh/templates/sshd_config.templ" komutu eklendi.</p>
<p><h3>Çıkarılan</h3></p>
<p>cipher_util için hazırlanan multi_portal_cipher_priority.conf dosya yapılandırması çalışmadığı için çıkartıldı. İlgili döküman numarası <a href="https://supportcenter.checkpoint.com/supportcenter/portal?eventSubmit_doGoviewsolutiondetails=&solutionid=sk126613" target="_blank">sk126613</a></p>
<p><h3>Değiştirilen</h3></p>
<p>"sed -i 's/KexAlgorithms +diffie-hellman-group1-sha1/#KexAlgorithms +diffie-hellman-group1-sha1/' /etc/ssh/templates/sshd_config.templ" komutu "sed -i 's/KexAlgorithms +diffie-hellman-group1-sha1/KexAlgorithms +diffie-hellman-group14-sha1/' /etc/ssh/templates/sshd_config.templ" ile değiştirildi.</p>

<p><h2>Sürüm V1.1 - 27 Eylül 2022</h2></p>
<p><h3>Eklenen</h3></p>
<p>Versiyon kontrol özellliği eklendi. Eğer versiyon R81.10 değilse script içindeki elemanlar görev yapmayacaktır.</p>
<p><h3>Çıkarılan</h3></p>
<p>N/A</p>
<p><h3>Değiştirilen</h3></p>
<p>N/A</p>

<p><h2>Sürüm V1.0 - 26 Eylül 2022</h2></p>
<p>Script'in ilk hali. Kodların çalıştığı test ortamında görüldü. Başka ortamlarda test edilmedi.</p>
<p><h3>Eklenen</h3></p>
<p>N/A</p>
<p><h3>Çıkarılan</h3></p>
<p>N/A</p>
<p><h3>Değiştirilen</h3></p>
<p>N/A</p>
</body>
