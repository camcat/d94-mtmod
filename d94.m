function [R, C] = d94(t, t0, rs_par, Dcmb);
% function [R, C] = d94(t, t0, rs_par, Dcmb);
%
% Outputs seismicity rate (R) and cumulative number of earthquakes (C) at times t following a stress step Dcmb at t=0 using the anaytical expressions from:
%  Dieterich, J. (1994), A constitutive law for rate of earthquake production and its application to earthquake clustering, J. Geophys. Res., 99( B2), 2601– 2618, doi:10.1029/93JB02581.
%
% Cumulative number of events calculated between t0 and t (note that t0=0 gives C=infinity for some choice of rate-state parameters).
% rs_par contains the following parameters: [r0 asig ta [tdot tdotr]]
% r0 = background seismicity rate.
% asig = a*sigma, where a=rate-state parameter for direct effect, sigma=effective normal stress
% ta = aftershock decay time in Dieterich, 1994.
% tdot = stressing rate after the mainshock (optional, if not given = asig/ta)
% tdotr = stressing rate before the mainshock (optional, if not given = tdot).
%
% units can be anything, as long as they are consistent for all input arguments.

r0=rs_par(1);
asig=rs_par(2);
ta=rs_par(3);
if length(rs_par)>3 tdot=rs_par(4); else tdot=asig/ta; end
if length(rs_par)>4 tdotr=rs_par(5); else tdotr=tdot; end

if length(Dcmb)>1
   R=0; C=0;
   for n=1:length(Dcmb)
       [r c] = d94(t,t0,rs_par,Dcmb(n)); 
       R=R+r; C=C+c;
   end
else

   %Write eq. 12 in Dieterich, 1994, as: r = A/(B*exp(-t/ta)+1);
   A = r0*tdot/tdotr;
   B = tdot/tdotr*exp(-Dcmb/asig)-1;

   R = A./(B*exp(-t/ta)+1);
   %Integrate R between 0,t:
   C = A*ta*[log(exp(t/ta)+B) - log(exp(t0/ta)+B)];
end

