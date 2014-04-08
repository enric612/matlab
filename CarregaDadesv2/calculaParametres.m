
function [aSlope,bSlope,cSlope,aPolySlope,bPolySlope,cPolySlope,V_highta,V_hightb,V_low,DV_highta,DV_hightb,DV_low,Dif1,Dif2] = calculaParametres(fi,si,ti,datos2,datos)

format long;

[f,c] = size(datos2);

for i=1:c
    
    % Fixem els maxims i minims en funció de l'amplitud de les gràfiques.
    
   
    % Llimits absoluts
    max1 = max(datos(fi:si,i));
    min1 = min(datos(fi:si,i));
    max2 = max(datos(si:ti,i));
    
    % Matrius de valors polinomiques
    
    %V_highta
    
    V_highta(1,i) = max1;
    for p=2:5
        V_highta(p,i) = max1^p;
    end
    
    %V_hightb
    
    V_hightb(1,i) = max2;
    for p=2:5
        V_hightb(p,i) = max2^p;
    end
    
    %V_low
    
    V_low(1,i) = min1;
    for p=2:5
        V_low(p,i) = min1^p;
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
    dif2 = max2-min1;
    
    Dif1(i) = dif1;
    Dif2(i) = dif2;
    
    % Llimits relatius
    minim1 = 0.20*dif1 + min1;
    minim2 = 0.02*dif1 + min1;
    maxim1 = 0.95*dif1 + min1;
    maxim2 = 0.85*dif2 + min1; 
    
    % Calcul Pendentes
    
    % aSlope
    
    % Punts
    
    aS1 = find(datos2(si:-1:fi,i) >= maxim1, 1 ,'first');
    % Adaptamos rango
    aS1 = si - aS1;
    
    aS2 = find(datos2(fi:si,i) <= minim1, 1 ,'first');
    % Adaptamos rango
    aS2 = aS2 + fi;
    
    % m = b/a
    % b = |aSlope_Y|
    % a = |aSlope_X|
    aSlope(i) = (datos(aS1)-datos(aS2))/(aS2-aS1); 
    
    % Calculem les exponencials de la pendent (2 a 5)
    for p=2:5
        
       aPolySlope((p-1),i)  = (aSlope(i))^p;
       
    end
    
    
    
    % bSlope
    
    bS1 = aS2;
    
    bS2 = find(datos2(fi:si,i) <= minim2, 1 ,'first');
    % Adaptamos rango
    bS2 = bS2+fi;
    
    bSlope(i) = (datos(bS1)-datos(bS2))/(bS2-bS1); 
    
    % Calculem les exponencials de la pendent (2 a 5)
    for p=2:5
        
       bPolySlope((p-1),i)  = (bSlope(i))^p;
       
    end
    
    
    % cSlope
    
    cS1 =  find(datos2(ti:-1:si,i) <= minim2, 1 ,'first' );
    % Adaptamos rango
    cS1 = ti-cS1;
    
    cS2 = find(datos2(si:ti,i) >= maxim2, 1 ,'first');
    % Adaptamos rango
    cS2 = si+cS2;
    
     cSlope(i) = (datos(cS2)-datos(cS1))/(cS2-cS1); 
    
     % Calculem les exponencials de la pendent (2 a 5)
    for p=2:5
        
       cPolySlope((p-1),i)  = (cSlope(i))^p;
       
    end
    
end


end