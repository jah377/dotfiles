import matplotlib.pyplot as plt
import pandas as pd

df = pd.DataFrame({"x": range(10), "y": [v**2 for v in range(10)]})

df.plot()
plt.show()  # Opens matplotlib window
