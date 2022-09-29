classdef Ecosystem
%-----------------------------------------------------------------------------------
% Ecosystem class, represents an entire insect-plant host system that is being analyzed
%   - Work in progress
%   - Needs to include other necessary values
%   - Needs to include methods for performing analysis on self 
%   - Maybe we can include an interpolation or convolution function in this class
%       depending on the way it is structured?
%   - Add properties for sexual, habitat, and temporal/allochronic isolation
%   - Add fields to the constructor method to load values to those properties
%   - Add method to produce value for reproductive isolation via equations 
%       in Hood 2019
%-----------------------------------------------------------------------------------

properties 
    article_name; % Name of original paper
    author_name; % Author of original paper
    doi; % DOI of original paper
    insects; % Objects of insect type
    plants; % Objects of plant type
    timespan = [1:365]; % Timespan vector of 365 values, represents the Julian calendar
end
methods
    %-------------------------------------------------------------------------------
    % system constructor
    %   - Used to create an object of system class
    %   - Need to figure out which members should be required and which should not
    %-------------------------------------------------------------------------------
    function self = system(article_in, author_in, doi_in, ...
                            i_names, p_names, emergence_in, ...
                            longevity_in, sex_ratio_in, ...
                            plant_tissue_in, plant_birth_rate_in)
        
        if article_in ~= ''
            self.article_name = article_in;
        else
            display("WARNING: NO ARTICLE NAME GIVEN");
        end

        if author_in ~= ''
            self.author_name = author_in;
        else
            display("WARNING: NO AUTHOR NAME GIVEN");
        end

        if doi_in ~= ''
            self.doi = doi_in;
        else
            display("WARNING: NO DOI GIVEN");
        end

        self.insects = zeros(1, length(i_names));
        self.plants = zeros(1, length(p_names));
        for i = 1:length(i_names)
            self.insects(i) = Insect(i_names(i), emergence_in(i), repro_viability(i), sex_ratio_in(i));
        end
        for i = 1:length(p_names)
            self.insects(i) = Plant(p_names(i), plant_birth_rate_in(i), plant_tissue_in(i));
        end

    end
end

end