% Hafta 1 — MATLAB'ın Dili. Veri: Forenly G1 kıraathane çay servisi benzetim kaydı (veri/cay_servisi_kaydi.csv).
V = fullfile(lab_kok,'veri'); evalin('base', sprintf('cd(''%s'')', V)); format short g;
%% 1.1 Komut penceresi ve değişkenler
komut('1.1','ilk-hesap', {'m = 0.2', 'g = 9.81', 'agirlik = m * g', 'kol = 0.30;', 'tork = agirlik * kol', 'whos m g agirlik kol tork'});
olc('d1_1_agirlik', 0.2*9.81); olc('d1_1_tork', 0.2*9.81*0.30);
komut('1.1','sayilar', {'format long', 'pi', 'format short', 'pi', '0.1 + 0.2 == 0.3', 'abs((0.1 + 0.2) - 0.3) < 1e-12'});
%% 1.2 Vektör, matris ve denklem sistemi
komut('1.2','vektor', {'v = [3 4 12]', 'norm(v)', 'v .* v', 'v * v''', 'M = magic(3)', 'M(2, :)'});
komut('1.2','denklem', {'A = [1 1 1; 2 -1 0; 0 1 -2]', 'b = [10; 0; -4]', 'x = A \ b', 'A * x - b'});
A = [1 1 1; 2 -1 0; 0 1 -2]; b = [10; 0; -4]; x = A\b; olc('d1_2_x', x'); olc('d1_2_norm', norm([3 4 12]));
%% 1.3 Mantıksal indeksleme: bardak ne zaman yüksekte?
komut('1.3','mantiksal', {'K = readmatrix("cay_servisi_kaydi.csv");', 'size(K)', 't = K(:, 1);  z = K(:, 9);', 'yuksek = z > 0.9;', 'class(yuksek)', 'sure_yuksek = sum(yuksek) * 0.02', 'ilk = find(yuksek, 1)', 't(ilk)', 'max(z(t > 95))'});
K = readmatrix(fullfile(V,'cay_servisi_kaydi.csv')); t = K(:,1); z = K(:,9); yk = z > 0.9; i1 = find(yk,1);
olc('d1_3_boyut', size(K)); olc('d1_3_sure_yuksek', sum(yk)*0.02); olc('d1_3_ilk_t', t(i1)); olc('d1_3_son_z', max(z(t>95)));
fig = yeni_sekil; plot(t, z, 'Color', [0.6 0.6 0.6]); hold on; plot(t(yk), z(yk), '.', 'Color', [0.76 0.25 0.05], 'MarkerSize', 8);
yline(0.9, '--', 'eşik 0,9 m', 'FontSize', 14); grid on; xlabel('zaman [s]'); ylabel('bardak yüksekliği z [m]');
legend('benzetim kaydı', 'z > 0,9 m', 'Location', 'southwest'); title(sprintf('Bardak %.1f s boyunca 0,9 m''nin üstünde', sum(yk)*0.02)); sekil(fig,'1.3','yuksek-anlar');
%% 1.4 Fonksiyon dosyası: yolun uzunluğu
komut('1.4','fonksiyon', {'type yol_uzunlugu', '[L, d] = yol_uzunlugu(K(:, 7), K(:, 8));', 'L', 'numel(d)', 'max(d)', 'L_yumusak = yol_uzunlugu(movmean(K(:, 7), 25), movmean(K(:, 8), 25))'});
[L, d] = yol_uzunlugu(K(:,7), K(:,8)); Ly = yol_uzunlugu(movmean(K(:,7),25), movmean(K(:,8),25));
olc('d1_4_L', L); olc('d1_4_L_yumusak', Ly); olc('d1_4_dmax', max(d)); olc('d1_4_duz', hypot(K(end,7)-K(1,7), K(end,8)-K(1,8)));
fig = yeni_sekil; plot(K(:,7), K(:,8), 'Color', [0.7 0.7 0.7]); hold on; plot(movmean(K(:,7),25), movmean(K(:,8),25), 'Color', [0.11 0.31 0.85]);
plot(K(1,7), K(1,8), 's', 'MarkerSize', 12, 'MarkerFaceColor', [0.06 0.46 0.43]); plot(K(end,7), K(end,8), 'p', 'MarkerSize', 16, 'MarkerFaceColor', [0.76 0.25 0.05]);
axis equal; grid on; xlabel('x [m]'); ylabel('y [m]'); legend(sprintf('ham: %.2f m', L), sprintf('yumuşatılmış: %.2f m', Ly), 'başlangıç', 'servis masası', 'Location', 'southeast');
title('Bardağın yatay yolu — yol\_uzunlugu fonksiyonuyla'); sekil(fig,'1.4','yol');
disp('HAFTA1 TAMAM');
