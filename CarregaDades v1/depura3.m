[f,c] = size(datos);


for i=1:c
    
    min1=  min(datos(1:si,i));
    
    maxim = ((max(datos(:,i)) - min1)*0.85 )+ min1;
    maxim2 = ((max(datos(:,i)) - min1)*0.98 )+ min1;
    minim = ((max(datos(1:si,i)) - min1)*0.05 )+ min1;
    
    
    for j=1:f
        
        if (datos(j,i)) >= maxim2 
            
            datos2(j,i) = maxim2;
            
        elseif (datos(j,i)) > maxim
            
            datos2(j,i) = maxim;
            
        elseif (datos(j,i)) < minim 
            
            datos2(j,i) = minim;
            
        else
            
            datos2(j,i) = datos(j,i);
            
        end
    end
    
    
    
end
