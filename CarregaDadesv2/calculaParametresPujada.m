
function [aSlope,bSlope,cSlope,aPolySlope,bPolySlope,cPolySlope,V_highta,V_hightb,V_low,DV_highta,DV_hightb,DV_low,Dif1,Dif2] = calculaParametresPujada(fi,si,ti,datos2,datos)

format long;

[f,c] = size(datos2);

for i=1:c
    
    % Fixem els maxims i minims en funció de l'amplitud de les gràfiques.
    
   
     % Llimits absoluts
    max1 = max(datos(fi:si,i));
    min1 = min(datos(fi:si,i));
    min2 = min(datos(si:ti,i));
    
    % Matrius de valors polinomiques
    
    %V_highta
    
    V_highta(1,i) = min1;
    for p=2:5
        V_highta(p,i) = min1^p;
    end
    
    %V_hightb
    
    V_hightb(1,i) = min2;
    for p=2:5
        V_hightb(p,i) = min2^p;
    end
    
    %V_low
    
    V_low(1,i) = max1;
    for p=2:5
        V_low(p,i) = max1^p;
    end
    
    % Matrius potencies de 10
    
    % 10^V_highta
    DV_highta(i) = 10^V_highta(1,i);
    
    % 10^V_hightb
    DV_hightb(i) = 10^V_hightb(1,i);
    
    % 10^V_low
    DV_low(i) = 10^V_low(1,i);
    
    % Adjust necesari per a fixar els llimis relatius dacord amb
    % l'oscilació entre minim i maxims absoluts.
    
    dif1 = max1-min1;
    dif2 = max1-min2;
    
    Dif1(i) = dif1;
    Dif2(i) = dif2;
    
     % Llimits relatius
    minim1 = 0.05*dif1 + min1; 
    maxim1 = 0.85*dif1 + min1;
    maxim2 = 0.98*dif1 + min1;
    minim2 = 0.05*dif2 + min2;
    
    % Calcul Pendentes
    
    % aSlope
    
    % Punts
    
    aS1 = find(datos2(si:-1:fi,i) <= minim1, 1 ,'first');
    % Adaptamos rango
    aS1 = si - aS1;
    
    aS2 = find(datos2(fi:si,i) >= maxim1, 1 ,'first');
    % Adaptamos rango
    aS2 = aS2 + fi;
    
    % m = b/a
    % b = |aSlope_Y|
    % a = |aSlope_X|
    aSlope(i) = (datos(aS2,i)-datos(aS1,i))/(aS2-aS1); 
    
    % Calculem les exponencials de la pendent (2 a 5)
    for p=2:5
        
       aPolySlope((p-1),i)  = (aSlope(i))^p;
       
    end
    
    
    
    % bSlope
    
    bS1 = aS2;
    
    bS2 = find(datos2(fi:si,i) >= maxim2, 1 ,'first');
    % Adaptamos rango
    bS2 = bS2+fi;
    
    bSlope(i) = (datos(bS2,i)-datos(bS1,i))/(bS2-bS1); 
    
    % Calculem les exponencials de la pendent (2 a 5)
    for p=2:5
        
       bPolySlope((p-1),i)  = (bSlope(i))^p;
       
    end
    
    
    % cSlope
    
    cS1 =  find(datos2(ti:-1:fi,i) >= maxim1, 1 ,'first' );
    % Adaptamos rango
    cS1 = ti-cS1;
    
    cS2 = find(datos2(si:ti,i) <= minim2, 1 ,'first');
    % Adaptamos rango
    cS2 = si+cS2;
    
    cSlope(i) = (datos(cS2,i)-datos(cS1,i))/(cS2-cS1); 
    
     % Calculem les exponencials de la pendent (2 a 5)
    for p=2:5
        
       cPolySlope((p-1),i)  = (cSlope(i))^p;
       
    end
    
end


end