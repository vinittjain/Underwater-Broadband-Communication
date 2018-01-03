function [prop_const]=thorp_model(fmax)
 
f=(1:1:fmax)/1000;
prop_const=(0.11*(f.*f)./(1+f.*f))+(44*(f.*f)./(4100+f.*f))+2.75*10.^(-4)*f.*f+0.003;
 
end
