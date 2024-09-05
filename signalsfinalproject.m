%step(1)
clc;
clear all;
close all;

[x,fs] = audioread('sound.mp3'); %importing sound file
x = x( [20*fs:40*fs] , : ); %trim audio from seconds (20s to 40s)
% sound(x,fs); %playing sound
time_final = length(x)./fs; %total sound duration
t = linspace(0,time_final,time_final.*fs); %generating samples for time domain representation

figure; 
subplot(3,1,1);
plot(t,x,'r');
ylim([-2 2]);
grid on;
title('Original Audio Signal In Time Domain');

leftshift = x(:,1); %left speaker sound signal
rightshift = x(:,2); %right speaker sound signal

x = fftshift(fft(x)); %transform sound signal to frequency domain with mirror shift arround zero
x_magnitude = abs(x)./fs; 
x_phase = angle(x); %phase spectrum of the frequency domain

fvec = linspace(-fs/2 , fs/2 , length(x)); %generating samples for frequency domain representation

subplot(3,1,2);
plot(fvec,x_magnitude,'b');
grid on;
title('Original Audio Signal''s Magnitude In Frequency Domain');

subplot(3,1,3);
plot(fvec,x_phase,'b');
grid on;
title('Original Audio Signal''s Phase In Frequency Domain');

%step(2)
fprintf('Enter Order Of The Impulse Response You Want:\n-Enter ''1'' for h1\n-Enter ''2'' for h2\n-Enter ''3'' for h3\n-Enter ''4'' for h4');
h = input('\nOrder Of The Desired Impulse Response = '); %select desired order of impulse response

while (h<1 || h>4)
    fprintf('Invalid Input!\nPlease Enter a Valid Number From ''1'' to ''4''');
    h = input('\nOrder Of The Desired Impulse Response = ');
end

if (h==1)
    h1 = [1 zeros(1,length(x)-1)];
    z = fftshift(fft(h1));
    c = linspace(-fs/2,fs/2,length(z));
   
    figure;
    plot(c,z,'b');
    grid on;
    title('The Transfer Function ''H1'' '); %plot h1 in frequency domain
    
    L = conv(leftshift,h1);
    R = conv(rightshift,h1);
    L=L(1:length(x));
    R=R(1:length(x));
    time_final = length(L)./fs; %total sound duration
    time_conv = linspace(0,time_final,fs*time_final); %generating samples for time in impulse response h1
    tot_signal = [L;R]; %total output of sound signal convoluted with h1
    time_total = length(tot_signal)./fs; %total sound duration
    time_convt = linspace(0,time_total,fs*time_total); %generating samples for time in impulse response h1
    
    figure;
    subplot(3,1,1);
    plot(time_conv,L,'y');
    grid on;
    title('signal (left speaker) in time domain after applying impulse response = delta function');
    
    subplot(3,1,2);
    plot(time_conv,R,'y');
    grid on;
    title('signal (right speaker) in time domain after applying impulse response = delta function');
    
    subplot(3,1,3);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('signal in time domain after applying impulse response = delta function');
    
    L = fftshift(fft(L));
    R = fftshift(fft(R));
    tot_signal_f = [L;R];
    L_magnitude = abs(L)./fs;
    R_magnitude = abs(R)./fs;
    L_phase = angle(L);
    R_phase = angle(R);
    t_magnitude = abs(tot_signal_f)./fs; %total magnitude of signal in frequency domain
    t_phase = angle(tot_signal_f);
    
    fvec1 = linspace(-fs/2,fs/2,length(L_magnitude));
    fvec2 = linspace(-fs/2,fs/2,length(R_magnitude));
    fvec3 = linspace(-fs/2,fs/2,length(t_magnitude));
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_magnitude,'g');
    grid on;
    title('signal (left speaker) magnitude in frequency domain after applying impulse response = delta function');
    
    subplot(3,1,2);
    plot(fvec2,R_magnitude,'g');
    grid on;
    title('signal(right speaker) magnitude in frequency domain after applying impulse response = delta function');
    
    subplot(3,1,3);
    plot(fvec3,t_magnitude,'b');
    grid on;
    title('signal magnitude in frequency domain after applying impulse response=delta function');
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_phase,'g');
    grid on;
    title('signal phase (left speaker) in frequency domain after applying impulse response = delta function)');
    
    subplot(3,1,2);
    plot(fvec2,R_phase,'g');
    grid on;
    title('signal phase (right speaker) in frequency domain after applying impulse response = delta function');
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    grid on;
    title('signal phase in frequency domain after applying impulse response = delta function');
    
    figure; %output signal
    subplot(3,1,1);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('Output Audio Signal In Time Domain');
    
    subplot(3,1,2);
    plot(fvec3,t_magnitude,'b');
    title('Output Audio Signal''s Magnitude In Frequency Domain');
    grid on;
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    title('Output Audio Signal''s Phase In Frequency Domain');
    grid on;

elseif (h==2)
    h2 = exp(-2*pi*5000*t);
    z = fftshift(fft(h2));
    c = linspace(-fs/2,fs/2,length(z));
     
    figure;
    plot(c,z,'b');
    grid on;
    title('The Transfer Function ''H2'' '); %plot h2 in frequency domain
    
    L = conv(leftshift,h2);
    R = conv(rightshift,h2);
    L=L(1:length(x));
    R=R(1:length(x));
    time_final = length(L)./fs;
    time_conv = linspace(0,time_final,fs*time_final);
    tot_signal = [L;R];
    time_total = length(tot_signal)./fs;
    time_convt = linspace(0,time_total,fs*time_total);
    
    figure;
    subplot(3,1,1);
    plot(time_conv,L,'y');
    title('signal (left speaker) in time domain after applying impulse response = exp(-2*pi*5000*t)');
    
    subplot(3,1,2);
    plot(time_conv,R,'y');
    title('signal (right speaker) in time domain after applying impulse response = exp(-2*pi*5000*t)');
    
    subplot(3,1,3);
    plot(time_convt,tot_signal,'r');
    title('signal in time domain after applying impulse response=exp(-2*pi*5000*t)');
    
    L = fftshift(fft(L));
    R = fftshift(fft(R));
    tot_signal_f = [L;R];
    L_magnitude = abs(L)./fs;
    R_magnitude = abs(R)./fs;
    L_phase = angle(L);
    R_phase = angle(R);
    t_magnitude = abs(tot_signal_f)./fs;
    t_phase = angle(tot_signal_f);
    
    fvec1 = linspace(-fs/2,fs/2,length(L_magnitude));
    fvec2 = linspace(-fs/2,fs/2,length(R_magnitude));
    fvec3 = linspace(-fs/2,fs/2,length(t_magnitude));
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_magnitude,'g');
    title('signal(left speaker) magnitude in frequency domain after applying impulse response=exp(-2*pi*5000*t)');
    
    subplot(3,1,2);
    plot(fvec2,R_magnitude,'g');
    title('signal(right speaker) magnitude in frequency domain after applying impulse response=exp(-2*pi*5000*t)');
    
    subplot(3,1,3);
    plot(fvec3,t_magnitude,'b');
    title('signal magnitude in frequency domain after applying impulse response=exp(-2*pi*5000*t)');
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_phase,'g');
    title('signal phase(left speaker) in frequency domain after applying impulse response=exp(-2*pi*5000*t)');
    
    subplot(3,1,2);
    plot(fvec2,R_phase,'g');
    title('signal phase(right speaker) in frequency domain after applying impulse response=exp(-2*pi*5000*t)');
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    title('signal phase in frequency domain after applying impulse response=exp(-2*pi*5000*t)');
    
    figure; %output signal
    subplot(3,1,1);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('Output Audio Signal In Time Domain');
    
    subplot(3,1,2);
    plot(fvec3,t_magnitude,'b');
    title('Output Audio Signal''s Magnitude In Frequency Domain');
    grid on;
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    title('Output Audio Signal''s Phase In Frequency Domain');
    grid on;

elseif (h==3)
    h3 = exp(-2*pi*1000*t);
    z = fftshift(fft(h3));
    c = linspace(-fs/2,fs/2,length(z));
    
    figure;
    plot(c,z,'b');
    grid on;
    title('The Transfer Function ''H3'' '); %plot h3 in frequency domain
    
    L = conv(leftshift,h3);
    R = conv(rightshift,h3);
    L=L(1:length(x));
    R=R(1:length(x));
    time_final = length(L)./fs;
    time_conv = linspace(0,time_final,fs*time_final);
    tot_signal = [L;R];
    time_total = length(tot_signal)./fs;
    time_convt = linspace(0,time_total,fs*time_total);
    
    figure;
    subplot(3,1,1);
    plot(time_conv,L,'y');
    grid on;
    title('signal (left speaker) in time domain after applying impulse response = exp(-2*pi*1000*t)');
    
    subplot(3,1,2);
    plot(time_conv,R,'y');
    grid on;
    title('signal (right speaker) in time domain after applying impulse response = exp(-2*pi*1000*t)');
    
    subplot(3,1,3);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('signal in time domain after applying impulse response = exp(-2*pi*1000*t)');
    
    L=fftshift(fft(L));
    R=fftshift(fft(R));
    tot_signal_f = [L;R];
    L_magnitude = abs(L)./fs;
    R_magnitude = abs(R)./fs;
    L_phase = angle(L);
    R_phase = angle(R);
    t_magnitude = abs(tot_signal_f)./fs;
    t_phase = angle(tot_signal_f);
    
    fvec1 = linspace(-fs/2,fs/2,length(L_magnitude));
    fvec2 = linspace(-fs/2,fs/2,length(R_magnitude));
    fvec3 = linspace(-fs/2,fs/2,length(t_magnitude));
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_magnitude,'g');
    grid on;
    title('signal (left speaker) magnitude in frequency domain after applying impulse response = exp(-2*pi*1000*t)');
    
    subplot(3,1,2);
    plot(fvec2,R_magnitude,'g');
    grid on;
    title('signal (right speaker) magnitude in frequency domain after applying impulse response = exp(-2*pi*1000*t)');
    
    subplot(3,1,3);
    plot(fvec3,t_magnitude,'b');
    grid on;
    title('signal magnitude in frequency domain after applying impulse response = exp(-2*pi*1000*t)');
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_phase,'g');
    grid on;
    title('signal phase (left speaker) in frequency domain after applying impulse response = exp(-2*pi*1000*t)');
    
    subplot(3,1,2);
    plot(fvec2,R_phase,'g');
    grid on;
    title('signal phase (right speaker) in frequency domain after applying impulse response = exp(-2*pi*1000*t)');
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    grid on;
    title('signal phase in frequency domain after applying impulse response = exp(-2*pi*1000*t)');
    
    figure; %output signal
    subplot(3,1,1);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('Output Audio Signal In Time Domain');
    
    subplot(3,1,2);
    plot(fvec3,t_magnitude,'b');
    title('Output Audio Signal''s Magnitude In Frequency Domain');
    grid on;
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    title('Output Audio Signal''s Phase In Frequency Domain');
    grid on;

elseif (h==4)
    h4 = [2 zeros(1,length(x)) 0.5 zeros(1,length(x))];
    z = fftshift(fft(h4));
    c = linspace(-fs/2,fs/2,length(z));
    
    figure;
    plot(c,z,'b');
    grid on;
    title('The Transfer Function ''H4'' '); %plot h4 in frequency domain

    L = conv(leftshift,h4);
    R = conv(rightshift,h4);
    L=L(1:2*length(x));
    R=R(1:2*length(x));
    time_final = length(L)./fs;
    time_conv = linspace(0,time_final,fs*time_final);
    tot_signal = [L;R];
    time_total = length(tot_signal)./fs;
    time_convt = linspace(0,time_total,fs*time_total);
    
    figure;
    subplot(3,1,1);
    plot(time_conv,L,'y');
    grid on;
    title('signal (left speaker) in time domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    subplot(3,1,2);
    plot(time_conv,R,'y');
    grid on;
    title('signal (right speaker) in time domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    subplot(3,1,3);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('signal in time domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    L = fftshift(fft(L));
    R = fftshift(fft(R));
    tot_signal_f = [L;R];
    L_magnitude = abs(L)./fs;
    R_magnitude = abs(R)./fs;
    L_phase = angle(L);
    R_phase = angle(R);
    t_magnitude = abs(tot_signal_f)./fs;
    t_phase = angle(tot_signal_f);
    
    fvec1 = linspace(-fs/2,fs/2,length(L_magnitude));
    fvec2 = linspace(-fs/2,fs/2,length(R_magnitude));
    fvec3 = linspace(-fs/2,fs/2,length(t_magnitude));
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_magnitude,'g');
    grid on;
    title('signal (left speaker) magnitude in frequency domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    subplot(3,1,2);
    plot(fvec2,R_magnitude,'g');
    grid on;
    title('signal (right speaker) magnitude in frequency domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    subplot(3,1,3);
    plot(fvec3,t_magnitude,'b');
    grid on;
    title('signal magnitude in frequency domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    figure;
    subplot(3,1,1);
    plot(fvec1,L_phase,'g');
    grid on;
    title('signal phase (left speaker) in frequency domain after applying impulse response = 2*delta(n)+delta(n-1)');
    
    subplot(3,1,2);
    plot(fvec2,R_phase,'g');
    grid on;
    title('signal phase (right speaker) in frequency domain after applying impulse response = 2*delta(n)+delta(n-1))');
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    grid on;
    title('signal phase in frequency domain after applying impulse response = 2*delta(n)+delta(n-1)'); 
    
    figure; %output signal
    subplot(3,1,1);
    plot(time_convt,tot_signal,'r');
    grid on;
    title('Output Audio Signal In Time Domain');
    
    subplot(3,1,2);
    plot(fvec3,t_magnitude,'b');
    title('Output Audio Signal''s Magnitude In Frequency Domain');
    grid on;
    
    subplot(3,1,3);
    plot(fvec3,t_phase,'b');
    title('Output Audio Signal''s Phase In Frequency Domain');
    grid on;
end

% sound(tot_signal,fs);
    
%step(3)
sigma = input('Enter The Value Of Standard Deviation (sigma) For The Added noise: '); %define standard deviation of the noise

noise = sigma * randn( 1 , length(tot_signal) ); %generate the noise signal

noisy_signal = tot_signal + noise; %adding noise to the output signal of the channel

figure; %plotting the output noisy signal 
subplot(3,1,1);
plot(time_convt,noisy_signal,'r');
grid on;
title('Output Noisy Audio Signal In Time Domain');
    
subplot(3,1,2);
plot(fvec3,abs(fftshift(fft(noisy_signal))),'b');
title('Output Noisy Audio Signal''s Magnitude In Frequency Domain');
grid on;
    
subplot(3,1,3);
plot(fvec3,angle(fftshift(fft(noisy_signal))),'b');
title('Output Noisy Audio Signal''s Phase In Frequency Domain');
grid on;

sound(noisy_signal,fs); %play noisy signal
pause(25);

%step 4
noisy_signal_f=(fftshift(fft(noisy_signal)));
NperHz= round((length(noisy_signal)/fs))*(fs/2-3400);
noisy_signal_f(:,[1:(NperHz) (length(noisy_signal_f)-(NperHz)+1):length(noisy_signal_f)])=0;
noisy_mag=abs(noisy_signal_f);
noisy_phase=angle(noisy_signal_f);
fvec3=linspace(-fs/2,fs/2,length(noisy_signal_f));

figure;
subplot(2,1,1);
plot(fvec3,noisy_mag)
title('Final output magnitude after applying low pass filter in Frequency Domain');
subplot(2,1,2);
plot(fvec3,noisy_phase)
title('Final output angle after applying low pass filter in Frequency Domain');
grid on;

finalsound= real(ifft(noisy_signal_f));
time_final = length(finalsound)./fs;
time= linspace(0,time_final,fs*time_final);
sound(finalsound,fs) %play noisy signal
figure;
plot(time_convt,finalsound, 'x')
title('Final output after applying low pass filter in Time Domain');



