function [data,nom,fi,si,cabecera] = readData(file)


fid = fopen(file,'r');

%Lectura datos de consulta
aux_string = fgets(fid);
linea1 = strsplit(aux_string,char(9));
nom = fgets(fid);
cabecera = fgets(fid);

fi = str2num(linea1{2});
si = str2num(linea1{3})+fi;

%Lectura de dades
i=1;
linea = fgets(fid);
while ischar(linea)
   linea = strrep(linea,',','.');
   m(i,:) = strsplit(linea,char(9)); 
   i = i+1;
   linea = fgets(fid);
    
end

fclose(fid);
%Tamany del cellString
[f,c] = size(m);

%Convertim el cellString en una matriu de nombres
data = cellfun(@str2num,m); 

end