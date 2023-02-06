import pytest
from TempIso import TemporalIsolationModel

def test_RNGTestDefault():
    model = TemporalIsolationModel()
    assert(model.seed[0] == 70)
    assert(model.seed[1] == 5)
    assert(model.seed[2] == 2.5)
    assert(model.seed[3] == 1.2)
    assert(model.seed[4] == 60)
    assert(model.seed[5] == 5)
    assert(model.seed[6] == 14)
    assert(model.seed[7] == 2)
    assert(model.seed[8] == 70)
    assert(model.seed[9] == 5)
    assert(model.seed[10] == 2.5)
    assert(model.seed[11] == 1.2)
    assert(model.seed[12] == 60)
    assert(model.seed[13] == 5)
    assert(model.seed[14] == 14)
    assert(model.seed[15] == 2)
