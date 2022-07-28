function [asig, ta, r0, inv] = ll_inversion(cat, cmb, tstart, tend, asig0, ta0, mode, nsteps, verbose);
%function [asig, ta, r0, inv] = ll_inversion(cat, cmb, tstart, tend, [asig0=1kPa], [ta0=1e4 days], [mode='grid'], [nsteps=25], [verbose=0]);
%Estimates optimal values of rate-state parameters asig, ta by mimimizing log-likelihood with respect to observed seismicity. Only the temporal component of the forecast is considered.
%
% Inputs: 
%   cat=[t1 t2 t3]... earthquake times.
%   cmb= Coulomb stress changes for the region of interest at t=0.
%   tstart, tend = start and end time of the inversion.
%   mode = 'grid' or 'fminserch'. Optimization method. Optional.
%   asig0, ta0 = if mode='grid', ranges of values; will split the interval into N=nsteps steps in log space.
%                if mode='fminsearch', starting values.
%
% Output:
%   asig = a*sigma, where a=rate-state parameter for direct effect, sigma=effective normal stress
%   ta = aftershock decay time in Dieterich, 1994.
%   r0= background seismicity rate.
%   inv = inversion results (only if mode='grid'). Contains asigs, tas, LL values.

if exist('asig0')~=1 asig0=[1e3 1e6]; end
if exist('ta0')~=1  ta0=[1e3 1e5]; end
if exist('mode')~=1 mode='grid'; end
if exist('nsteps')~=1 nsteps=25; end
if exist('verbose')~=1 verbose=0; end

isin=cat>tstart & cat<tend;
cat=cat(isin);


switch mode
case 'grid'
  disp('Grid search log-likelihood inversion...')
  llmax=-inf;
  step=(log10(asig0(2))-log10(asig0(1)))/nsteps;
  asigs=10.^[log10(asig0(1)):step:log10(asig0(2))];
  step=(log10(ta0(2))-log10(ta0(1)))/nsteps;
  tas=10.^[log10(ta0(1)):step:log10(ta0(2))];

  for i=1:length(asigs); 
     for j=1:length(tas)
         ll(i,j)=loglikelihood([1 asigs(i) tas(j)], cat, tstart, tend, cmb, verbose);
	 if (ll(i,j))>llmax
  	   llmax=ll(i,j);
	   asig=asigs(i);
	   ta=tas(j);
         end
     end
  end
  inv.asigs=asigs;
  inv.tas=tas;
  inv.ll=ll;

case 'fminsearch'
  fun = @(par) -loglikelihood([1 par(1) par(2)], cat, tstart, tend, cmb);
  par = fminsearch(@(p) fun(p), [asig0 ta0]);
  asig = par(1);
  ta = par(2);
otherwise 
end

% Analytical solution for r0:
nt=0;
for n=1:length(cmb) [~,dum]=d94(tend,tstart,[1 asig ta], cmb(n)); nt=nt+dum; end
r0 = length(cat)/nt;

