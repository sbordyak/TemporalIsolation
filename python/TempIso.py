## TODO:
#   - Add __init__ class to TemporalIsolationModel
#   - Finish backend structure
#   - Create front end base for GUI
#   

import numpy as np
from scipy.stats import norm
from StatsSuite import probabilityDensity, cumulativeDistribution

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
                options=['ratio1', 'normal', 'normal', 500, 250, 1],
                baseValuesMatrix=[[[70,5,5,2.5],[2.5,0.5,1.2,0.2],[60,5,5,2.5],[14,2,2,0.5]], 
                                  [[70,5,5,2.5],[2.5,0.5,1.2,0.2],[60,5,5,2.5],[14,2,2,0.5]]], 
                testRange=[i for i in range(10)], testCount=1):
        self.boolean = boolean
        self.options = options
        self.ratioCalculationType = options[0]
        self.cdfType = options[1]
        self.pdfType = options[2]
        self.numberOfEggSites = options[3]
        self.numberOfEggLayers = options[4]
        self.plantDataInclusionSwitch = options[5]
        self.baseValuesMatrix = baseValuesMatrix
        temp = baseValuesMatrix
        self.seed = [temp[0][0][0], temp[0][0][2], temp[0][1][0], temp[0][1][2],
                     temp[0][2][0], temp[0][2][2], temp[0][3][0], temp[0][3][2],
                     temp[1][0][0], temp[1][0][2], temp[1][1][0], temp[1][1][2],
                     temp[1][2][0], temp[1][2][2], temp[1][3][0], temp[1][3][2]]
        self.testRange = testRange
        self.testCount = testCount
        self.randomTest()

    def temporalIsolation(self):
        timespan = [i for i in range(1,366)]

        populationA_EmergenceDistribution = norm.pdf(timespan, self.seed[0], self.seed[1])
        populationA_LifespanDistribution = norm.pdf(timespan, self.seed[2], self.seed[3])
        populationB_EmergenceDistribution = norm.pdf(timespan, self.seed[8], self.seed[9])
        populationB_LifespanDistribution = norm.pdf(timespan, self.seed[10], self.seed[11])

        if self.plantDataInclusionSwitch == 1:
            populationA_TissueDistribution = norm.sf(timespan, self.seed[4], self.seed[5])
            populationA_PlantLongevityDistribution = norm.sf(timespan, self.seed[6], self.seed[7])
            populationB_TissueDistribution = norm.sf(timespan, self.seed[12], self.seed[13])
            populationB_PlantLongevityDistribution = norm.sf(timespan, self.seed[14], self.seed[15])
            plantA_AliveDistribution = np.convolve(populationA_TissueDistribution, populationA_PlantLongevityDistribution)
            plantA_AliveDistribution = plantA_AliveDistribution[0:364]
            plantB_AliveDistribution = np.convolve(populationB_TissueDistribution, populationB_PlantLongevityDistribution)
            plantB_AliveDistribution = plantB_AliveDistribution[0:364]
            eggSitesA = plantA_AliveDistribution * self.numberOfEggSites
            eggSitesB = plantB_AliveDistribution * self.numberOfEggSites
        else:
            eggSitesA = self.numberOfEggSites
            eggSitesB = self.numberOfEggSites
        
        populationA_AliveDistribution = np.convolve(populationA_EmergenceDistribution, populationA_LifespanDistribution)
        populationA_AliveDistribution = populationA_AliveDistribution[0:364]
        populationB_AliveDistribution = np.convolve(populationB_EmergenceDistribution, populationB_LifespanDistribution)
        populationB_AliveDistribution = populationB_AliveDistribution[0:364]
        eggLayersA = populationA_AliveDistribution * self.numberOfEggLayers
        eggLayersB = populationB_AliveDistribution * self.numberOfEggLayers
        
        for i in range(len(populationA_AliveDistribution)):
            if self.ratioCalculationType == 'ratio1':
                PTRatioA = np.min(eggSitesA[i]/eggLayersA[i], 1)
                PTRatioB = np.min(eggSitesB[i]/eggLayersB[i], 1)
            else:
                if eggSitesA[i] >= eggLayersA[i]:
                    PTRatioA = 1
                else:
                    PTRatioA = 0
                if eggLayersB[i] >= eggLayersB[i]:
                    PTRatioB = 1
                else:
                    PTRatioB = 0
            populationA_AliveDistribution[i] = populationA_AliveDistribution[i] * PTRatioA
            populationB_AliveDistribution[i] = populationB_AliveDistribution[i] * PTRatioB

        #if self.ratioCalculationType == 'ratio1':
        #   for i in range(len(populationA_AliveDistribution)):
        #        PTRatioA = np.min(eggSitesA[i]/eggLayersA[i], 1)
        #        PTRatioB = np.min(eggSitesB[i]/eggLayersB[i], 1)
        #        populationA_AliveDistribution[i] = populationA_AliveDistribution[i] * PTRatioA
        #        populationB_AliveDistribution[i] = populationB_AliveDistribution[i] * PTRatioB
        #else:
        #    for i in range(len(populationA_AliveDistribution)):
        #        if eggSitesA[i] >= eggLayersA[i]:
        #            PTRatioA = 1
        #        else:
        #            PTRatioA = 0
        #        if eggLayersB[i] >= eggLayersB[i]:
        #            PTRatioB = 1
        #        else:
        #            PTRatioB = 0
        #    populationA_AliveDistribution[i] = populationA_AliveDistribution[i] * PTRatioA
        #    populationB_AliveDistribution[i] = populationB_AliveDistribution[i] * PTRatioB

        return 1-np.sum(populationA_AliveDistribution * populationB_AliveDistribution)/np.sqrt(np.sum(populationA_AliveDistribution**2)*np.sum(populationB_AliveDistribution**2))


    def schedulerTest(self):
        return 1

    def incrementalTest(self):
        return 1

    def randomTest(self):
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
            
