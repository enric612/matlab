
function cPar(folder,datos,T,datos2,fi,si,ti,fitxerfinal)


prova='';
%prova = [prova,char(10)];
%Calcul limits

[f,c] = size(datos);

%Calcul dels umbrals
for i=1:c
    
    

    min1 =  min(datos(fi:si,i));
    max1 = max(datos(fi:si,i));
    max2 = max(datos(si:ti,i));
    min2 = min(datos(si:ti,i));
    dif = max1 - min1;
    dif2 = max2 - min2;
    
    
    maxim(i) = dif*0.85 + min1;
    maxim2(i) = dif*0.98 + min1;
    maxim3(i) = dif2*0.85 + min2;
    minim(i) = dif*0.05 + min1;
    minim2(i)= dif2*0.05 + min2;


end

%Calcul dels parametres

[f,c] = size(datos2);

for i=1:c
   
   pttt =  find( datos2(si:-1:fi,i) <= minim(i) , 1 ,'first' ); % Primer punt minim des del final al principi
   pttt = si-pttt; % Adaptem coordenades
   ttt = datos2(pttt,i); %Guardem el valor
   pttt = T(pttt);
   
   pesat = find(datos2(fi:si,i) >= maxim(i), 1 , 'first'); %Posicio del primer maxim (saturacio 85%)
   pesat = pesat+fi;
   esat = datos2(pesat,i); % Maginitud
   pesat = T(pesat);
   
   tSlope(i) = (esat - ttt )/(pesat - pttt); % Pendent de una recta es m=b/a sent : b = |magnituds| a=|posicions| 
   
   plsat = find(datos2(fi:si,i) >= maxim2(i), 1 , 'first');%Posicio del primer maxim (saturacio 98%)
   plsat = plsat+fi;
   
   lsat = datos2( plsat,i); % Magnitud
   plsat = T(plsat);
   
   sSlope(i) = (lsat - esat )/( plsat - pesat);
   
   pdesat = find(datos2(ti:-1:si,i) >= maxim3(i) , 1 , 'first');
   
   pdesat = ti - pdesat;
   
   desat = datos2(pdesat,i);
   pdesat = T(pdesat);
   
   pfinal = find(datos2(si:ti,i)  <= minim2(i), 1 , 'first');
   pfinal = pfinal +si;
   
   final = datos2(pfinal,i);
   pfinal = T(pfinal);
   
   dSlope(i) = (desat - final )/( pdesat - pfinal);
   
   prova = [prova,num2str(tSlope(i)),char(9),num2str(sSlope(i)),char(9),num2str(dSlope(i)),char(9)];
   
    
end

prova = [prova,folder];

WriteToFile(fitxerfinal, prova);


end