function generaFPar()

directoris = {'Z:\Matlab\dades\prova_temps\Dades\4'}
for dd=1:1
    
    directori = directoris{dd}
    
    %Variables globals
    files2 = getAllFiles(directori);
    
    aux = size(files2);
    j=1;
    for i=1:aux
        
        aux2 = files2(i);
        aux2 = aux2{:};
        folders = strsplit(aux2,'\');
        fitxer= [folders(8)];
        fitxer = fitxer{:};
        extensions=strsplit(fitxer,'_');
        aux3 = extensions(end);
        aux3 = aux3{:};
        
        if strcmp(aux3 ,'punto.txt')== 0
            files(j)=files2(i);
            j=j+1;
        end
        
    end
    
    files=files';
    fecha = datestr(now,'dd_mm_YY');
    vs = '1';
    fitxerfinal = ['Z:\Matlab\dades\prova_temps\Resultats\',fecha,'\DadesTemps85_',vs,'.txt'];
    while exist(fitxerfinal,'file')==2
        vs = num2str(str2num(vs)+1);
        fitxerfinal = ['Z:\Matlab\dades\prova_temps\Resultats\',fecha,'\DadesTemps85_',vs,'.txt'];
    end
    % files(1) = files2(1);
    % files(2) = files2(22);
    % files=files';
    
    
    
    
    
    
    % Construcció string principal
    
    prova = '';
    
    c = 32; % 32 sensors
    for i=1:c
        
        prova = [prova,'TS',num2str(i),char(9),'SS',num2str(i),char(9),'DS',num2str(i),char(9)];
        
    end
    
    prova = [prova,'name'];
    
    
    WriteToFile(fitxerfinal, prova);
    
    prova='';
    
    [fils,cols] = size(files);
    
    num = 1;
    
    for fil=1:fils
        
        file=[files(fil)];
        file=file{:}
        folders = strsplit(file,'\');
        folder = [folders(7)];
        folder = folder{:};
        
        
        
        [datos,T,datos2,fi,si,ti] = carregaDades(file);
        
        
        cPar(folder,datos,T,datos2,fi,si,ti,fitxerfinal);
        
        
        
    end
    
end
end


