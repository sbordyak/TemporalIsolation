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
    def __init__(self, 
                boolean=[1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
                options=['ratio1', 'normal', 'normal', 500, 219, 1],
                baseValuesMatrix=[[[70,5,5,2.5],[2.5,0.5,1.2,0.2],[60,5,5,2.5],[14,2,2,0.5]], 
                                  [[70,5,5,2.5],[2.5,0.5,1.2,0.2],[60,5,5,2.5],[14,2,2,0.5]]], 
                testRange={1:10}, testCount=1):
        self.boolean = boolean
        self.options = options
        self.baseValuesMatrix = baseValuesMatrix
        temp = baseValuesMatrix
        self.seed = [temp[0][0][0], temp[0][0][2], temp[0][1][0], temp[0][1][2],
                     temp[0][2][0], temp[0][2][2], temp[0][3][0], temp[0][3][2],
                     temp[1][0][0], temp[1][0][2], temp[1][1][0], temp[1][1][2],
                     temp[1][2][0], temp[1][2][2], temp[1][3][0], temp[1][3][2]]
        self.testRange = testRange
        self.testCount = testCount
        self.RNGTest()

    def RNGTest(self):
        testAmount = len(self.testRange)*self.testCount
        schedulerSlice = np.zeros((16,len(self.testRange)*self.testCount))
        separation = 0
        for i in range(testAmount):
            if (i-1) % self.testCount == 0:
                separation += 1

            emergenceA = self.baseValuesMatrix[0][0]
            lifespanA = self.baseValuesMatrix[0][1]
            leafFlushA = self.baseValuesMatrix[0][2]
            plantLongevityA = self.baseValuesMatrix[0][3]
            schedulerSlice[0,i] = emergenceA[0] + emergenceA[1] * np.random.randn()
            schedulerSlice[1,i] = emergenceA[2] + emergenceA[3] * np.random.randn()
            schedulerSlice[2,i] = lifespanA[0] + lifespanA[1] * np.random.randn()
            schedulerSlice[3,i] = lifespanA[2] + lifespanA[3] * np.random.randn()
            
