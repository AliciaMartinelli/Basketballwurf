function [TrajPkte,luftG] = rkf23LW(initX,initY,initAng,initVel,daempf)
% Trajektorien Berechnung eines Basketballwurfs mit Luftwiderstand
% Input:  initX .... Abwurfentfernung vom Mittelpunkt des Korbs
%         initY .... Abwurfhöhe
%         initAng .. Abwurfwinkel
%         initVel .. Abwurfgeschwindigkeit
%         daempf ... Daempfung
% Output: TrajPkte . 2-zeilige Matrix aller Punkte die der Ball beim Wurf
%                    durchlaueft
%         luftG .... Luftgeschwindigkeit (kann bis Aufgabe 5 gleich 0
%                    gesetzt bleiben)

%Luftgeschwindigkeit zufällig
luftG = (-2 + (2+2)*rand(1,1));

%Anzahl Punkte
n = 100; 

x = zeros(2,n);
v = zeros(2,n);
a = zeros(2,n);

%Anfangsbedigungen Ort- und Geschwindigkeitsspaltenvektor
x(:,1) = [initX; initY];
v(:,1) = [initVel * cos(initAng); initVel * sin(initAng)];

delta_t = zeros(1,n);
delta_t(1) = 0.1; %Schrittweite (0.1, 0.01, 0.001)

delta = zeros(1,n);

i = 1;

while (x(2,i) > 0) && (i < n)

    [x, v, delta_t, delta] = swapLW(x, v, a, delta_t, delta, i, luftG);

i = i+1;

end

TrajPkte = x(:,(1:i));

end