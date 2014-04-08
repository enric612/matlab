function generaFitxerPujada(carpeta)
format long;
    % Variables Globals

    fitxerfinal = 'Z:\matlab\dades\Resultatsproves\DadesTestPlus.txt';


    % Generem la capçalera del fitxer suposem 32 sensors
    c = 32; % 32 sensors
    
    % Inicialitzem string
    capsalera = '';
    
    for i=1:c
        
        %Capçalera passa a nombrar-se capsalera per temes de compatibilitat
        %(la ç no es compatible amb matlab)
        capsalera = [capsalera,'aSlope',num2str(i),char(9),'bSlope',num2str(i),char(9),'cSlope',num2str(i),char(9),'aPolySlope2',num2str(i),char(9),'aPolySlope3',num2str(i),char(9),'aPolySlope4',num2str(i),char(9),'aPolySlope5',num2str(i),char(9),'bPolySlope2',num2str(i),char(9),'bPolySlope3',num2str(i),char(9),'bPolySlope4',num2str(i),char(9),'bPolySlope5',num2str(i),char(9),'cPolySlope2',num2str(i),char(9),'cPolySlope3',num2str(i),char(9),'cPolySlope4',num2str(i),char(9),'cPolySlope5',num2str(i),char(9),'V_highta1',num2str(i),char(9),'V_highta2',num2str(i),char(9),'V_highta3',num2str(i),char(9),'V_highta4',num2str(i),char(9),'V_highta5',num2str(i),char(9),'V_hightb1',num2str(i),char(9),'V_hightb2',num2str(i),char(9),'V_hightb3',num2str(i),char(9),'V_hightb4',num2str(i),char(9),'V_hightb5',num2str(i),char(9),'V_low1',num2str(i),char(9),'V_low2',num2str(i),char(9),'V_low3',num2str(i),char(9),'V_low4',num2str(i),char(9),'V_low5',num2str(i),char(9),'DV_highta',num2str(i),char(9),'DV_hightb',num2str(i),char(9),'DV_low',num2str(i),char(9),'Dif1',num2str(i),char(9),'Dif2',num2str(i),char(9)];

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
        extensions=strsplit(fitxer,'_');
        aux3 = extensions(end);
        aux3 = aux3{:};

        if strcmp(aux3 ,'punto.txt')== 0
            files(j)=files2(i);
            carpeta2{j} = carpeta1{:};
            j=j+1;
        end

    end
    
    files = files';

    nf = size(files);

    % Recorrem els fitxers
    for i=1:nf

        file = files(i);
        file = file{:}
        [datos, datos2, T, fi, si, ti] = carregaDadesPujada(file, 0);
        [aSlope,bSlope,cSlope,aPolySlope,bPolySlope,cPolySlope,V_highta,V_hightb,V_low,DV_highta,DV_hightb,DV_low,Dif1,Dif2] = calculaParametresPujada(fi,si,ti,datos2,datos);
        
        % Inicialitzem string
        fila = '';
        
        % Generem la fila de dades per a 32 sensors
        for j=1:32
        
            fila = [fila,num2str(aSlope(j)),char(9),num2str(bSlope(j)),char(9),num2str(cSlope(j)),char(9),num2str(aPolySlope(1,j)),char(9),num2str(aPolySlope(2,j)),char(9),num2str(aPolySlope(3,j)),char(9),num2str(aPolySlope(4,j)),char(9),num2str(bPolySlope(1,j)),char(9),num2str(bPolySlope(2,j)),char(9),num2str(bPolySlope(3,j)),char(9),num2str(bPolySlope(4,j)),char(9),num2str(cPolySlope(1,j)),char(9),num2str(cPolySlope(2,j)),char(9),num2str(cPolySlope(3,j)),char(9),num2str(cPolySlope(4,j)),char(9),num2str(V_highta(1,j)),char(9),num2str(V_highta(2,j)),char(9),num2str(V_highta(3,j)),char(9),num2str(V_highta(4,j)),char(9),num2str(V_highta(5,j)),char(9),num2str(V_hightb(1,j)),char(9),num2str(V_hightb(2,j)),char(9),num2str(V_hightb(3,j)),char(9),num2str(V_hightb(4,j)),char(9),num2str(V_hightb(5,j)),char(9),num2str(V_low(1,j)),char(9),num2str(V_low(2,j)),char(9),num2str(V_low(3,j)),char(9),num2str(V_low(4,j)),char(9),num2str(V_low(5,j)),char(9),num2str(DV_highta(j)),char(9),num2str(DV_hightb(j)),char(9),num2str(DV_low(j)),char(9),num2str(Dif1(j)),char(9),num2str(Dif2(j)),char(9)];
        
        end
        
        % Afegim el nom de la carpeta
        fila = [fila,carpeta2{i}];
        
        % Guardem en fitxer
        WriteToFile(fitxerfinal, fila);
        

    end

end