classdef Plant

properties
    % parasite_or_host;
    name; % Names of host plants withing system
    organ_birth_rate; % Birth/creation rate of plant organ to be used for hosting the insect species, OPTIONAL MEMBER
    tissue; % Plant tissue availability at any time
end

methods
    function self = Plant(name_in, organ_birth_rate_in, tissue_in)
        % self.parasite_or_host = poh;

        if name_in ~= ''
            self.name = name_in;
        else
            display("Warning: no plant names given");
            self.name = '';
        end

        if tissue_in ~= 0
            self.tissue = tissue_in;
        else
            display("WARNING: NO VALID PLANT TISSUE VALUE");
            self.tissue = 0;
        end

        if organ_birth_rate ~= 0
            self.organ_birth_rate = organ_birth_rate_in;
        else
            display("WARNING: NO VALID PLANT ORGAN BIRTH RATE VALUE");
            self.organ_birth_rate = 0;
        end

    end

    % Getter functions
    function name = get.name(self)
    end

    function organ_birth_rate = get.organ_birth_rate(self)
    end

    function tissue = get.tissue(self)
    end

    % Setter functions
    function self = set.name(self, name)
    end

    function self = set.organ_birth_rate(self, organ_birth_rate)
    end

    function self = set.tissue(self, tissue)
    end
end

end