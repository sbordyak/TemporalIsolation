function [TI,Qv,Qg] = ComputeTI_conv(Qv,Qg);
% function [TI,Qv,Qg] = ComputeTI_conv(Qv,Qg);
% Creates % Alive curves as a function of day by convolving emergence and
% lifespan.  Faster than the random version.  Tissue term not coded yet.
% Inputs
% Qv, Qg: Distribution (pdf) information for two wasp populations
% Outputs
% TI: Temporal isolation calculated for distributions 
% Qv, Qg: Input structs with distributions on day-of-year grid added
%%


day = 1:365;

% Initialize day vectors
Qv.Nflower = zeros(size(day));
Qv.Nemerge = zeros(size(day));
Qv.Nlifespan = zeros(size(day));
Qg.Nflower = zeros(size(day));
Qg.Nemerge = zeros(size(day));
Qg.Nlifespan = zeros(size(day));

% Create distributions
Qv.Nflower = pdf(Qv.FDpdf,day);
Qv.Nemerge = pdf(Qv.Hpdf,day);
Qv.Nlifespan = pdf(Qv.LFpdf,day);

Qv.Nalive = conv(Qv.Nemerge,Qv.Nlifespan);
Qv.Nalive = Qv.Nalive(1:365);

Qg.Nflower = pdf(Qg.FDpdf,day);
Qg.Nemerge = pdf(Qg.Hpdf,day);
Qg.Nlifespan = pdf(Qg.LFpdf,day);

Qg.Nalive = conv(Qg.Nemerge,Qg.Nlifespan);
Qg.Nalive = Qg.Nalive(1:365);


% Calculate TI based on Hood
TI = 1 - sum(Qg.Nalive.*Qv.Nalive)/sqrt(sum(Qg.Nalive.^2)*sum(Qv.Nalive.^2));

