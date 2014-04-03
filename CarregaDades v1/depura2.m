%Comparativa de dades
signal = 1;
subplot(2,1,1)
plot(T,[sumsSlopeT(:,signal) sd1(:,signal) datos(:,signal)-6.5e11])
% line([esat(signal) esat(signal)],[-2e11 4e11]);
% line([ttt(signal) ttt(signal)],[-2e11 4e11]);
subplot(2,1,2)
plot(sumSlope(:,signal))
