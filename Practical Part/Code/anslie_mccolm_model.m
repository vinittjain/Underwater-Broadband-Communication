function[prop_const]=anslie_mccolm_model(fmax)
 
ph=8;                                                                           % ph value
s=35;                                                                           % Salinity in parts per trillion
d=1000;                                                                       % Depth in m
temp=10;                                                                     %Temperature in C
f=(1:1:fmax)/1000;
 
f1=0.78*sqrt(s/35)*exp(temp/26);
f2=42*exp(temp/17);
prop_const=(0.106*((f1*f.*f)./(f1*f1+f.*f))*exp((ph-8)/0.56)+.52*(1+temp/43)*(s/35)*((f2*f.*f)./(f2*f2+f.*f))*exp(-d/6)+4.9*10^(-4)*f.*f*exp(-(temp/27+d/17)));
 
end
