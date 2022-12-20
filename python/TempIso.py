## TODO:
#   - Add __init__ class to TemporalIsolationModel
#   - Finish backend structure
#   - Create front end base for GUI
#   

import numpy as np

class Population:
    def __init__(self, name, emergence, lifespan, 
    tissue, alive, plant_longevity=1, population=100, latin="Not Available"):
        self.name = name
        self.latin_name = latin
        self.emergence = emergence
        self.lifespan = lifespan
        self.tissue_availability = tissue
        self.alive_distribution = alive
        self.population_count = population
        self.plant_longevity = plant_longevity

class TemporalIsolationModel:
    def __init__(self):
        return 1
