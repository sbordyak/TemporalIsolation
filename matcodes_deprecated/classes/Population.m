classdef Population
    properties 
        name; % Practical name
        latin; % Scientific name
        emergence; % Emergence data
        lifespan; % Insect lifespan data
        tissue; % Plant tissue data
        alive; % Alive distribution
        population; % Population count (for RNG)
        plong;
    end
    methods
        %% Population constructor
        %   Creates an object of type population for use with the TestModel
        %   class
        function self = Population(name_in, latin_in, emergence_in, ...
                                    lifespan_in, tissue_in, alive_in, ...
                                    population_in, plong_in);
            %self.insect = Insect(name, latin, emergence, lifespan, 0);
            %self.plant = Plant('', 0, tissue);
            self.name = name_in;
            self.latin = latin_in;
            self.emergence = emergence_in;
            self.lifespan = lifespan_in;
            self.tissue = tissue_in;
            self.alive = alive_in;
            self.population = population_in;
            self.plong = plong_in;
        end
    end
end