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
    function self = system(i_names, h_names, emergence_in, longevity_in, sex_ratio_in, plant_tissue_in, plant_birth_rate_in)
        
        insect_names = i_names;

        host_names = h_names;

        emergence = emergence_in;

        repro_viability = emergence_in + 7;

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