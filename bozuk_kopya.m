function Tb = bozuk_kopya(T)
% BOZUK_KOPYA  Ders 2.2 için ÖRNEK bozuk veri: bardak_z_m sütununa 20 eksik değer (NaN) ve 20 aykırı sıçrama (+0,5 m) ekler.
%   Gerçek kayıtta eksik ya da aykırı değer yoktur; bu kopya temizleme alıştırması içindir. rng(1) ile her seferinde aynı.
rng(1);
Tb = T;
i = randperm(height(T), 40);
Tb.bardak_z_m(i(1:20)) = NaN;
Tb.bardak_z_m(i(21:40)) = Tb.bardak_z_m(i(21:40)) + 0.5;
end
