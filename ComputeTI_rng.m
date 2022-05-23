function [TI,Qv,Qg] = ComputeTI_rng(Qv,Qg);
% function [TI,Qv,Qg] = ComputeTI_rng(Qv,Qg);
% Creates % Alive curves as a function of day using a monte carlo approach.  
% Much slower than alternative convolution so it's been disused
% Inputs
% Qv, Qg: Distribution (pdf) information for two wasp populations
% Outputs
% TI: Temporal isolation calculated for distributions 
% Qv, Qg: Input structs with distributions on day-of-year grid added
%%


% Randomly determine emergence and lifespan for simulated wasps
BirthQv = random(Qv.Hpdf,Qv.Nwasp,1);
DeathQv = BirthQv+random(Qv.LFpdf,Qv.Nwasp,1);
tmp = zeros(Qv.Nwasp,365);
for ii = 1:Qv.Nwasp
    tmp(ii,floor(BirthQv(ii)):ceil(DeathQv(ii))) = 1;
end

% Percent alive each day
Qv.Nalive = sum(tmp);

% Same for other wasp population
BirthQg = random(Qg.Hpdf,Qg.Nwasp,1);
DeathQg = BirthQg+random(Qg.LFpdf,Qg.Nwasp,1);
tmp = zeros(Qg.Nwasp,365);
for ii = 1:Qg.Nwasp
    tmp(ii,floor(BirthQg(ii)):ceil(DeathQg(ii))) = 1;
end

Qg.Nalive = sum(tmp);

% Calculate TI according to Hood
TI = 1 - sum(Qg.Nalive.*Qv.Nalive)/sqrt(sum(Qg.Nalive.^2)*sum(Qv.Nalive.^2));
