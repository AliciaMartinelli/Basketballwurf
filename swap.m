function [x, v, delta_t, delta] = swap(x, v, delta_t, delta, i)

tau = 0.8;
epsilon = 10^(-3);

delta(1) = tau^3 * epsilon;

delta_t(i+1) = delta_t(i);
delta(i+1) = delta(i);

a = [0 -9.81]';

gamma = [0.5,0.5,0];
gamma_tilde = [1/6,1/6,4/6];

gammas = gamma - gamma_tilde;

while 1
    delta_t(i+1) = tau * (epsilon / delta(i+1))^(1/3) * delta_t(i+1);
    
    k1x = v(:,i);
    k2x = v(:,i) + delta_t(i+1) .* k1x;
    k3x = v(:,i) + (delta_t(i+1)/4) .* k1x + (delta_t(i + 1)/4) .* k2x;

    k1v = a;
    k2v = a;
    k3v = a;

    delta(i+1) = delta_t(i+1) .* norm(gammas(1) .* [k1x; k1v] + gammas(2) .* [k2x; k2v] + gammas(3) .* [k3x; k3v]);
    
    disp(delta_t(i+1)); %While do Schleife
    if delta(i+1) <= epsilon
        break;
    end
end

x(:,i+1) = x(:,i) + 0.5 * delta_t(i+1) .* k1x + 0.5 * delta_t(i+1) .* k2x;
v(:,i+1) = v(:,i) + 0.5 * delta_t(i+1) .* k1v + 0.5 * delta_t(i+1) .* k2v;

end