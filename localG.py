import pysal
from pysal import weights
import numpy as np
import pandas as pd
from pysal.esda.getisord import G_Local
f = pd.read_csv("Ratio.csv", header=None)
y = f.values
w_df = pd.read_csv("Cstcontem.csv", header=None)
w_df.head()
w = weights.util.full2W(w_df.values)
np.random.seed(10)
mir = pysal.Moran(y, w, permutations = 999)
np.random.seed(12345)
lm = pysal.Moran_Local(y,w)
lm.Is
lg = G_Local(y, w)
lg.Gs
lgstar = G_Local(y, w, star=True)
print(lgstar.Zs)
lgstarz = lgstar.Zs
np.savetxt("lgstarz.csv", lgstarz, delimiter=",")
lgstarpval = lgstar.p_sim
np.savetxt("lgstarpval.csv", lgstarpval, delimiter=",")