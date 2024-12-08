import pandas as pd 
import numpy as np
import matplotlib.pyplot as plt
df=pd.read_csv('/home/dan/compsci/pandas/vgsales.csv')
print(df.describe())
top_games = df[['Platform', 'Global_Sales']].sort_values(by='Global_Sales', ascending=False).head(100)
print(top_games)

#plotting the data
plt.figure(figsize=(20, 6))
plt.barh(top_games['Platform'], top_games['Global_Sales'], color='red')
plt.xlabel('Global Sales (millions)')
plt.ylabel('platform of game')
plt.title('Top plaform by Global sales')
plt.gca().invert_yaxis()  # Invert y-axis to show the highest sales at the top
plt.show()