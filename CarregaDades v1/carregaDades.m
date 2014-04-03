function [datos,T,datos2,fi,si,ti] = carregaDades(file)

format long

fid = fopen(file,'r');
aux_string = fgets(fid);
linea1 = strsplit(aux_string,char(9));
fi = str2num(linea1{2});
si = str2num(linea1{3})+fi;
ti =  str2num(linea1{4});

if ti >100
    ti = 210;
else
    ti = ti+si;
end

fclose(fid);

fi=(fi*100)-400;
si=(si*100)-400;
ti=(ti*100)-400;


% Preparem les dades del fitxer
% file = 'Z:\LV\grupo 1\28-11-2013_Clementina_10mL_1.txt';
newfile = strrep(file,'.txt','_punto.txt');

if exist(newfile,'file')==0
copyfile(file,newfile);
comma2point_overwrite(newfile);
eliminaLineas(newfile);
end

data = tdfread(newfile);
%Base temporal
T = data.Time;

data = rmfield(data,'Time'); %eliminem vector temps
datos = struct2dataset(data); %carreguem la resta de dades en una matriu
datos = double(datos); 
[f,c] = size(datos); %nombre de dades per vector
datos = datos(100:f,:); %eliminem les 100 primeres mostres (realment el que fem es carregar desde 100 fins al final)
f=f-100;


T=T(300:f); 
A = [1 -1.95557824031504 0.956543676511203];
B = [0.000241359049041961 0.000482718098083923 0.000241359049041961];
for i= 1:c
   
    datos3=filter(B,A,datos(:,i));
    datos2(:,i)=datos3(300:f);
    
end

datos = datos2;
clear datos2;

[f,c] = size(datos);


for i=1:c
    
    min1 =  min(datos(fi:si,i));
    max1 = max(datos(fi:si,i));
    max2 = max(datos(si:ti,i));
    min2 = min(datos(si:ti,i));
    dif = max1 - min1;
    dif2 = max2 - min2;
    
    
    maxim = dif*0.85 + min1;
    maxim2 = dif*0.98 + min1;
    maxim3 = dif2*0.85 + min2;
    minim = dif*0.05 + min1;
    minim2 = dif2*0.05 + min2;
    
    
    
    for j=1:si
        
        if (datos(j,i)) >= maxim2 
            
            datos2(j,i) = maxim2;
            
        elseif (datos(j,i)) > maxim
            
            datos2(j,i) = maxim;
            
        elseif (datos(j,i)) < minim 
            
            datos2(j,i) = minim;
            
        else
            
            datos2(j,i) = datos(j,i);
            
        end
    end
    
    for j=si:f
        
        if (datos(j,i)) < minim2 
            
            datos2(j,i) = minim2;
            
        elseif (datos(j,i)) > maxim3
            
            datos2(j,i) = maxim3;
            
        else
            
            datos2(j,i) = datos(j,i);
            
        end
    end
    
    
end





end