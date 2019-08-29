% M-File to estimate the channel and to develop the bit loading profile
 
clc;
clear all;
close all;
 
% Inputs from user
 
pow = input('Enter the total power of the signal to be transmitted: ');
l(1)=input(' enter the length to be considered in Km : '); 
margin= input('enter the margin to be given in dB: ');
gapfactordb=9.8+margin;
disp('taking a bit error tolerance of 10^(-6) and no coding gain the gap factor in dB is: ');
disp(gapfactordb); 
 
%Define the properties of the transmitter.
 
tsym=3.333333333333334e-05                                                 %symbol duration to make df=1875;
rsym=1/tsym;                                                           %symbol rate
N=16;                                                                       %Number of parallel symbols
tnew=N*tsym;                                                          %new symbol duration = 800 micro seconds
rnew=1/tnew;
df=rnew;                                                                   %frequency spacing   
 
%frequency values for the sixteen tones
 
fval=zeros([1 16]);
for i=1:16
    fval(i)=1875+(i-1)*df;
    fval(i)=floor(fval(i));
end

% QPSK Modulation of the bit pattern generated above
% 64 tones in total, inter-tone spacing of 500 Hz
seq = randi([0 1],32,1);                                            % Random 32 bit sequence  - 16 tones in the 20KHz channel
mod = modem.pskmod(4,pi/4);
mod.inputtype = 'bit';
mod.SymbolOrder = 'gray';
q = modulate(mod,seq);
%figure(3)
disp(q);
 
% IFFT Definition

Fs = 120000;                                                               %so that the 20k component of freq exists.
T = 1/Fs; 
L = 120000;                    
t = (0:L-1)*T;
freqdom=zeros([1 120000]);
q = [q;flipud(conj(q))];                                             %complex conjugate of the signals added to fft
input('Press Enter to view the inputs to the IFFT block');
disp('Input to the IFFT Block');
%figure(1)
disp(q);
 
for i = 1:16
    freqdom(fval(i)) = q(i);
    freqdom(120000-fval(i)) = q(33-i);
end
 
% Displaying the transmitted signal 
%figure(2)
subplot(2,3,1);
plot(abs(freqdom(1:30000)));                                   %display only upto 30k
hold on;
xlabel('Frequency - Hz');
ylabel('Tone Amplitude in Watt');
title('Multi-Tone Structure Transmitted - Frequency Domain');
grid on; 
freqdom1 = freqdom.*60000;                                     %according to ifft definiton
realsig = ifft(freqdom1);
% Channel and Noise estimation

k=1.5;                                                                          % Spreading factor
fmax = 30500;                                                             % Maximum value of frequency required for calculation 
 noise = ambient_noise(fmax);                                     % Function call to calculate noise
 
% Use any one of the three channel models and comment the other two

prop_const=thorp_model(fmax);                                               
%prop_const=fisher_simmons_model(fmax);
%prop_const=anslie_mccolm_model(fmax);
 
% Calculation of attenuation

L=l(1);
AdB1 = (k*10*log10(L) + L*prop_const);
C1=AdB1./10;
A1=10.^(C1); 
 
% Calculating the effect of channel on the signal in frequency domain
 
freqdom_2(1:30000)=freqdom(1:30000)./A1(1:30000);
subplot(2,3,2);
plot(abs(freqdom_2)); 
xlabel('Frequency - Hz');
ylabel('Tone Amplitude in Watt');
title('Multi-Tone Structure at Receiver - Frequency Domain');
grid on; 
% Convertion of power to voltage and then to dBreuPa %

pow = pow/16;                                                             % Dividing the power in all tones equally 
imp = 2870;                                                                  % Refer data sheets for impedance value 
volts= sqrt (pow * imp);
convert = 31.6e6;                                                          % standard for sound projectors 
gapfactor = 10^(gapfactordb/20);
noise1= zeros(1,16);
 
% SNR and CbyB calculation
 
SNR=zeros(1,16);
CbyB=zeros(1,16);
 
for G=1:16       
    
    Signal_power_dbreupa= volts * convert;
 
        for i=(G*1875)-500:1:(G*1875)+500; 
                                                                 
            noise1(G) = noise1(G) + A1(i)*noise(i);         %Integrating the noise
        end
   
SNR(G)=(Signal_power_dbreupa/(noise1(G)))^2;
 
CbyB(G)=(log2(1+(SNR(G)/gapfactor)));
 
SNR(G)= 10 * log10(SNR(G));
 
end
 
subplot(2,3,4);
stem(SNR);
xlabel('TONE NUMBER');
ylabel('SNR in dB');
title(' SNR Profile');
grid on; 
subplot(2,3,5);
stem(CbyB);
xlabel('TONE NUMBER');
ylabel('C/B in bits/Hz');
title(' C/B Profile');
grid on; 
% Rounding off by calling the equalize function by using any one of the functions and comment the other two
 
%CbyB_round = equalize_1(CbyB');                          % ADOPT algorithm
CbyB_round = equalize_2(CbyB');                              % Mean Offset algorithm
%CbyB_round = equalize_3(CbyB');                           % Re-Adopt algorithm
 
subplot(2,3,6);
stem(CbyB_round);
xlabel('TONE NUMBER');
ylabel('C/B bits/Hz');
title(' C/B Profile after Rounding off');
grid on; 
% Recalculation of Power and plotting it
 
pow_tones=pow*((2.^(CbyB_round))-1)./((2.^(CbyB'))-1);
subplot(2,3,3);
stem(pow_tones);
xlabel('TONE NUMBER');
ylabel('POWER in Watt');
title(' PSD AFTER ROUNDING');
grid on;
