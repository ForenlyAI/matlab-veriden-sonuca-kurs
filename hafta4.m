% Hafta 4 — Model ve Rapor. Veri: Forenly G1 kıraathane çay servisi benzetim kaydı + eklem kartı (veri/g1_sag_kol_parametre.csv).
V = fullfile(lab_kok,'veri'); evalin('base', sprintf('cd(''%s'')', V)); format short g;
evalin('base', 'T = readtable("cay_servisi_kaydi.csv");');
T = readtable(fullfile(V,'cay_servisi_kaydi.csv')); t = T.zaman_s;
%% 4.1 En küçük kareler: yerçekimi katsayılarını veriden bulmak (ÖRNEK gürültü)
komut('4.1','en-kucuk-kareler', {'rng(2);  q = T.dirsek_rad;', 'G = -2.998 * cos(q) + 0.145 * sin(q) + 0.05 * randn(size(q));', 'A = [cos(q) sin(q)];', 'c = A \ G', 'artik = norm(G - A * c) / sqrt(numel(q))', 'p = polyfit(q, G, 2)', 'artik_poli = norm(G - polyval(p, q)) / sqrt(numel(q))'});
rng(2); q = T.dirsek_rad; G = -2.998*cos(q) + 0.145*sin(q) + 0.05*randn(size(q)); A = [cos(q) sin(q)]; c = A\G; pp = polyfit(q,G,2);
olc('d4_1_c', c'); olc('d4_1_artik', norm(G - A*c)/sqrt(numel(q))); olc('d4_1_poli', pp); olc('d4_1_artik_poli', norm(G - polyval(pp,q))/sqrt(numel(q)));
qq = linspace(min(q), max(q), 200)';
fig = yeni_sekil; plot(rad2deg(q), G, '.', 'Color', [0.75 0.75 0.75], 'MarkerSize', 5); hold on; plot(rad2deg(qq), [cos(qq) sin(qq)]*c, 'Color', [0.06 0.46 0.43], 'LineWidth', 3);
plot(rad2deg(qq), polyval(pp, qq), '--', 'Color', [0.76 0.25 0.05]); grid on; xlabel('dirsek açısı [°]'); ylabel('yerçekimi torku [N·m]');
legend('ÖRNEK ölçüm (kart + gürültü)', sprintf('cos/sin modeli: %.3f, %.3f', c(1), c(2)), 'ikinci derece polinom', 'Location', 'south'); title('Aynı veri, iki model'); sekil(fig,'4.1','iki-model');
%% 4.2 ode45: yay–kütle–sönüm (ÖRNEK)
komut('4.2','ode45', {'m = 2;  k = 200;  c = 4;', 'f = @(t, x) [x(2); -(c * x(2) + k * x(1)) / m];', 'secenek = odeset("RelTol", 1e-8, "AbsTol", 1e-10);', '[ts, xs] = ode45(f, 0:0.001:3, [0.05; 0], secenek);', 'tepe = islocalmax(xs(:, 1));', 'T_olcum = mean(diff(ts(tepe)))', 'T_formul = 2 * pi / (sqrt(k / m) * sqrt(1 - (c / (2 * sqrt(k * m)))^2))'});
m = 2; k = 200; cc = 4; f = @(t,x) [x(2); -(cc*x(2) + k*x(1))/m]; [ts, xs] = ode45(f, 0:0.001:3, [0.05;0], odeset('RelTol',1e-8,'AbsTol',1e-10));
tp = islocalmax(xs(:,1)); To = mean(diff(ts(tp))); Tf = 2*pi/(sqrt(k/m)*sqrt(1-(cc/(2*sqrt(k*m)))^2)); olc('d4_2_T_olcum', To); olc('d4_2_T_formul', Tf);
fig = yeni_sekil; plot(ts, 1000*xs(:,1), 'Color', [0.49 0.13 0.81]); hold on; plot(ts(tp), 1000*xs(tp,1), 'v', 'MarkerFaceColor', [0.76 0.25 0.05], 'MarkerSize', 8);
grid on; xlabel('zaman [s]'); ylabel('konum [mm]'); legend('ode45', 'islocalmax: tepeler'); title(sprintf('Yay–kütle–sönüm (ÖRNEK): ölçülen periyot %.4f s, formül %.4f s', To, Tf)); sekil(fig,'4.2','titresim');
%% 4.3 fzero ve fminsearch
komut('4.3','kok-ve-en-iyi', {'h = 0.76;', 't_dus = fzero(@(t) h - 9.81 * t.^2 / 2, [0 1])', 'rng(3);  tt = (0:0.01:2)'';', 'olcum = 0.05 * exp(-1.2 * tt) .* cos(9 * tt) + 0.002 * randn(size(tt));', 'model = @(p, t) 0.05 * exp(-p(1) * t) .* cos(p(2) * t);', 'hata = @(p) sum((model(p, tt) - olcum).^2);', 'p = fminsearch(hata, [0.5 8])'});
td = fzero(@(t) 0.76 - 9.81*t.^2/2, [0 1]); rng(3); tt = (0:0.01:2)'; ol = 0.05*exp(-1.2*tt).*cos(9*tt) + 0.002*randn(size(tt)); mdl = @(p,t) 0.05*exp(-p(1)*t).*cos(p(2)*t);
pb = fminsearch(@(p) sum((mdl(p,tt) - ol).^2), [0.5 8]); olc('d4_3_t_dus', td); olc('d4_3_p', pb);
fig = yeni_sekil; plot(tt, 1000*ol, '.', 'Color', [0.7 0.7 0.7], 'MarkerSize', 8); hold on; plot(tt, 1000*mdl([0.5 8], tt), ':', 'Color', [0.4 0.4 0.4]); plot(tt, 1000*mdl(pb, tt), 'Color', [0.06 0.46 0.43], 'LineWidth', 3);
grid on; xlabel('zaman [s]'); ylabel('konum [mm]'); legend('ÖRNEK ölçüm', 'başlangıç tahmini [0,5 8]', sprintf('fminsearch: [%.3f %.3f]', pb(1), pb(2))); title('fminsearch: modeli ölçüme oturtmak'); sekil(fig,'4.3','fminsearch');
%% 4.4 Bitirme: veriden rapora
komut('4.4','rapor', {'R = bardak_ozeti(T)', 'writetable(R, fullfile(lab_kok, "cikti", "bardak_ozeti.csv"));', 'all(R.sonuc == "GEÇTİ")'});
R = bardak_ozeti(T); if ~exist(fullfile(lab_kok,'cikti'),'dir'), mkdir(fullfile(lab_kok,'cikti')); end; writetable(R, fullfile(lab_kok,'cikti','bardak_ozeti.csv'));
olc('d4_4_olcu', cellstr(R.olcu)'); olc('d4_4_deger', R.deger'); olc('d4_4_olcut', R.olcut'); olc('d4_4_sonuc', cellstr(R.sonuc)');
fig = yeni_sekil; oran = R.deger ./ R.olcut; b = barh(categorical(R.olcu, R.olcu), oran, 'FaceColor', [0.06 0.46 0.43]); hold on; xline(1, '--k', 'ölçüt', 'FontSize', 14);
for i = 1:height(R), text(oran(i) + 0.03, i, sprintf('%.3g / %.3g  %s', R.deger(i), R.olcut(i), R.sonuc(i)), 'FontSize', 13); end
xlim([0 1.6]); grid on; xlabel('değer / ölçüt'); title('Bitirme: bardak_ozeti — ölçütler ÖRNEK', 'Interpreter', 'none'); sekil(fig,'4.4','ozet');
disp('HAFTA4 TAMAM');
