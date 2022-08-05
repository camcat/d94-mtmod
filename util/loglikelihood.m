function ll = loglikelihood(par, cat, tstart, tend, cmb, verbose) 
%function ll = loglikelihood(par, cat, tstart, tend, cmb, [verbose=0]) 
% Calculates log-likelihood of the Dieterich 1994 forecast with respect to catalog cat. 
% Input: 
%   par = rate-state parameters 
%   cat = [t1 t2 t3]... earthquake times. 
%   cmb = Coulomb stress changes for the region of interest at t=0. 
%   tstart, tend = start and end time of the inversion. 
 
if exist('verbose')~=1 verbose=1; end

% Find seismicity rates at the time of observed events: 
r = d94(cat, 0, par, cmb); 
 
% Find total number of events (integral term in log-likelihood): 
[~, ntot] = d94(tend, tstart, par, cmb); 

ll = sum(log(r)) - ntot; 
if (verbose) disp(['asig=', num2str(par(2)), ', ta=', num2str(par(3)), ...
      ', sum(log(r))=' num2str(sum(log(r))), ', ntot=', num2str(ntot), ', ll=', num2str(ll)]);
end
