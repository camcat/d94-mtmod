%input_file='~/code/ESPy_Demo/Outputs/my_experiment/stresses_horiz_profile.txt';
input_file='~/code/ESPy_Demo/Outputs/my_experiment/stresses_full.txt';

%Load cmb stress changes:
dt=0.5;
ts=1e-5:dt:300;

r0=0.1;
asig=1; %kPa
ta=1e4;

%Forward simulation:
[rate, ntot] = coulomb2forecast(input_file, ts, ts(1), [r0 asig ta]);
[~, ~, ~, cmb] = loadinput(input_file);

rate=sum(rate);
ntot=sum(ntot);

cat=[];
%Add events:
for n=2:length(ts)
  eqks=ts(n)-rand(int32(ntot(n)-ntot(n-1)),1)*dt; 
  cat=[cat; eqks];
end

cat=sort(cat);

[rate2 ntot2 ts2 asigi tai r0i inv] = fit_and_predict(cat, input_file, ts(1), ts(end), ts(end)*2, asig, ta);

figure
imagesc(log10(inv.asigs), log10(inv.tas), inv.ll'); 
shading flat
caxis([-0.1 0]*1e6+max(max(inv.ll)));
hold on
plot(log10(asig),log10(ta),'xk');

title('log-likelihood');
xlabel('log10(asigma)')
ylabel('log10(ta)')


