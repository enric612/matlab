function [datos, datos2, T, fi, si, ti] = carregaDades(file, par)

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
    
    % llimit virtual de 12 segons on se suposa que esta el pic intermig
    % entre la baixada i la pujada final.
    asi = si +1200;
    ti=(ti*100)-400;

% Si els fitxers no porten els parametres amb intervals els llegim els
% suposem.

else 
    
%     fi = 1100;
%     si = 7600;
%     ti = 10500;
%     asi = 8800;

    fi = 1100;
    si = 12600;
    ti = 20600;
    asi = 13800;

    
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
    % En alguns casos el maxim "real" de pujada es troba despres d'un fals
    % màxim inicial degut a l'estabilització de la senyal previa a l'inici
    % del primer interval. Per tal d'evitar-ho incloem un offset de 150
    % mostres ambans de buscar el maxim1.
    
    [max1, pos]= max(datos((fi+150):si,i));
    
    % Adjustem la posició del maxim a l'escala absoluta (li sumem les
    % mostres a partir de quan comencem a buscar el maxim).
    pos = pos + fi+150;
    min1 = min(datos(fi:pos,i));
    min2 = min(datos(si:asi,i));
    max2 = max(datos(si:asi,i));
    min3 = min(datos(asi:ti,i));
    max3 = max(datos(asi:ti,i));
    
    % Adjust necesari per a fixar els llimis relatius dacord amb
    % l'oscilació entre minim i maxims absoluts.
    
    dif1 = max1-min1;
    dif2 = max2-min2;
    dif3 = max3-min3;
    dif4 = max1-min2;
    
    % Llimits relatius
    minim1 = 0.05*dif1 + min1;
    maxim1 = 0.85*dif1 + min1;
    maxim2 = 0.98*dif1 + min1;
    minim2 = 0.05*dif4 + min2;
    minim3 = 0.05*dif2 + min2;
    maxim3 = 0.85*dif2 + min2;
    minim4 = 0.05*dif3 + min3;
    maxim4 = 0.85*dif3 + min3;
    
    % Umbralitzem en funcio del interval
    
    % Interval [1:fi]
    for j=1:fi
        
        if datos(j,i) < minim1
            
            datos2(j,i) = minim1;
            
        else
            
            datos2(j,i) = datos(j,i);
            
        end
    end
    
    % Interval [fi:pos]
    
    for j=fi:pos
        
         if datos(j,i) > maxim2
            
            datos2(j,i) = maxim2;
            
         elseif datos(j,i) > maxim1
            
            datos2(j,i) = maxim1;
        
         elseif datos(j,i) < minim1
            
            datos2(j,i) = minim1;
                           
        else
            
            datos2(j,i) = datos(j,i);        
        
        end
        
        
    end
    
    
    % Interval [fi:si]
    
    for j=pos:si
        
        if datos(j,i) > maxim2
            
            datos2(j,i) = maxim2;
            
        elseif datos(j,i) > maxim1
            
            datos2(j,i) = maxim1;
        
        elseif datos(j,i) < minim2
        
            datos2(j,i) = minim2;
       
        else
            
            datos2(j,i) = datos(j,i);        
        
        end
    
    end
    
    % Interval [si:asi]
    
    for j=si:asi
        
       if datos(j,i) > maxim3
           
           datos2(j,i) = maxim3;
           
       elseif datos(j,i) < minim3
           
           datos2(j,i) = minim3;
           
       else
           
           datos2(j,i) = datos(j,i);
           
       end
        
    end
    
    % Interval [asi:f]
    
    for j=asi:f
       
        if datos(j,i) < minim4
            
            datos2(j,i) = minim4;
            
        elseif datos(j,i) > maxim4
            
            datos2(j,i) = maxim4;
            
        else 
            
            datos2(j,i) = datos(j,i);
            
        end
        
    end
    
    
    
    
end

end






















