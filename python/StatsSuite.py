import numpy as np
from scipy.stats import norm

def probabilityDensity(mean, std, distributionType='normal'):
    if distributionType != 'normal':
        return 1
    else:
        pdf = (np.pi * mean) * np.exp(-0.5 * ((x-mean)/std)**2)
    
    return pdf

def cumulativeDistribution(mean, std, distributionType='normal'):
    if distributionType != 'normal':
        return 1
    else:
        cdf = np.sort(probabilityDensity(mean, std, distributionType))
        cdf = norm.cdf(cdf)
    
    return cdf