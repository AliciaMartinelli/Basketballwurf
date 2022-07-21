function [x, v, delta_t, delta] = swapLW(x, v, a, delta_t, delta, i, luftG)

tau = 0.8;
epsilon = 10^(-3);

delta(1) = tau^3 * epsilon;

delta_t(i+1) = delta_t(i);
delta(i+1) = delta(i);

g = [0 -9.81]';

gamma = [0.5,0.5,0];
gamma_tilde = [1/6,1/6,4/6];
gammas = gamma - gamma_tilde;

%Luftwiderstand
p  = 1.21; %Luftdichte [kg/m^3]
C_L = 0.45; %Widerstrandskonstante
A = 0.04; %Querschnittsfläche des Balles [m^2]

%Resultierende Beschleunigung mit Newton's zweitem Gesetz:
m = 0.6; %Masse des Balles [kg]


while 1
    delta_t(i+1) = tau * (epsilon / delta(i+1))^(1/3) * delta_t(i+1);

    k1x = v(:,i);
    k2x = v(:,i) + delta_t(i+1) .* k1x;
    k3x = v(:,i) + (delta_t(i+1)/4) .* k1x + (delta_t(i+1)/4) .* k2x;

    a(:,i+1) = (0.5 .* p .* (v(:,i) - [luftG; 0]).^2 .* C_L .* A) ./ m;
    z1 = sign(v(:,i) - [luftG; 0]);
    k1v = g - z1 .* a(:,i+1);
   
    a(:,i+1) = (0.5 .* p .* (v(:,i) - [luftG; 0]).^2 .* C_L .* A) ./ m;
    z2 = sign((v(:,i) + delta_t(i+1) * k1v) - [luftG; 0]);
    k2v = g - z2 .* a(:,i+1);

    a(:,i+1) = (0.5 .* p .* (v(:,i) - [luftG; 0]).^2 .* C_L .* A) ./ m;
    z3 = sign((v(:,i) + (delta_t(i+1)/4) * k1v + (delta_t(i+1)/4) * k2v) - [luftG; 0]);
    k3v = g - z3 .* a(:,i+1);

    delta(i+1) = delta_t(i+1) .* norm(gammas(1) .* [k1x; k1v] + gammas(2) .* [k2x; k2v] + gammas(3) .* [k3x; k3v]);
    disp(delta_t(i+1)); %While do Schleife
    if delta(i+1) <= epsilon
        break;
    end
end

x(:,i+1) = x(:,i) + 0.5 * delta_t(i+1) .* k1x + 0.5 * delta_t(i+1) .* k2x;
a(:,i+1) = (0.5 .* p .* (v(:,i) - [luftG; 0]).^2 .* C_L .* A) ./ m;
v(:,i+1) = v(:,i) + 0.5 * delta_t(i+1) .* k1v + 0.5 * delta_t(i+1) .* k2v;

end