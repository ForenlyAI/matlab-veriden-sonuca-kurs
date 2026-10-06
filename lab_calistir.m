% MATLAB'la Veriden Sonuca — tüm laboratuvarı koşar; günlük cikti/kosum.log, bitince cikti/BITTI.txt
k = lab_kok; addpath(k); cd(k);
if ~exist(fullfile(k,'cikti'),'dir'), mkdir(fullfile(k,'cikti')); end
if exist(fullfile(k,'cikti','BITTI.txt'),'file'), delete(fullfile(k,'cikti','BITTI.txt')); end
diary(fullfile(k,'cikti','kosum.log')); diary on;
fprintf('%s\n%s\n', version, datestr(now));
for h = 1:4
    try
        run(fullfile(k, sprintf('hafta%d.m', h)));
    catch e
        fprintf(2, 'HAFTA%d HATA: %s\n', h, getReport(e, 'extended', 'hyperlinks', 'off'));
    end
    k = lab_kok; cd(k); close all force;
end
diary off;
f = fopen(fullfile(k,'cikti','BITTI.txt'),'w'); fprintf(f,'bitti %s\n', datestr(now)); fclose(f);
