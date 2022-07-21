function TrajPkte = heun(initX,initY,initAng,initVel,daempf)
% Trajektorien Berechnung eines Basketballwurfs ohne Luftwiderstand
% Input:  initX .... Abwurfentfernung vom Mittelpunkt des Korbs
%         initY .... Abwurfhöhe
%         initAng .. Abwurfwinkel
%         initVel .. Abwurfgeschwindigkeit
%         daempf ... Daempfung (ab Aufgabe 3 relevant)
% Output: TrajPkte . 2-zeilige Matrix aller Punkte die der Ball beim Wurf
%                    durchlaueft

%Anzahl Punkte
n = 100; 

x = zeros(2,n);
v = zeros(2,n);

g = -9.81;
a = [0 g]';

%Anfangsbedigungen Ort- und Geschwindigkeitsspaltenvektor
x(:,1) = [initX; initY];
v(:,1) = [initVel * cos(initAng); initVel * sin(initAng)];

delta_t = 0.1; %Schrittweite (0.1, 0.01, 0.001)

i = 1;

%________________AUFGABE 2________________%

% while (x(2,i) > 0) && (i < n)
% 
%     x(:,(i+1)) = x(:,i) + 0.5 .* delta_t .* (v(:,i) + v(:,i) + delta_t .* a);
%     v(:,(i+1)) = v(:,i) + delta_t .* a;
%     i = i+1;
% 
% end
% 
% TrajPkte = x(:,(1:i));

%________________AUFGABE 3________________%

Boden = false;

    while (x(1,i) < x(1,end)) && (i < n)
    
       x(:,(i+1)) = x(:,i) + 0.5 .* delta_t .* (v(:,i) + v(:,i) + delta_t .* a);
       v(:,(i+1)) = v(:,i) + delta_t .* a;
       i = i+1;
    
            if x(2,i) < 0

                if (Boden == false)

                    Iterationen = i
                    Wurfdistanz = (x(1,i) - initX(1,1))
                    Geschwindigkeit = norm(v(:,i))
    
                    Boden = true;
                
                end

                x(2,i) = -x(2,i);
                v(2,i) = -v(2,i) * daempf;
            end   
    end

TrajPkte = x(:,(1:i));

%__________________________________________%

end