fecha = datestr(now,'dd_mm_YY');
vs = '1';
fitxerfinal = ['Z:\Matlab\dades\prova_2\Resultats\',fecha,'\DadesTemps85_',vs,'.txt'];
while exist(fitxerfinal,'file')==2  
vs = num2str(str2num(vs)+1);    
    fitxerfinal = ['Z:\Matlab\dades\prova_2\Resultats\',fecha,'\DadesTemps85_',vs,'.txt'];
end