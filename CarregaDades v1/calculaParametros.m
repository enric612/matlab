
function [sd1, sd2, sumSlope, sumsSlopeT, posicion,esat,ttt,tSlope] =  calculaParametros(datos,T,fi,si)



[f,c] = size(datos); %Tamany de les dades


% Calcul de les primeres i segones derivades

for i=1:c
    
    sd1(:,i) = gradient(datos(:,i),T);
    sd2(:,i) = gradient(sd1(:,i),T);
    
end


% Calcul maxims i minims
% Quan la segon derivada = 0 marca un màxim o un mínim en la primera
% derivada. Així tracem el sumatori de pendents de les senyals

for i=1:c
    q=1;
    
    for j=2:f
        
        if sd2(j,i) >0
            if sd2((j-1),i)<0
                sumSlope(q,i) = sd1(j,i);
                posicion(q,i)=j;
                q=q+1;
            end;
            
        elseif sd2(j,i) <0
            if sd2((j-1),i)>0
                sumSlope(q,i) = sd1(j,i);
                posicion(q,i)=j;
                q=q+1;
            end;
            
        end
        
        
    end
    
end


% Ara adaptarem la matriu de pendents al numero de mostres de les senyals
% pero poder representarles en l'eix temporal real

[t1,t2] = size(sumSlope);

for i=1:c
    q=1;
    
    for j=2:t1
        
        
        
        if j == posicion(q,i)
            q=q+1;
            
            
            
            if q < t1
                
                sumsSlopeT(j,i) = ((sumSlope(q,i) - sumSlope((q-1),i))/(posicion(q,i)-posicion((q-1),i)))*(j-posicion((q-1),i))+(sumSlope((q-1),i));
                
            else
               sumsSlopeT(j,i) = 0;
            end
        else
            if (q-1)>0
                
                sumsSlopeT(j,i) = ((sumSlope(q,i) - sumSlope((q-1),i))/(posicion(q,i)-posicion((q-1),i)))*(j-posicion((q-1),i))+(sumSlope((q-1),i));
                
            else
               sumsSlopeT(j,i)=0;
            end
        end
        
        
        
    end
    
    
    
end


% Calcul parametres
% Calculem els punt ttt(Time to Treshold) esat (early saturation) tslope
% (transient slope) lsat (latesaturation) sslope (saturation slope)


% Comencem per la primera pendent important (pujada)

for i=1:c
   
    [max1(i),esat(i)] = max(sumsSlopeT(fi:si,i));
    esat(i) = (esat(i) + fi-1); % Posició calculada + offset de l'interval seleccionat
    
    [min1,ttt(i)]= min(sumsSlopeT(fi:esat(i),i));
    
    ttt(i) = ttt(i) + fi-1;
    
    tSlope(i) = max1(i)-min1; % La resta dels valors dels extrems de la pendent principal de pujada es el valor del seu mòdul.
    
    %Ara treurem els valors sSlope i lSlope
    
    psmax(i) = -1; %Si el valor no varia es perque el màxim no es correcte
    
    for j=1:t1
        
        if sumSlope(j,i) == max1(i)
           
            psmax(i) = posicion(j+1,i); %Guardem la següent posició pertenent al minim o màxim següent.
            
        end
        
    end
    
%     if psmax(i)~=-1  %Si el valor ha variat, tenim una posició valida. Ara podem excloure este màxim del rastreig.
%         
%         [max2(i),lSlope(i)] = max(sumsSlopeT(psmax(i):si,i));
%         
%         
%     end
    
    ttt(i) = (ttt(i)+100)/100; % En segons + ofset de 1 segon degut a que eliminem les 100 primeres mostres (100*10ms = 1s)
    
    esat(i)=(esat(i)+100)/100; % En segons
    
    
end



end
