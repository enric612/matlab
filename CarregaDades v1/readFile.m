function datos = readFile(file)
%#codegen
coder.inline('never')

m = zeros(21000,33);
fid = fopen(file);
%Lectura de dades
i=1;
linea = fgets(fid);
while ischar(linea)
   linea = strrep(linea,',','.');
   m(i,:) = strsplit(linea,char(9)); 
   i = i+1;
   linea = fgets(fid);
    
end

datos = m;

fclose(fid);
end