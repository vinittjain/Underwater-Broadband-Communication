function [noise]=ambient_noise(fmax)
 
f=(1:1:fmax)/1000;
sh=2;                                                                            % Shipping factor
w=25;                                                                           % Wind Speed
 
% Noise calculation for individual noise
 
Turbulence_noise = 10.^((17 - 30*log10(f))./20);
Shipping_noise = 10.^((40 + 20*(sh - 0.5) + 26*log10(f) - 60*log10(f + 0.3))./20);
Winddriven_noise = 10.^((50 + 7.5*sqrt(w) + 20*log10(f) - 40*log10(f+0.4))./20);
Thermal_noise = 10.^((-15 + 20*log10(f))./20);
 
noise=Turbulence_noise+Shipping_noise+Winddriven_noise+Thermal_noise;
 
end
