function [TrajPkte,luftG] = expEulLW(initX,initY,initAng,initVel,daempf)
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
luftG = (-2 + (2+2) * rand(1,1));

%Anzahl Punkte
n = 100; 

x = zeros(2,n);
v = zeros(2,n);
a = zeros(2,n);

g = [0 -9.81]';

%Anfangsbedigungen Ort- und Geschwindigkeitsspaltenvektor
x(:,1) = [initX; initY];
v(:,1) = [initVel * cos(initAng); initVel * sin(initAng)];

delta_t = 0.1; %Schrittweite (0.1, 0.01, 0.001)

i = 1;

%Luftwiderstand
p  = 1.21; %Luftdichte [kg/m^3]
C_L = 0.45; %Widerstrandskonstante
A = 0.04; %Querschnittsfläche des Balles [m^2]

%Resultierende Beschleunigung mit Newton's zweitem Gesetz:
m = 0.6; %Masse des Balles [kg]

    i = 1;

    while (x(2,i) > 0) && (i < n)

    z = sign(v(:,i) - [luftG; 0]) %Vorzeichen rel. Luftgeschwind.

    x(:,i+1) = x(:,i) + delta_t .* v(:,i);
    a(:,i+1) = (0.5 .* p .* (v(:,i) - [luftG; 0]).^2 .* C_L .* A) ./ m;
    v(:,i+1) = v(:,i) + delta_t .* (g - z .* a(:,i+1));
    i = i+1; 

    end

TrajPkte = x(:,(1:i));

end