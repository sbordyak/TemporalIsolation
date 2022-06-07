classdef Insect

properties
    % parasite_or_host;
    names; % Names of insects within system
    emergence; % Emergence values vector, initiated as a vector in the constructor (see system())
    repro_viability; % Reproductive viability vector, this is the emergence vector + 7
    longevity; % List of longevity values, varying length, OPTIONAL MEMBER
    sex_ratio; % Sex ratio of population of insect species, OPTIONAL MEMBER
end

methods
    function self = Insect(names_in, emergence_in, longevity_in, sex_ratio_in)
        % self.parasite_or_host = poh;

        if names_in ~= ''
            self.names = names_in;
        else
            display("Warning: no insect names given");
            self.names = '';
        end
        
        if emergence_in ~= 0
            self.emergence = emergence_in;
            self.repro_viability = emergence_in + 7;
        else
            display("WARNING: NO EMERGENCE VALUES GIVEN");
            self.emergence = 0;
            self.repro_viability = 0;
        end

        if longevity_in ~= 0
            self.longevity = longevity_in;
        else 
            display("WARNING: NO VALID LONGEVITY VALUE");
            self.longevity = 0;
        end

        if sex_ratio_in ~= 0
            self.sex_ratio = sex_ratio_in;
        else 
            display("WARNING: NO VALID SEX RATIO VALUE");
            self.sex_ratio = 0;
        end

    end

    % Getter functions
    function name = get.name(self)
    end

    function emergence = get.emergence(self)
    end

    function repro_viability = get.repro_viability(self)
    end

    function longevity = get.longevity(self)
    end

    function sex_ratio = get.sex_ratio(self)
    end

    % Setter functions
    function self = set.name(self, name)
    end

    function self = set.emergence(self, emergence)
    end

    function self = set.repro_viability(self, repro_viability)
    end

    function self = set.longevity(self, longevity)
    end

    function self = set.sex_ratio(self, sex_ratio)
    end
end

end