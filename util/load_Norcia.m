function [t mag lo la] = load_Norcia(Mmin, lons, lats);
% function t = load_Norcia(Mmin, lons, lats);
% Reads Tan et al (2021) catalog and returns time with respect to Norcia mainshock. 
% If Mmin, lons and lats are given, events are selected as follows:
% Magnitude >= Mmin
% Longitude >=lons(1), <=lons(2)
% Latitude >=lats(1), <=lons(2)

%If Mmin not given, return all.
if exist('Mmin')~=1 Mmin=-inf; end
if exist('lons')~=1 lons=[-inf inf]; end
if exist('lats')~=1 lats=[-inf inf]; end

c=importdata('input/Amatrice_CAT5.v20210325',' ',23);
c=c.data;
lo=c(:,8); %Moment magnitude
la=c(:,7); %Moment magnitude
mag=c(:,15); %Moment magnitude

sel = mag>=Mmin & lo>=lons(1) & lo<=lons(2) & la>=lats(1) & la<=lats(2);

if sum(sel)==0 error("No events found with these selection criteria."); end

c=c(sel,:);
mag=mag(sel);
la=la(sel);
lo=lo(sel);

t=datetime(c(:,1),c(:,2),c(:,3),c(:,4),c(:,5),c(:,6));

%Find mainshocks:
mainshock=find(mag>6);

t=datenum(t)-datenum(t(mainshock(1)));

