function [cmb lat lon dep lat_col lon_col dep_col cmb_col headers] = loadinput(fname);
%function [cmb lat lon dep lat_col lon_col dep_col cmb_col headers] = loadinput(fname);
% Reads coordinates and stress changes from EPSy output file.
% Returns: values (lat, lon, dep, cmb); column indices (xxx_col); a string to use as header.

% Load output from ESPy:
l=importdata(fname);
disp(['Loading ' fname '...']);

% Sometimes matlab loads all the data as text.
% So here count header lines by checking that they start with "#"
nh=find(cellfun(@(x) x(1)=='#', l.textdata(:,1)),1,'last');

l=importdata(fname);
disp(['Found ' num2str(nh) ' header lines in file: ' fname '...']);


% Reload with correct number of header lines:
l=importdata(fname,' ',nh);

% Find header line with fields, and columns for coordinate and Coulomb stresses. 
% Assumes that all field labels are in the same header line (n).
[n,lat_col]=find_field(l.textdata, 'lat');
[~,lon_col]=find_field(l.textdata, 'lon');
[~,dep_col]=find_field(l.textdata, 'depth');
[~,cmb_col]=find_field(l.textdata, 'coulomb');

% Read relevant columns:
lat=l.data(:,lat_col);
lon=l.data(:,lon_col);
dep=l.data(:,dep_col);
cmb=l.data(:,cmb_col);

% Copy headers so field names are consistent:
headers=cell(1,max(max(lat_col,lon_col),max(dep_col,cmb_col)));
headers(:)={'n/a'};
str=strsplit(l.textdata{n});
headers(lat_col)=str(n,lat_col+1);
headers(lon_col)=str(n,lon_col+1);
headers(dep_col)=str(n,dep_col+1);
headers(cmb_col)=str(n,cmb_col+1);

function [n, col] = find_field(headers, fld)
for n=1:length(headers)
  % Read header lines into fields:
  str=strsplit(headers{n});

  % Look for field (not case sensitive):
  col=find(cellfun(@(x) ~isempty(strfind(lower(x),lower(fld))), str));
  if ~isempty(col)
     disp(['Field "' fld '" found at header line ' num2str(n) ', column ' num2str(col)]);
     col=col-1; %since the first string is a "#"
     break;
  end
end
if isempty(col) disp(['Field "' fld '" not found.']); end
