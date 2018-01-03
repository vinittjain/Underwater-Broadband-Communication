function [prop_const]=fisher_simmons_model(fmax)
ph = 4;
S = 35;                                                                         % Salinity of water
d = 1000;                                                                     % depth of measurement
T = 10;                                                                        % temperature in degress celsius
c = 1412 + 3.21*T + 1.19*S + 0.0167*d;                   % speed of sound in m/s
t = 273 + T;
 
A1 = (8.86/c)*10^(0.78*ph - 5);                                 % Coefficients for the Equation
A2 = 21.44*(S/c)*(1 + 0.025*T);
A3 = 4.937*10^(-4) - 2.59*10^(-5)*T + 9.11*10^(-7)*T*T - 1.5*10^(-8)*T*T*T;
f1 = 2.8*sqrt(S/35)*10^( 4- 1245/t);
f2 = (8.17*10^(8-1990/t))/(1 + 0.0018*(S-35));
P1 = 1;
P2 = 1 - 1.37*(10^-4)*d + 6.2*(10^-9)*d*d;
P3 = 1 - 3.84*(10^-5)*d + 4.9*(10^-10)*d*d;
 
 
f=(1:1:fmax)/1000;
 
prop_const = (A1*P1*f1*f.*f)./(f1*f1 + f.*f) + (A2*P2*f2*f.*f)./(f2*f2 + f.*f) + A3*P3*f.*f;
 
end
