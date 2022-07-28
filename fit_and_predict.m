function [rate ntot ts asig ta r0 inv] = fit_and_predict(cat, input_file, t0, tnow, tend, asig0, ta0, dt);
%function [rate ntot ts asig ta r0 inv] = fit_and_predict(cat, inputfile, t0, tnow, tend, [asig0=10kPa], [ta=1e4 days], [dt=1day]);

if exist('asig0')~=1 asig0=1e4; end
if exist('ta0')~=1 ta0=1e4; end
if exist('dt')~=1 dt=1; end

asig0=[0.01 100]*asig0;
ta0=[0.01 100]*ta0;

[~, ~, ~, cmb] = loadinput(input_file);

[asig ta r0 inv] = ll_inversion(cat, cmb, t0, tnow, asig0, ta0);

ts=tnow:dt:tend;

for n=1:length(cmb)
   [r, c] = d94(ts, tnow, [t0 asig ta], cmb(n));
   rate(n,:) = r;
   ntot(n,:) = c;
end

