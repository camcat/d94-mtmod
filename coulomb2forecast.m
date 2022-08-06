function [rate ntot pos] = coulomb2forecast(input_file, ts, t0, rs_par, output_file); 
%function [rate ntot pos] = coulomb2forecast(input_file, ts, t0, [rs_par], [output_file]); 
%
%Reads Coulomb stress changes calculated in EPSy and calculates seismicity forecast using analytical expressions from Dieterich (1994).
%
%  input_file = input file name. Columns must be separated by " " and there must be a header line starting with # and containing the field "coulomb".
%  ts = calculation times. 
%  t0: start time for ntotulative no. of events (note that t0=0 gives infinite number of events for some choice of rate-state parameters).
%  rs_par: rate-state parameters [r0 asig ta]
%     r0 = background seismicity rate (default value=1event/day)
%     asig = a*sigma, where a=rate-state parameter for direct effect, sigma=effective normal stress (default value = 10kPa)
%     ta = aftershock decay time in Dieterich, 1994. (default=1000days)
%  output_file = output file name (if not give, will not produce output).
%  
%  rate: gridded seismicity rates in units of [r0]. rate[nx,nt] contains seismicity rate at grid point nx and time step nt.
%  ntot: cumulative no. of events. ntot[nx,nt] contains number of events at grid point nx between [t0 ts(nt)].
%  pos: structure containing spatial coordinates (fields 'lat','lon','dep') copied from input file. 
%
% units must be consistent between asig and input file. Default values of rs_par assume [1/d kPa d]

% Set default rate-state parameters if not given.
% note: assume input file uses units: [1/d, kPa, d]
if exist('rs_par')~=1 rs_par=[1 10 1000]; end

% Load input file and identify columns of interest:
[cmb lat lon dep latc lonc depc cmbc hdrs] = loadinput(input_file);
if isempty(cmbc) error('Couldn not find Coulomb field - exiting.'); end
pos.lat=lat;
pos.lon=lon;
pos.dep=dep;

% Preallocate arrays for seismicity rate and cumulative no. of events: 
rate=zeros(length(cmb),length(ts)); 
ntot=zeros(length(cmb),length(ts)); 

% Calculate seismicity rate and number of events at each point:
disp('Calculating seismicity...')
%Assume uniform background rate and split it equally among grid points:
par=[rs_par(1)/length(cmb) rs_par(2) rs_par(3)];

for n=1:length(cmb)
  [r, c]=d94(ts, t0, par, cmb(n));
  rate(n,:)=r;
  ntot(n,:)=c;
end

% Print output file:
if exist('output_file')
  % Make new headers:
  disp(['Saving seismicity map to file: ' output_file]);
  hdr=hdrs;
  hdr{cmbc}='no_of_earthquakes';
  hdr=strjoin(['#' hdr]);
  
  ncol=length(hdrs);
  
  data=zeros(length(cmb),length(hdrs));
  data(:,latc)=lat;
  data(:,lonc)=lon;
  data(:,depc)=dep;
  data(:,cmbc)=ntot(:,end);
  
  % Print output file:
  fid=fopen(output_file,'w');
  if fid==-1 disp(['Could not create output file.'])
  else
   fprintf(fid,'%s\n',hdr);
   fprintf(fid,[repmat('%.6f ',1,ncol) ' \n'],data');
   fclose(fid);
  end
end 
