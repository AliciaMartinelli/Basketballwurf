%Aufgabe 1:

clear all;
clc;
close all;

%Approximationen

j = (1:10);
delta_t = (2.^(-j));

n = 1 ./ delta_t;

for k = 1:10
    for i = 1:(n(k)-1)
    
        %Euler-Verfahren:
     
        x_euler(1,k) = 0;
        v_euler(1,k) = 1;
    
        x_euler((i+1),k) = x_euler(i,k) + delta_t(k) * v_euler(i,k);
        v_euler((i+1),k) = v_euler(i,k) + delta_t(k) * 2 * sqrt(v_euler(i,k));
        
        %Heun-Verfahren:
        
        x_heun(1,k) = 0;
        v_heun(1,k) = 1;
        
        x_heun((i+1),k) = x_heun(i,k) + 0.5 * delta_t(k) * (v_heun(i,k) + (v_heun(i,k) + delta_t(k) * 2 * sqrt(v_heun(i,k))));
        v_heun((i+1),k) = v_heun(i,k) + 0.5 * delta_t(k) * (2 * sqrt(v_heun(i,k)) + 2 * sqrt(v_heun(i,k) + delta_t(k) * 2 * sqrt(v_heun(i,k))));
    
    end


    %Geschwindigkeit:
    
    Err_v_euler(k) = 4 - v_euler(n(k),k);
    Err_v_heun(k) = 4 - v_heun(n(k),k);
    
    %Ort:
    
    Err_x_euler(k) = (7/3) - x_euler(n(k),k);
    Err_x_heun(k) = (7/3) - x_heun(n(k),k);

end

%Plot Geschwindigkeit
figure(1)
semilogy(1:10,Err_v_euler,'-o',1:10,Err_v_heun,'-o',1:10,delta_t,'-.',1:10,(delta_t).^2,'--')
%axis([1 10 10^-7 1])
legend({'Fehler Exp. Eul.','Fehler Heun','Linear','Quadratisch'})
xlabel('Schrittweite 2^ (-i)')
ylabel('Fehler')
title('Konvergenz v(t)')

%Plot Ort
figure(2)
semilogy(1:10,Err_x_euler,'-o',1:10,Err_x_heun,'-o',1:10,delta_t,'-.',1:10,(delta_t).^2,'--')
%axis([1 10 10^-7 1])
legend({'Fehler Exp. Eul.','Fehler Heun','Linear','Quadratisch'})
xlabel('Schrittweite 2^ (-i)')
ylabel('Fehler')
title('Konvergenz x(t)')


