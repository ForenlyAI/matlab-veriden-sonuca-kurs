function R = bardak_ozeti(T)
% BARDAK_OZETI  Çay servisi kaydından dört ölçüyü hesaplar ve ölçütle karşılaştırır (Ders 4.4 bitirme).
%   R = bardak_ozeti(T)   T: readtable("cay_servisi_kaydi.csv")   R: olcu · deger · olcut · sonuc
%   Ölçütler ÖRNEK değerlerdir; kendi ölçütlerinizi gerekçesiyle seçin.
t = T.zaman_s; dt = 0.02;
x = movmean(T.bardak_x_m, 25); y = movmean(T.bardak_y_m, 25); z = movmean(T.bardak_z_m, 25);
hiz = hypot(gradient(x, dt), gradient(y, dt));
yol = trapz(t, hiz);
sapma = T.bardak_z_m - movmean(T.bardak_z_m, 100);
sallanma = std(sapma(t > 36 & t < 81)) * 1000;
inis = abs(gradient(z, dt)); konma = max(inis(t > 85));
olcu  = ["en büyük hız [m/s]"; "toplam yol [m]"; "düşey sallanma, std [mm]"; "en büyük iniş hızı [m/s]"];
deger = [max(hiz); yol; sallanma; konma];
olcut = [1.0; 10; 20; 0.3];
sonuc = repmat("KALDI", 4, 1); sonuc(deger < olcut) = "GEÇTİ";
R = table(olcu, round(deger, 3), olcut, sonuc, 'VariableNames', ["olcu" "deger" "olcut" "sonuc"]);
end
