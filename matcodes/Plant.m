classdef Plant < System
%-----------------------------------------------------------------------------------
% Plant class, Subclass for plants and related data
%   - Not sure if necessary, mockup class
%-----------------------------------------------------------------------------------

properties
    names; % Names of plants in system
    growth_rate; % growth rate of plants in system
    tissue_availability; % tissue availability of plants in system
    parasite_or_host; % Parasite or host boolean switch
end
methods
    function self = Plant(poh, names_in, growth_rate_in, tissue_availability_in)
        parasite_or_host = poh;

        if names_in ~= ''
            names = names_in;
        else
            display("Warning: no plant names given");
            names = '';
        end

        if growth_rate_in ~= 0
            growth_rate = growth_rate_in;
        else
            display("Warning: growth rate not given");
            growth_rate = 0;
        end

        if tissue_availability_in ~= 0
            tissue_availability = tissue_availability_in;
        else
            display("Warning: no tissue availability given");
            tissue_availability = 0;
        end
    end
end

end