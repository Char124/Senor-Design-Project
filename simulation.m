%Constants from the papers
b = 0.0615;
TN = 25; %in Celsius
EiN = 1000; %W/m^2
Voc = 5.0;
Isc = 0.35;
V_max = 1.03 * Voc;
V_min = 0.85 * Voc;
TCv = -6e-3*2;
TCi = 1e-4;

%We can change this values later this is for a test to make sure its
%working
T = 25;
p = 1;
s = 1;


%PV Model
V = 0:0.001:5;
irr = [200 600 1000];
I_all = zeros(numel(irr), numel(V));
P_all = zeros(numel(irr), numel(V));
Pmax = zeros(1, numel(irr));
Vop = zeros(1, numel(irr));
Iop = zeros (1, numel(irr));

for k = 1:numel(irr)
    Ei = irr(k);
    Ix = (Ei/EiN) * (Isc + TCi * (T - TN));
    Vx = (Ei/EiN) * TCv * (T - TN) + V_max - (V_max - V_min) * exp((Ei/EiN) * log((V_max - Voc) / (V_max - V_min)));
    I = max(p * Ix / (1 - exp(-1/b)) * (1 - exp(V ./ (s*b*Vx) - 1/b)), 0);
    P = V .* I;
    I_all(k,:) = I;
    P_all(k,:) = P;
    [Pmax(k), idx] = max(P);
    Vop(k) = V(idx);
    Iop(k) = I(idx);
end

disp([irr' Vop' Iop' Pmax'])

subplot(2,1,1)
plot(V,I_all);
title('I-V Curve');
xlabel ('Voltage');
ylabel ('Current')
legend ('200 W/m^2', '600 W/m^2', '1000W/m^2', 'Location','southwest');
hold on
plot(Vop, Iop, 'o');
grid on

subplot(2,1,2)
plot(V, P_all);
title ('P-V Curve');
xlabel ('Voltage');
ylabel ('Power (W)');
legend ('200 W/m^2', '600 W/m^2', '1000W/m^2' , 'Location', 'northwest');
hold on
plot(Vop, Pmax, 'o');
grid on