function [rate ntot pos] = coulomb2forecast(input_file, ts, t0, rs_par, output_file); 
%function [rate ntot pos] = coulomb2forecast(input_file, ts, t0, rs_par, [output_file]); 
% Reads Coulomb stress changes calculated in EPSy and calculates seismicity forecast using analytical expressions from Dieterich (1994).
%  input_file = input file name. Format can be anything, as long as there is a header file named "coulomb".
%  ts = calculation times. 
%  t0: start time for ntotulative no. of events (note that t0=0 gives infinite number of events for some choice of rate-state parameters).
%  rs_par: rate-state parameters [r0 asig ta]
%    r0 = background seismicity rate.
%    asig = a*sigma, where a=rate-state parameter for direct effect, sigma=effective normal stress
%    ta = aftershock decay time in Dieterich, 1994.
%  output_file = output file name (if not give, will not produce output).
% units can be anything, as long as they are consistent for all input arguments and input file.

% Load input file and identify columns of interest:
[lat lon dep cmb latc lonc depc cmbc hdrs] = loadinput(input_file);
if isempty(cmbc) error('Couldn not find Coulomb field - exiting.'); end

pos.lat=lat;
pos.lon=lon;
pos.dep=dep;

% Preallocate arrays for seismicity rate and ntotulative no. of events: 
rate=zeros(length(cmb),length(ts)); 
ntot=zeros(length(cmb),length(ts)); 

% Calculate seismicity rate and number of events at each point:
disp('Calculating seismicity...')
parfor n=1:length(cmb);
  [r, c]=d94(ts, t0, rs_par, cmb(n));
  rate(n,:)=r;
  ntot(n,:)=c;
end

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
  data(:,cmbc)=sum(ntot');
  
  % Print output file:
  fid=fopen(output_file,'w');
  if fid==-1 disp(['Could not create output file.'])
  else
   fprintf(fid,'%s\n',hdr);
   fprintf(fid,[repmat('%.6f ',1,ncol) ' \n'],data');
   fclose(fid);
  end

end 
