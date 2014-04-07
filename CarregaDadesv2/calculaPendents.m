function [aSlope,bSlope,cSlope] = calculaPendents(fi,si,ti,datos2,datos)

[f,c] = size(datos2);

for i=1:c
    
    % Fixem els maxims i minims en funció de l'amplitud de les gràfiques.
    
   
    % Llimits absoluts
    max1 = max(datos(fi:si,i));
    min1 = min(datos(fi:si,i));
    max2 = max(datos(si:ti,i));
    
    
    % Adjust necesari per a fixar els llimis relatius dacord amb
    % l'oscilació entre minim i maxims absoluts.
    
    dif1 = max1-min1;
    dif2 = max2-min1;
    
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
    
    % bSlope
    
    bS1 = aS2;
    
    bS2 = find(datos2(fi:si,i) <= minim2, 1 ,'first');
    % Adaptamos rango
    bS2 = bS2+fi;
    
    bSlope(i) = (datos(bS1)-datos(bS2))/(bS2-bS1); 
    
    
    % cSlope
    
    cS1 =  find(datos2(ti:-1:si,i) <= minim2, 1 ,'first' );
    % Adaptamos rango
    cS1 = ti-cS1;
    
    cS2 = find(datos2(si:ti,i) >= maxim2, 1 ,'first');
    % Adaptamos rango
    cS2 = si+cS2;
    
     cSlope(i) = (datos(cS2)-datos(cS1))/(cS2-cS1); 
    
end


end