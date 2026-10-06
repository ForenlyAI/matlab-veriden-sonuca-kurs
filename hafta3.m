% Hafta 3 — Grafik ve Sinyal. Veri: Forenly G1 kıraathane çay servisi benzetim kaydı.
V = fullfile(lab_kok,'veri'); evalin('base', sprintf('cd(''%s'')', V)); format short g;
evalin('base', 'T = readtable("cay_servisi_kaydi.csv");');
T = readtable(fullfile(V,'cay_servisi_kaydi.csv')); t = T.zaman_s;
%% 3.1 Grafik çizmek, biçimlendirmek, kaydetmek
komut('3.1','grafik-kodu', {'f = figure("Visible", "off");', 'tiledlayout(3, 1, "TileSpacing", "compact");', 'nexttile; plot(T.zaman_s, T.bardak_x_m); ylabel("x [m]"); grid on', 'nexttile; plot(T.zaman_s, T.bardak_y_m); ylabel("y [m]"); grid on', 'nexttile; plot(T.zaman_s, T.bardak_z_m); ylabel("z [m]"); grid on; xlabel("zaman [s]")', 'exportgraphics(f, "bardak_konum.png", "Resolution", 150);', 'dir("bardak_konum.png").bytes > 0'});
fig = yeni_sekil; tiledlayout(3,1,'TileSpacing','compact'); renk = {[0.76 0.25 0.05], [0.11 0.31 0.85], [0.06 0.46 0.43]}; ad = {'x [m]','y [m]','z [m]'}; s = {'bardak_x_m','bardak_y_m','bardak_z_m'};
for i = 1:3, nexttile; plot(t, T.(s{i}), 'Color', renk{i}); ylabel(ad{i}); grid on; end; xlabel('zaman [s]'); sekil(fig,'3.1','uc-eksen');
%% 3.2 Sayısal türev ve integral
komut('3.2','turev-integral', {'dt = 0.02;', 'vx = gradient(movmean(T.bardak_x_m, 25), dt);', 'vy = gradient(movmean(T.bardak_y_m, 25), dt);', 'hiz = hypot(vx, vy);', '[en_hizli, i] = max(hiz)', 'T.zaman_s(i)', 'yol = trapz(T.zaman_s, hiz)', 'kum = cumtrapz(T.zaman_s, hiz);', 'kum(T.zaman_s == 60)'});
dt = 0.02; vx = gradient(movmean(T.bardak_x_m,25),dt); vy = gradient(movmean(T.bardak_y_m,25),dt); hz = hypot(vx,vy); [hm, ih] = max(hz); yl = trapz(t,hz); kum = cumtrapz(t,hz);
olc('d3_2_hiz_max', hm); olc('d3_2_hiz_t', t(ih)); olc('d3_2_yol', yl); olc('d3_2_kum60', kum(t==60));
fig = yeni_sekil; yyaxis left; plot(t, hz); ylabel('yatay hız [m/s]'); yyaxis right; plot(t, kum); ylabel('alınan yol [m]'); grid on; xlabel('zaman [s]');
title(sprintf('Türev: en büyük hız %.2f m/s · integral: toplam yol %.2f m', hm, yl)); sekil(fig,'3.2','hiz-yol');
%% 3.3 Filtreleme ve gecikme
komut('3.3','filtre', {'z = T.bardak_z_m;', 'z_ort = movmean(z, 25);', 'b = ones(1, 25) / 25;', 'z_filt = filter(b, 1, z);', 'kay = 0:30;', 'fark = arrayfun(@(s) norm(z_filt(31+s:end) - z_ort(31:end-s)), kay);', '[~, i] = min(fark);', 'gecikme_ornek = kay(i)', 'gecikme_s = gecikme_ornek * 0.02'});
z = T.bardak_z_m; zo = movmean(z,25); zf = filter(ones(1,25)/25,1,z); kay = 0:30; fk = arrayfun(@(s) norm(zf(31+s:end) - zo(31:end-s)), kay); [~, ig] = min(fk); go = kay(ig);
olc('d3_3_gecikme_ornek', go); olc('d3_3_gecikme_s', go*0.02);
fig = yeni_sekil; plot(t, z, 'Color', [0.75 0.75 0.75]); hold on; plot(t, zo, 'Color', [0.06 0.46 0.43]); plot(t, zf, '--', 'Color', [0.76 0.25 0.05]);
xlim([86 96]); grid on; xlabel('zaman [s]'); ylabel('bardak z [m]'); legend('kayıt', 'movmean (ortalanmış, gecikmesiz)', sprintf('filter (geriye bakan, %.2f s gecikme)', go*0.02), 'Location', 'northeast');
title('Aynı 25 örneklik ortalama, iki farklı sonuç'); sekil(fig,'3.3','filtre-gecikme');
%% 3.4 FFT: taşırken omzun salınım frekansı (adım ritmi)
komut('3.4','fft', {'p = T.omuz_pitch_rad(T.zaman_s > 36 & T.zaman_s < 81);', 'p = rad2deg(detrend(p));', 'N = numel(p)', 'Y = abs(fft(p)) / N;', 'f = (0:N-1)'' / (N * 0.02);', 'aralik = find(f > 0.5 & f < 5);', '[~, k] = max(Y(aralik));', 'f_baskin = f(aralik(k))', 'periyot = 1 / f_baskin'});
p = rad2deg(detrend(T.omuz_pitch_rad(t>36 & t<81))); N = numel(p); Y = abs(fft(p))/N; f = (0:N-1)'/(N*0.02); ar = find(f > 0.5 & f < 5); [~, k] = max(Y(ar)); fb = f(ar(k));
y0 = find(f > 0.5 & f < 5 & f ~= fb); olc('d3_4_N', N); olc('d3_4_f', fb); olc('d3_4_periyot', 1/fb); olc('d3_4_genlik', 2*Y(ar(k)));
yr = 2:floor(N/2); dus = find(f(yr) <= 0.5);
fig = yeni_sekil; plot(f(yr), 2*Y(yr), 'Color', [0.49 0.13 0.81]); hold on; xline(0.5, ':', 'yavaş duruş değişimi | aranan bölge', 'FontSize', 13); plot(fb, 2*Y(ar(k)), 'o', 'MarkerSize', 12, 'LineWidth', 2, 'Color', [0.76 0.25 0.05]);
xlim([0 5]); grid on; xlabel('frekans [Hz]'); ylabel('genlik [°]'); title(sprintf('Taşırken (36–81 s) omuz salınımı: baskın frekans %.2f Hz', fb)); sekil(fig,'3.4','spektrum');
disp('HAFTA3 TAMAM');
