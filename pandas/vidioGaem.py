import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
df=pd.read_csv('/home/dan/compsci/pandas/vgsales.csv')
print(df.describe())
top_games = df[['Platform', 'Global_Sales']].sort_values(by='Global_Sales', ascending=False).head(100)
print(top_games)