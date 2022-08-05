function t = load_Norcia(Mmin);
%function t = load_Norcia(Mmin);
%Reads Tan et al (2021) catalog and returns time with respect to Norcia mainshock. Only events with Mw>=Mmin are returned. 

%If Mmin not given, return all.
if exist('Mmin')~=1 Mmin=-inf; end

c=importdata('input/Amatrice_CAT5.v20210325',' ',23);
c=c.data;
mag=c(:,15); %Moment magnitude
c=c(mag>=Mmin,:);
mag=mag(mag>=Mmin);

t=datetime(c(:,1),c(:,2),c(:,3),c(:,4),c(:,5),c(:,6));

%Find mainshocks:
mainshock=find(mag>6);

t=datenum(t)-datenum(t(mainshock(1)));

