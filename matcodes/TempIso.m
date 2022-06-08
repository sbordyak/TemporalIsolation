function [TI, PopA, PopB] = TempIso(type, cdf_type, pdf_type, PopA, PopB)
    %% ------------------------------------------------------------------
    % TempIso function
    % Description:
    % Calculates the temporal isolation between 2 populations using
    % the selected method of calculation
    % Implemented methods of calculation include:
    % - Convolution ('conv')
    % - Monte-Carlo ('rng')
    %
    % Inputs:
    % - type, method of finding temporal isolation ('conv' for conv
    % -olution, 'rng' for Monte-Carlo)
    % - cdf_type, method of cdf calculation (see cdf function docum
    % -entation for list of usable strings)
    % - pdf_type, method of pdf calculation (see pdf function docum
    % -entation for list of usable strings)
    % - PopA, struct/object of population type
    % - PopB, struct/object of population type
    %
    % Outputs:
    % - TI, Temporal Isolation calculated value, using Hood 2019
    % equation, room to add other calculation methods
    % - PopA, altered struct/object of population type
    % - PopB, altered struct/object of population type
    %
    % TODO:
    % - Add more calculation types, add way to use other temporal
    % isolation formulas if desired
    %% ------------------------------------------------------------------
    
    timespan = 1:365;
    PopA.tissue.distribution = zeros(size(timespan));
    PopA.emergence.distribution = zeros(size(timespan));
    PopA.lifespan.distribution = zeros(size(timespan));
    PopB.tissue.distribution = zeros(size(timespan));
    PopB.emergence.distribution = zeros(size(timespan));
    PopB.lifespan.distribution = zeros(size(timespan));
    
    tempPDF = makedist(pdf_type, PopA.tissue.mean, PopA.tissue.std);
    PopA.tissue.distribution = pdf(tempPDF, timespan);
    tempPDF = makedist(pdf_type, PopB.tissue.mean, PopB.tissue.std);
    PopB.tissue.distribution = pdf(tempPDF, timespan);
    tempPDF = makedist(pdf_type, PopA.emergence.mean, PopA.emergence.std);
    PopA.emergence.distribution = pdf(tempPDF, timespan);
    tempPDF = makedist(pdf_type, PopB.emergence.mean, PopB.emergence.std);
    PopB.emergence.distribution = pdf(tempPDF, timespan);
    tempCDF = makedist(cdf_type, PopA.lifespan.mean, PopA.lifespan.std);
    PopA.lifespan.distribution = 1-cdf(tempCDF, timespan);
    tempCDF = makedist(cdf_type, PopB.lifespan.mean, PopB.lifespan.std);
    PopB.lifespan.distribution = 1-cdf(tempCDF, timespan);
    %PopA.tissue.distribution = pdf(pdf_type, timespan, PopA.tissue.mean, PopA.tissue.std);
    %PopB.tissue.distribution = pdf(pdf_type, timespan, PopB.tissue.mean, PopB.tissue.std);
    %PopA.emergence.distribution = pdf(pdf_type, timespan, PopA.emergence.mean, PopA.emergence.std);
    %PopB.emergence.distribution = pdf(pdf_type, timespan, PopB.emergence.mean, PopB.emergence.std);
    %PopA.lifespan.distribution = 1-cdf(cdf_type, timespan, PopA.lifespan.mean, PopA.lifespan.std);
    %PopB.lifespan.distribution = 1-cdf(cdf_type, timespan, PopB.lifespan.mean, PopB.lifespan.std);
    
    if type == "conv" % Convolution method
        PopA.alive = conv(PopA.emergence.distribution, PopA.lifespan.distribution);
        PopA.alive = PopA.alive(1:365);
        PopB.alive = conv(PopB.emergence.distribution, PopB.lifespan.distribution);
        PopB.alive = PopB.alive(1:365);
    elseif type == "rng" % Random number generation/Monte Carlo method
        birth_PopA = random(PopA.emergence.distribution, PopA.population, 1);
        death_PopA = birth_PopA + random(PopA.lifespan.distribution, PopA.population, 1);
        for i = 1:PopA.population
            tmp(i, floor(birth_PopA(i)):ceil(death_PopA(i))) = 1;
        end
        
        PopA.alive = sum(tmp);
        
        birth_PopB = random(PopB.emergence.distribution, PopB.population, 1);
        death_PopB = birth_PopB + random(PopB.lifespan.distribution, PopB.population, 1);
        for i = 1:PopB.population
            tmp(i, floor(birth_PopB(i)):ceil(death_PopB(i))) = 1;
        end
        
        PopB.alive = sum(tmp);
    end
    
    
    
    TI = 1-sum(PopA.alive.*PopB.alive)/sqrt(sum(PopA.alive.^2)*sum(PopB.alive.^2));
end