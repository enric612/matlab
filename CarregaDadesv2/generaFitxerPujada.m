function generaFitxerPujada(carpeta,fitxerfinal)
format long;

    % Variables Globals

   % fitxerfinal = 'Z:\matlab\dades\prova_2\Resultats\08_04_14\DadesPlus.txt';


    % Generem la capçalera del fitxer suposem 32 sensors
    c = 32; % 32 sensors
    
    % Format Weka, afegim els atributs.
    % @relation <relation-name>
    % @attribute <attribute-name> <datatype>
    %   <datatype> 
    %       numeric
    %       <nominal-specification>
    %       string
    %       date [<date-format>]
    %
    % Les classes nominals es defineixen especificant cada string nominal
    % així : @attribute classe {string-1,string-2,...,string-n}
    % 
    % @data
    % data1,data2,...,datan
    % 
    % L'atribut @data indica l'inici de les files de dades amb el valor
    % dels atributs descrits per els atributs @attribut separats per comes.
    % 
    % char(13) = > salt de línea no ASCII
    
    
    capsalera = ['@relation ','Test','',char(13),'@ATTRIBUTE ','aSlope',' numeric',char(13),'@ATTRIBUTE ','aSlope2',' numeric',char(13),'@ATTRIBUTE ','aSlope3',' numeric',char(13),'@ATTRIBUTE ','aSlope4',' numeric',char(13),'@ATTRIBUTE ','aSlope5',' numeric',char(13),'@ATTRIBUTE ','bSlope',' numeric',char(13),'@ATTRIBUTE ','bSlope2',' numeric',char(13),'@ATTRIBUTE ','bSlope3',' numeric',char(13),'@ATTRIBUTE ','bSlope4',' numeric',char(13),'@ATTRIBUTE ','bSlope5',' numeric',char(13),'@ATTRIBUTE ','cSlope',' numeric',char(13),'@ATTRIBUTE ','cSlope2',' numeric',char(13),'@ATTRIBUTE ','cSlope3',' numeric',char(13),'@ATTRIBUTE ','cSlope4',' numeric',char(13),'@ATTRIBUTE ','cSlope5',' numeric',char(13),'@ATTRIBUTE ','VA1',' numeric',char(13),'@ATTRIBUTE ','VA2',' numeric',char(13),'@ATTRIBUTE ','VA3',' numeric',char(13),'@ATTRIBUTE ','VA4',' numeric',char(13),'@ATTRIBUTE ','VA5',' numeric',char(13),'@ATTRIBUTE ','VB1',' numeric',char(13),'@ATTRIBUTE ','VB2',' numeric',char(13),'@ATTRIBUTE ','VB3',' numeric',char(13),'@ATTRIBUTE ','VB4',' numeric',char(13),'@ATTRIBUTE ','VB5',' numeric',char(13),'@ATTRIBUTE ','VC1',' numeric',char(13),'@ATTRIBUTE ','VC2',' numeric',char(13),'@ATTRIBUTE ','VC3',' numeric',char(13),'@ATTRIBUTE ','VC4',' numeric',char(13),'@ATTRIBUTE ','VC5',' numeric',char(13),'@ATTRIBUTE ','DVA',' numeric',char(13),'@ATTRIBUTE ','DVB',' numeric',char(13),'@ATTRIBUTE ','DVC',' numeric',char(13),'@ATTRIBUTE ','difA',' numeric',char(13),'@ATTRIBUTE ','difB',' numeric',char(13),'@ATTRIBUTE ','sensor',' {1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32} ',char(13),'@ATTRIBUTE ','N',' {1,2,3,4,5}',char(13),'@ATTRIBUTE ','M',' {A,B,C,D}',char(13),'@ATTRIBUTE ','tempo',' {tempo0,tempo1,tempo2,tempo3}',char(13),'@ATTRIBUTE ','name',' {CONTROL,ETHYLENO,ETHYLENOCERA,QUIMICA}',char(13),'@data'];

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
            % Guardem els parametres M, N, tempo i name 
            name{j} = carpeta1{:};
            mprev = extensions{end};
            mprev = strsplit(mprev,'.');
            m{j} = mprev{1};
            n{j} = extensions{end-1};
            tempo{j} = extensions{end-2};
            j=j+1;
        end

    end
    
    files = files';

    nf = size(files);

    % Recorrem els fitxers
    for i=1:nf

        file = files(i);
        file = file{:};
        disp('-----------------------------------------------------------------------------')
        disp(['Fitxer actulal : ',file])
        disp('-----------------------------------------------------------------------------')
        [datos, datos2, T, fi, si, ti] = carregaDadesPujada(file, 0);
        [aSlope,bSlope,cSlope,aPolySlope,bPolySlope,cPolySlope,V_highta,V_hightb,V_low,DV_highta,DV_hightb,DV_low,Dif1,Dif2] = calculaParametresPujada(fi,si,ti,datos2,datos);
        
        % Inicialitzem string
        fila = '';
        
        % Generem les files de dades per a 32 sensors (1 fila per sensor)
        for j=1:32
        
            fila = [fila,num2str(aSlope(j)),',',num2str(bSlope(j)),',',num2str(cSlope(j)),',',num2str(aPolySlope(1,j)),',',num2str(aPolySlope(2,j)),',',num2str(aPolySlope(3,j)),',',num2str(aPolySlope(4,j)),',',num2str(bPolySlope(1,j)),',',num2str(bPolySlope(2,j)),',',num2str(bPolySlope(3,j)),',',num2str(bPolySlope(4,j)),',',num2str(cPolySlope(1,j)),',',num2str(cPolySlope(2,j)),',',num2str(cPolySlope(3,j)),',',num2str(cPolySlope(4,j)),',',num2str(V_highta(1,j)),',',num2str(V_highta(2,j)),',',num2str(V_highta(3,j)),',',num2str(V_highta(4,j)),',',num2str(V_highta(5,j)),',',num2str(V_hightb(1,j)),',',num2str(V_hightb(2,j)),',',num2str(V_hightb(3,j)),',',num2str(V_hightb(4,j)),',',num2str(V_hightb(5,j)),',',num2str(V_low(1,j)),',',num2str(V_low(2,j)),',',num2str(V_low(3,j)),',',num2str(V_low(4,j)),',',num2str(V_low(5,j)),',',num2str(DV_highta(j)),',',num2str(DV_hightb(j)),',',num2str(DV_low(j)),',',num2str(Dif1(j)),',',num2str(Dif2(j)),',',num2str(j),',',m{i},',',n{i},',',tempo{i},',',name{i},char(13)];
        
        end
        
        % Afegim el nom de la carpeta
       % fila = [fila,carpeta2{i}];
        
        % Guardem en fitxer
        WriteToFile(fitxerfinal, fila);
        

    end

end