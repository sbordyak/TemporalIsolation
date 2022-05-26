classdef system
%-----------------------------------------------------------------------------------
% System class, represents an entire insect-plant host system that is being analyzed
%   - Work in progress
%   - Needs to include other necessary values
%   - Needs to include methods for performing analysis on self 
%   - Maybe we can include an interpolation or convolution function in this class
%       depending on the way it is structured?
%   - Need to figure out which values are vital and which are not
%-----------------------------------------------------------------------------------

properties 
    article_name; % Name of original paper
    author_name; % Author of original paper
    doi; % DOI of original paper
    insect_names; % Names of insects within system
    host_names; % Names of host plants withing system
    emergence; % Emergence values vector, initiated as a vector in the constructor (see system())
    repro_viability; % Reproductive viability vector, this is the emergence vector + 7
    longevity; % List of longevity values, varying length, OPTIONAL MEMBER
    sex_ratio; % Sex ratio of population of insect species, OPTIONAL MEMBER
    plant_tissue; % Plant tissue availability at any time, OPTIONAL MEMBER(?)
    plant_birth_rate; % Birth/creation rate of plant organ to be used for hosting the insect species, OPTIONAL MEMBER
    timespan = [1:365]; % Timespan vector of 365 values, represents the Julian calendar
end
methods
    %-------------------------------------------------------------------------------
    % system constructor
    %   - Used to create an object of system class
    %   - Need to figure out which members should be required and which should not
    %-------------------------------------------------------------------------------
    function self = system(article_in, author_in, doi_in, ...
                            i_names, h_names, emergence_in, ...
                            longevity_in, sex_ratio_in, ...
                            plant_tissue_in, plant_birth_rate_in)
        
        if article_in != ''
            article_name = article_in;
        else
            display("WARNING: NO ARTICLE NAME GIVEN");
        end

        if author_in != ''
            author_name = author_in;
        else
            display("WARNING: NO AUTHOR NAME GIVEN");
        end

        if doi_in != ''
            doi = doi_in;
        else
            display("WARNING: NO DOI GIVEN");
        end

        if i_names != ''
            insect_names = i_names;
        else
            display("WARNING: NO INSECT NAMES GIVEN");
        end

        if h_names != ''
            host_names = h_names;
        else
            display("WARNING: NO HOST NAMES GIVEN");
        end

        if emergence_in != 0
            emergence = emergence_in;
            repro_viability = emergence_in + 7;
        else
            display("WARNING: NO EMERGENCE VALUES GIVEN");
        end

        if longevity_in != 0
            longevity = longevity_in;
        else 
            display("WARNING: NO VALID LONGEVITY VALUE");
        end

        if sex_ratio_in != 0
            sex_ratio = sex_ratio_in;
        else 
            display("WARNING: NO VALID SEX RATIO VALUE");
        end

        if plant_tissue_in != 0
            plant_tissue = plant_tissue_in;
        else
            display("WARNING: NO VALID PLANT TISSUE VALUE");
        end

        if plant_birth_rate_in != 0
            plant_birth_rate = plant_birth_rate_in;
        else
            display("WARNING: NO VALID PLANT ORGAN BIRTH RATE VALUE");
        end

    end

end

end