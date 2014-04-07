function [datos, datos2, T, fi, si, ti = carregaDades(file, par)

format long;

% Si els fitxers porten els parametres amb intervals els llegim
if par 
    
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

% Si els fitxers no porten els parametres amb intervals els llegim els
% suposem.

else 
    
    fi = 1100;
    si = 12600;
    ti = 20601;
       
end

%Fitxer auxiliar per guardar la cache (dades amb punt decimal i sense
%parametres extra.

newfile = strrep(file,'.txt','_punto.txt');


% Si el fitxer de cache ja existeix no es necesari tornar a generarlo

if exist(newfile,'file')==0

    copyfile(file,newfile);
    comma2point_overwrite(newfile);
    
    % Si existeixen parametres es necesari eliminarlos per a la lectura
    % posterior
    
    if par
        eliminaLineas(newfile);
    end
    
end

% Llegim els parametres i els almacenem en un struct array mitjançant la
% funció tdfread.

data = tdfread(newfile);

% Base temporal

T = data.Time;


% Eliminem vector temps
data = rmfield(data,'Time'); 

% Carreguem la resta de dades en una matriu
datos = struct2dataset(data);

% Convertim a tipus double (64 bits)
datos = double(datos);

% Nombre de dades per vector
[f,c] = size(datos); 

% Eliminem les 100 primeres mostres que no aporten informació degut a un
% filtre ir al final del sistema d'adquisició de dades.
datos = datos(100:f,:);
f=f-100;

% ***********************************************************
% FILTRE IIR PAS BAIX. BUTTERWORTH  ORDRE 2 F = 0.01 Hz;
% ***********************************************************

% Definim els coeficients previament calculats mitjançant la funció butter
% de matlab
A = [1 -1.95557824031504 0.956543676511203];
B = [0.000241359049041961 0.000482718098083923 0.000241359049041961];

% Apliquem el filtre a totes les senyals carregades anteriorment
for i= 1:c
   
    % La funció filter aplica el fitre definit per els coeficients en A i B
    datos3=filter(B,A,datos(:,i));
    
    % Eliminem les 300 primeres mostres degut a que el filtre IIR inserta
    % un periode de estabilització d'unes 200 mostres. Com fins al segon 15
    % aproximadament no es tenen en compte les dades es poden agafar 100
    % mostres mes de marge.
    
    datos2(:,i)=datos3(300:f);
    
end

% Guardem les dades filtrades a la variable adequada.
datos = datos2;
clear datos2;

% Eliminem 400 mostres de la base temporal per igualar el tamany amb les
% dades. La Base temporal començara un poc abans del segon 4.
T=T(400:end); 


% ****************************************************************
% UMBRALITZACIÓ DE LES DADES EN FUNCIÓ DELS INTERVALS FI, SI , TI
% MAXIMS AL 85% I MINIMS AL 5%
% ****************************************************************

% Llimits de tamany de les dades
[f,c] = size(datos);

for i=1:c
    
    % Fixem els maxims i minims en funció de l'amplitud de les gràfiques.
    
   
    % Llimits absoluts
    max1 = max(datos(fi:si,i));
    min1 = min(datos(fi:si,i));
    max2 = max(datos(si:ti,i));
    
    
    % Adjust necesari per a fixar els llimis relatius dacord amb
    % l'oscilació entre minim i maxims absoluts.
    
    dif1 = max1-min1;
    dif2 = max2-min1;
    
    % Llimits relatius
    minim1 = 0.20*dif1 + min1;
    minim2 = 0.02*dif1 + min1;
    maxim1 = 0.95*dif1 + min1;
    maxim2 = 0.85*dif2 + min1; 
   
    
    % Umbralitzem en funcio del interval
    
    % Interval [1:si]
    for j=1:si
        
        if datos(j,i) < minim2
            
            datos2(j,i) = minim2;
            
        elseif datos(j,i) < minim1
            
            datos2(j,i) = minim1;
            
       
        elseif datos(j,i) > maxim1
            
            datos2(j,i) = maxim1;
       
        else
            
            datos2(j,i) = datos(j,i);
            
        end
        
    end
    
    % Interval [si:ti]
    
    for j=si:ti
        
         if datos(j,i) > maxim2
            
            datos2(j,i) = maxim2;
            
         elseif datos(j,i) < minim2
            
            datos2(j,i) = minim2;
            
          else
            
            datos2(j,i) = datos(j,i);        
        
        end
        
        
    end
    
    
    
    
  
    
    
    
    
end

end






















