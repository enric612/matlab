function generaFitxer(carpeta)

    % Variables Globals

    fitxerfinal = 'Z:\matlab\dades\prova4_invertido\Resultats\07_04_14\Dades1.txt';


    % Generem la capçalera del fitxer suposem 32 sensors
    c = 32; % 32 sensors
    
    % Inicialitzem string
    capsalera = '';
    
    for i=1:c
        
        %Capçalera passa a nombrar-se capsalera per temes de compatibilitat
        %(la ç no es compatible amb matlab)
        capsalera = [capsalera,'aSlope',num2str(i),char(9),'bSlope',num2str(i),char(9),'cSlope',num2str(i),char(9)];

    end

    % Afegim camp name a la capçalera
    capsalera = [capsalera,'name'];
    
    % Guardem la capçalera
    WriteToFile(fitxerfinal, capsalera);


    % Ara anem a Generar i guardar els valors dels parametres de cada
    % fitxer.

    % Genera el fitxer de parametres donada una carpeta.
    files2 = getAllFiles(carpeta);

    aux = size(files2);

    % Filtrem els fitxers de cache (_punto) per a no inclourels com a
    % fitxers propis.
    j=1;
    for i=1:aux

        aux2 = files2(i);
        aux2 = aux2{:};
        folders = strsplit(aux2,'\');
        fitxer= [folders(end)];
        fitxer = fitxer{:};
        carpeta1 = [folders(end-1)];
        carpeta2{i} = carpeta1{:};
        extensions=strsplit(fitxer,'_');
        aux3 = extensions(end);
        aux3 = aux3{:};

        if strcmp(aux3 ,'punto.txt')== 0
            files(j)=files2(i);
            j=j+1;
        end

    end
    
    files = files';

    nf = size(files);

    % Recorrem els fitxers
    for i=1:nf

        file = files(i);
        file = file{:};
        [datos, datos2, T, fi, si, ti] = carregaDades(file, 0);
        [aSlope,bSlope,cSlope] = calculaPendents(fi,si,ti,datos2,datos);
        
        % Inicialitzem string
        fila = '';
        
        % Generem la fila de dades per a 32 sensors
        for j=1:32
        
            fila = [fila,num2str(aSlope(j)),char(9),num2str(bSlope(j)),char(9),num2str(cSlope(j)),char(9)];
        
        end
        
        % Afegim el nom de la carpeta
        fila = [fila,carpeta2{i}];
        
        % Guardem en fitxer
        WriteToFile(fitxerfinal, fila);
        

    end

end