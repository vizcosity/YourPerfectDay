import pandas as pd
import matplotlib.pyplot as plt

data = pd.read_csv("sample_agg_health_and_checkin_data.csv")

data.head()

# Tasks:
# - Attempt to explore and find the correlations between the metrics and the lifestyle
# measures using a correlation matrix.
# - Try different models in order to predict the metrics using the lifesyle measures,
# e.g. using regression. Try prediction for different prior rolling collections of data,
# such as the last week, or month of data, as well as the last day. Could use
# CNNs and teach the network to prioritise or 'give weight' to the last day or two
# of data, as this should be the most relevant for our purposes.


# Initial data exploration: identifying correltations between the data.
#
data.corr()
plt.matshow(data.corr())
plt.show()
