input_file1='input/stresses_horiz_profile.txt';
output_file1='output/eqks_horiz_profile.txt';

ts=1:10:1e4; %time steps (days)
t0=1e-5; %start time 
r0=0.2; %background seismicity rate, days^-1 
asig=10; %kPa (as in input files)
ta=1e3; %aftershock decay time (days)

[rate1 nt1 pos1] = coulomb2forecast(input_file1, ts, t0, ...
		[r0 asig ta], output_file2);

figure
subplot(1,2,1)
loglog(ts,mean(rate1));
hold on
plot(ts([1 end]), r0*[1 1])
xlabel('Days since mainshock')
ylabel('Seismicity rate (earthquakes/day)')

subplot(1,2,2)
scatter(pos1.lon, pos1.lat, 30, sum(nt1'))
xlabel('longitude'); 
ylabel('latitude')
title('Total number of events')


