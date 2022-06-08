classdef Population
    properties 
        name;
        latin;
        emergence;
        lifespan;
        tissue;
        alive;
        population;
    end
    methods
        function self = Population(name_in, latin_in, emergence_in, ...
                                    lifespan_in, tissue_in, alive_in, ...
                                    population_in);
            %self.insect = Insect(name, latin, emergence, lifespan, 0);
            %self.plant = Plant('', 0, tissue);
            self.name = name_in;
            self.latin = latin_in;
            self.emergence = emergence_in;
            self.lifespan = lifespan_in;
            self.tissue = tissue_in;
            self.alive = alive_in;
            self.population = population_in;
        end
    end
end