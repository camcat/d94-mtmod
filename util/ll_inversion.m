function [asig, ta, r0, inv] = ll_inversion(cat, cmb, tstart, tend, asig0, ta0, nsteps, verbose);
%function [asig, ta, r0, inv] = ll_inversion(cat, cmb, tstart, tend, [asig0=1kPa], [ta0=1e4 days], [mode='grid'], [nsteps=25], [verbose=0]);
%Estimates optimal values of rate-state parameters asig, ta by mimimizing log-likelihood with respect to observed seismicity. Only the temporal component of the forecast is considered.
%
% Inputs: 
%   cat=[t1 t2 t3]... earthquake times.
%   cmb= Coulomb stress changes for the region of interest at t=0.
%   tstart, tend = start and end time of the inversion.
%   asig0, ta0 = ranges of values; will split the interval into N=nsteps steps in log space.
%
% Output:
%   asig = a*sigma, where a=rate-state parameter for direct effect, sigma=effective normal stress
%   ta = aftershock decay time in Dieterich, 1994.
%   r0= background seismicity rate.
%   inv = inversion results (only if mode='grid'). Contains asigs, tas, LL values.

if exist('asig0')~=1 asig0=[0.01 100]*10; end
if exist('ta0')~=1  ta0=[0.01 100]*100; end
if exist('mode')~=1 mode='grid'; end
if exist('nsteps')~=1 nsteps=12; end
if exist('verbose')~=1 verbose=1; end

disp('Log-likelihood inversion with following parameters:');
disp(['asig in range: [' num2str(asig0(1)) ' ' num2str(asig0(2)) ']']);
disp(['ta in range: [' num2str(ta0(1)) ' ' num2str(ta0(2)) ']']);
disp(['Taking ' num2str(nsteps) ' steps'])

isin=cat>=tstart & cat<=tend;
cat=cat(isin);

llmax=-inf;
step=(log10(asig0(2))-log10(asig0(1)))/nsteps;
asigs=10.^[log10(asig0(1)):step:log10(asig0(2))];
step=(log10(ta0(2))-log10(ta0(1)))/nsteps;
tas=10.^[log10(ta0(1)):step:log10(ta0(2))];

for i=1:length(asigs); 
   for j=1:length(tas)
       [~,nt]=d94(tend, tstart,[1 asigs(i) tas(j)], cmb);
       r0i=length(cat)/nt; 
       ll(i,j)=loglikelihood([r0i asigs(i) tas(j)], cat, tstart, tend, cmb, verbose);
 if (ll(i,j))>llmax
	   llmax=ll(i,j);
         asig=asigs(i);
         ta=tas(j);
         r0=r0i;
       end
   end
end

disp(['Optimal parameters: asigma=' num2str(asig) ...
                             ', ta=' num2str(ta), ...
                             ', r0=', num2str(r0)]);

inv.asigs=asigs;
inv.tas=tas;
inv.ll=ll;


