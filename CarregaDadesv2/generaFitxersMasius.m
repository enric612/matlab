function generaFitxersMasius(carpetes)
    
    carpetes = carpetes';
    a = size(carpetes);



    for i=1:a
        disp('****************************************************************************')
        disp(['                                 NOVA CARPETA : CARPETA:',num2str(i)])
        disp('****************************************************************************')
        carpeta = [carpetes{i},'\dades'];
        fitxerFinal = [carpetes{i},'\Resultats\Dades_',datestr(now,'dd_mm_YY'),'.arff'];
        
        disp(['Nom de la la carpeta : ',carpeta])
        disp(['Nom del fitxer final : ', fitxerFinal])


        generaFitxerPujada(carpeta,fitxerFinal);

    end





end