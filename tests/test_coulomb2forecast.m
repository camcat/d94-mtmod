%xy_east_model.txt
%input_file='~/code/ESPy_Demo/Outputs/my_experiment/stresses_horiz_profile.txt';
%output_file='~/code/ESPy_Demo/Outputs/my_experiment/forecasts/eqks_horiz_profile.txt';

%input_file='~/code/ESPy_Demo/Outputs/my_experiment/stresses_full.txt';
%output_file='~/code/ESPy_Demo/Outputs/my_experiment/forecasts/eqks_full.txt';

%input_file='~/code/ESPy_Demo/Outputs/my_experiment/stresses_horiz_profile.txt';
%output_file='~/code/ESPy_Demo/Outputs/my_experiment/forecasts/eqks_horiz_profile.txt';

ts=1:10:1000;
t0=1e-5;
par=[1 1 1000];

[rate nt] = coulomb2forecast(input_file, ts, t0, par, output_file);
