function matriuDades = carregaMatriu(file)

fitxer = fopen(file,'r');
i = 1;


tline = fgets(fitxer);
while ischar(tline)
    m(i,:) = strsplit(tline,char(9));
    i = i+1;
    tline = fgets(fitxer);
    
end

fclose(fitxer);
[f,c] = size(m);
m = m(2:f,1:160);

matriuDades = cellfun(@str2num,m);

end