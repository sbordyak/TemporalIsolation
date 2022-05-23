%% Example snippet of code for parsing data from publications
% Hood19emerge.mat contains 
% d: Cumulative emergence over 39 days for 6 sites
% t: Julian days
% isqg: logical vector ==1 if QG site, ==0 if QV site
% lifespan: % Insects alive over 9 days for 2 populations
% tls: Days from emergence for lifespan
% lsqg: for lifespan, ==1 if QG, ==0 if QV
%
% This code converts from sampled cumulative emergence to proportion
% emerged each day.

% Load data
load ./data/Hood19emerge.mat

Nsamp = length(isqg);
Nt = length(t);

% Add a day to each side of day vector
t2 = [t(1)-1; t; t(end)+1];

% Iterate over 6 sites
for ii = 1:Nsamp
    % Add 0 to start, 1 to end of cumulative curve to ensure it sums to 1
    dtmp = [0; d(d(:,ii)~=0,ii); 1];
    
    % Create temporary day vector for interpolation
    ttmp = [t(1)-1; t(d(:,ii)~=0); t(end)+1];
    
    % Interpolate cumulative curve onto all days
    dinterp(:,ii) = interp1(ttmp,dtmp,t2,'pchip');
end

temerge = t2(2:end); % Emergence day
emergeprob = diff(dinterp);  % Percent of insects emerging on each day


