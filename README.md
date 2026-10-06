# MATLAB'la Veriden Sonuca — kurs dosyaları

Forenly AI Academy'deki **MATLAB'la Veriden Sonuca** kursunun laboratuvar dosyaları. Derslerde ekranda gördüğünüz her komut ve grafik bu betiklerle üretildi.

## Gerekenler

- **MATLAB R2026b** (daha eski sürümlerin çoğu da çalışır). **Ek araç kutusu ve Simulink gerekmez**; yalnız temel MATLAB komutları kullanılır.
- MATLAB ücretli bir yazılımdır. Kendi lisansınızla ya da MathWorks'ün [30 günlük ücretsiz denemesiyle](https://www.mathworks.com/campaigns/products/trials.html) çalışabilirsiniz. Deneme hesabıyla [MATLAB Online](https://matlab.mathworks.com/) da kullanılabilir: bu klasörü yükleyip aynı betikleri çalıştırın.

## Nasıl çalıştırılır

1. Bu depoyu indirin (Code → Download ZIP) ve MATLAB'da klasörü açın.
2. Bir haftayı çalıştırmak için komut penceresine `hafta1` yazın (`hafta2`, `hafta3`, `hafta4`). Her hafta bağımsızdır.
3. Hepsini sırayla çalıştırmak için `lab_calistir` yazın. Bittiğinde `cikti/BITTI.txt` oluşur; günlükte (`cikti/kosum.log`) dört haftanın da `TAMAM` yazması gerekir.

Betikler çalışınca `ekran/<ders>/` klasöründe grafikler (`.png`) ve komut penceresi kayıtları (`.txt`), kökte ölçülen sayılar (`OLCUMLER.json`) oluşur. Ders 4.4 ayrıca `cikti/bardak_ozeti.csv` yazar.

## Sonucunuzu karşılaştırın

`beklenen/OLCUMLER.json` ekibimizin 2026-10-06 koşumunda ölçtüğü sayılardır; `beklenen/ekran/` aynı koşumun grafikleri ve komut kayıtlarıdır. `beklenen/bardak_ozeti.csv` Ders 4.4'teki raporun sonucudur.

## Dosyalar

| Dosya | İçerik |
|---|---|
| `hafta1.m` … `hafta4.m` | Her haftanın dört dersi, sırayla |
| `yol_uzunlugu.m` | Ders 1.4: ardışık noktalar arasındaki yol |
| `bozuk_kopya.m` | Ders 2.2: temizlik alıştırması için ÖRNEK bozuk kopya (20 eksik + 20 aykırı) |
| `bardak_ozeti.m` | Ders 4.4 bitirme: dört ölçü ve ölçüt karşılaştırması |
| `komut.m`, `sekil.m`, `yeni_sekil.m`, `olc.m`, `lab_kok.m`, `lab_calistir.m` | Komut kaydı, grafik kaydetme, ölçüm yazma ve toplu çalıştırma yardımcıları |
| `komut_ciz.py` | Komut kayıtlarını resme çizer (isteğe bağlı, Python 3 + Pillow) |
| `veri/cay_servisi_kaydi.csv` | Çay servisi benzetim kaydı: zaman, omuz ve dirsek açıları, dirseğin açısal hızı, bardağın konumu × 5666 örnek (saniyede 50) |

## Veri hakkında

Robot verisinin tamamı **benzetim kaydıdır**, gerçek robot ölçümü değildir. Kayıt, Forenly AI'nin [kafe projesinde](https://forenly.ai/work/cafe) Unitree G1 insansı robotunun çay servisini benzetimde yaptığı bir bölümden alınmıştır. Kayıttan gelmeyen değerler (bozuk kopya, gürültülü tork ölçümü, yay–kütle–sönüm, sönümlü salınım, ölçütler) betiklerde ve derslerde **ÖRNEK** diye işaretlidir.

Dosyalar yalnız eğitim amacıyla paylaşılmıştır. © Forenly AI
