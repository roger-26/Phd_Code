import pandas as pd
import seaborn as sns

df = pd.read_csv('G:/Downloads/berlin_airbnb/listings.csv')
df.head()

sns.pairplot(df,vars=['price','availability_365','number_of_reviews'])
print("Hello World")