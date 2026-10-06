function [L, d] = yol_uzunlugu(x, y)
% YOL_UZUNLUGU  Ardışık noktalar arasındaki uzaklıkların toplamı.
%   [L, d] = yol_uzunlugu(x, y)   L: toplam yol [m], d: her adımın uzunluğu [m]
d = hypot(diff(x), diff(y));
L = sum(d);
end
