% Hafta 2 — Veriyle Çalışmak. Veri: Forenly G1 kıraathane çay servisi benzetim kaydı.
V = fullfile(lab_kok,'veri'); evalin('base', sprintf('cd(''%s'')', V)); format short g;
%% 2.1 readtable: kaydı tablo olarak okumak
komut('2.1','tablo', {'T = readtable("cay_servisi_kaydi.csv");', 'size(T)', 'T.Properties.VariableNames''', 'head(T(:, ["zaman_s" "dirsek_rad" "bardak_z_m"]), 3)', 'T.dirsek_derece = rad2deg(T.dirsek_rad);', 'mean(T.bardak_z_m)', '[en_dusuk, en_yuksek] = bounds(T.dirsek_derece)'});
T = readtable(fullfile(V,'cay_servisi_kaydi.csv')); T.dirsek_derece = rad2deg(T.dirsek_rad);
[a1, a2] = bounds(T.dirsek_derece); olc('d2_1_boyut', size(T)); olc('d2_1_z_ort', mean(T.bardak_z_m)); olc('d2_1_dirsek_aralik', [a1 a2]);
fig = yeni_sekil; yyaxis left; plot(T.zaman_s, T.dirsek_derece); ylabel('dirsek [°]'); yyaxis right; plot(T.zaman_s, T.bardak_z_m); ylabel('bardak z [m]');
grid on; xlabel('zaman [s]'); title('Tek tablo, iki sütun: dirsek açısı ve bardak yüksekliği'); sekil(fig,'2.1','iki-sutun');
%% 2.2 Eksik ve aykırı değer (ÖRNEK bozuk kopya)
komut('2.2','temizlik', {'Tb = bozuk_kopya(T);', 'sum(isnan(Tb.bardak_z_m))', 'Td = fillmissing(Tb, "linear", "DataVariables", "bardak_z_m");', 'ay = isoutlier(Td.bardak_z_m, "movmedian", 25);', 'sum(ay)', 'Td.bardak_z_m(ay) = NaN;', 'Td = fillmissing(Td, "linear", "DataVariables", "bardak_z_m");', 'en_buyuk_fark = max(abs(Td.bardak_z_m - T.bardak_z_m))'});
Tb = bozuk_kopya(T); Td = fillmissing(Tb,'linear','DataVariables','bardak_z_m'); ay = isoutlier(Td.bardak_z_m,'movmedian',25);
Td.bardak_z_m(ay) = NaN; Td = fillmissing(Td,'linear','DataVariables','bardak_z_m');
olc('d2_2_nan', sum(isnan(Tb.bardak_z_m))); olc('d2_2_aykiri', sum(ay)); olc('d2_2_fark', max(abs(Td.bardak_z_m - T.bardak_z_m)));
fig = yeni_sekil; tiledlayout(2,1); nexttile; plot(Tb.zaman_s, Tb.bardak_z_m, 'Color', [0.76 0.25 0.05]); grid on; ylabel('z [m]'); title('ÖRNEK bozuk kopya: 20 eksik + 20 aykırı');
nexttile; plot(Td.zaman_s, Td.bardak_z_m, 'Color', [0.06 0.46 0.43]); grid on; ylabel('z [m]'); xlabel('zaman [s]'); title(sprintf('Temizlendi: kayıttan en büyük fark %.4f m', max(abs(Td.bardak_z_m - T.bardak_z_m))));
sekil(fig,'2.2','temizlik-grafik');
%% 2.3 timetable ve yeniden örnekleme
komut('2.3','zaman-tablosu', {'TT = table2timetable(T, "RowTimes", seconds(T.zaman_s));', 'TT10 = retime(TT, "regular", "mean", "TimeStep", seconds(0.1));', '[height(TT) height(TT10)]', 'TT10(1:3, ["dirsek_rad" "bardak_z_m"])', 'parca = TT(timerange(seconds(85), seconds(100)), :);', 'height(parca)', 'max(parca.bardak_z_m) - min(parca.bardak_z_m)'});
TT = table2timetable(T,'RowTimes',seconds(T.zaman_s)); TT10 = retime(TT,'regular','mean','TimeStep',seconds(0.1)); pr = TT(timerange(seconds(85),seconds(100)),:);
olc('d2_3_satir', [height(TT) height(TT10)]); olc('d2_3_parca', height(pr)); olc('d2_3_inis', max(pr.bardak_z_m) - min(pr.bardak_z_m));
fig = yeni_sekil; plot(seconds(TT.Time), TT.bardak_z_m, '.', 'MarkerSize', 5, 'Color', [0.7 0.7 0.7]); hold on; plot(seconds(TT10.Time), TT10.bardak_z_m, 'o-', 'MarkerSize', 4, 'Color', [0.49 0.13 0.81]);
xlim([85 100]); grid on; xlabel('zaman [s]'); ylabel('bardak z [m]'); legend('kayıt: saniyede 50', 'retime: saniyede 10 (ortalama)'); title('85–100 s: bardak masaya iniyor'); sekil(fig,'2.3','yeniden-ornekleme');
%% 2.4 Evrelere göre özet: groupsummary
komut('2.4','gruplama', {'hiz = hypot(gradient(movmean(T.bardak_x_m, 25)), gradient(movmean(T.bardak_y_m, 25))) / 0.02;', 'evre = repmat("taşınıyor", height(T), 1);', 'evre(T.zaman_s < 30) = "bekliyor";', 'evre(T.zaman_s > 93) = "masada";', 'T.evre = categorical(evre);  T.hiz = hiz;', 'G = groupsummary(T, "evre", ["mean" "max"], "hiz")', 'G.GroupCount * 0.02'});
hiz = hypot(gradient(movmean(T.bardak_x_m,25)), gradient(movmean(T.bardak_y_m,25)))/0.02; ev = repmat("taşınıyor",height(T),1); ev(T.zaman_s<30) = "bekliyor"; ev(T.zaman_s>93) = "masada";
T.evre = categorical(ev); T.hiz = hiz; G = groupsummary(T,'evre',{'mean','max'},'hiz');
olc('d2_4_evre', cellstr(string(G.evre))'); olc('d2_4_sure', (G.GroupCount*0.02)'); olc('d2_4_ort', G.mean_hiz'); olc('d2_4_max', G.max_hiz');
fig = yeni_sekil; bar(categorical(string(G.evre)), G.GroupCount*0.02, 'FaceColor', [0.11 0.31 0.85]); grid on; ylabel('süre [s]');
for i = 1:height(G), text(i, G.GroupCount(i)*0.02 + 2, sprintf('ort. %.3f m/s', G.mean_hiz(i)), 'HorizontalAlignment', 'center', 'FontSize', 14); end
title('Evrelere göre süre ve ortalama hız (groupsummary)'); sekil(fig,'2.4','evreler');
disp('HAFTA2 TAMAM');
