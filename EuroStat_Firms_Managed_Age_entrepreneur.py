#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Wed Mar 30 10:49:46 2022

@author: cyberdim
"""

import pandas as pd
import numpy as np

#df = pd.read_csv("/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Firms_Managed_Age_entrepreneur_RAW.csv")

df = pd.read_csv("/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Firms_Managed_Age_entrepreneur_RAW.csv")


for col in df.columns:
    print(col)

del(col)

df = df[["age", "nace_r1", "indic_fb", "geo", "TIME_PERIOD", "OBS_VALUE"]]

mini = df[0:50]

age = sorted(list(set(df.age)))
nace = sorted(list(set(df.nace_r1)))
indic = sorted(list(set(df.indic_fb)))
geo = sorted(list(set(df.geo)))
years = sorted(list(set(df.TIME_PERIOD)))

# Rows = countries x age x nace x time
rows = len(geo)*len(age)*len(nace)*len(years)

# Columns = countries + age + nace + indic + year
ncols = 4+len(indic)


for i in range(0,len(indic)):
    print("'"+indic[i]+"',\\")



panel = pd.DataFrame(data=np.full((rows, ncols),0.0), columns = ['Country', \
                                                                 'Age_Founder', \
                                                                 'NACE',\
                                                                     'Year',\
                                                                    '101_A',\
                                                                    '101_N',\
                                                                    '201_A',\
                                                                    '201_C',\
                                                                    '201_T',\
                                                                    '202_A',\
                                                                    '202_B',\
                                                                    '202_C',\
                                                                    '202_D',\
                                                                    '202_E',\
                                                                    '202_F',\
                                                                    '202_G',\
                                                                    '202_H',\
                                                                    '202_I',\
                                                                    '202_J',\
                                                                    '202_K',\
                                                                    '202_L',\
                                                                    '202_M',\
                                                                    '202_T',\
                                                                    '203_A',\
                                                                    '203_B',\
                                                                    '203_C',\
                                                                    '203_D',\
                                                                    '203_E',\
                                                                    '203_F',\
                                                                    '203_G',\
                                                                    '203_T',\
                                                                    '204_A',\
                                                                    '204_B',\
                                                                    '204_C',\
                                                                    '204_D',\
                                                                    '204_E',\
                                                                    '204_F',\
                                                                    '204_G',\
                                                                    '204_H',\
                                                                    '204_I',\
                                                                    '204_J',\
                                                                    '204_K',\
                                                                    '204_T',\
                                                                    '205_A',\
                                                                    '205_B',\
                                                                    '205_C',\
                                                                    '205_D',\
                                                                    '205_E',\
                                                                    '205_T',\
                                                                    '206_A',\
                                                                    '206_B',\
                                                                    '206_T',\
                                                                    '207_A',\
                                                                    '207_B',\
                                                                    '207_C',\
                                                                    '207_T',\
                                                                    '208_A',\
                                                                    '208_B',\
                                                                    '208_C',\
                                                                    '208_T',\
                                                                    '209_A',\
                                                                    '209_B',\
                                                                    '209_C',\
                                                                    '209_D',\
                                                                    '209_E',\
                                                                    '209_F',\
                                                                    '209_G',\
                                                                    '209_H',\
                                                                    '209_I',\
                                                                    '209_T',\
                                                                    '210_A',\
                                                                    '210_B',\
                                                                    '210_T',\
                                                                    '214_A',\
                                                                    '214_B',\
                                                                    '214_C',\
                                                                    '214_D',\
                                                                    '214_T',\
                                                                    '301_A',\
                                                                    '301_B',\
                                                                    '301_C',\
                                                                    '301_T',\
                                                                    '302_A',\
                                                                    '302_B',\
                                                                    '303_A',\
                                                                    '304_A',\
                                                                    '305_A',\
                                                                    '305_B',\
                                                                    '305_C',\
                                                                    '305_T',\
                                                                    '306_A',\
                                                                    '306_B',\
                                                                    '306_C',\
                                                                    '306_D',\
                                                                    '306_T',\
                                                                    '307_A',\
                                                                    '307_B',\
                                                                    '307_C',\
                                                                    '307_D',\
                                                                    '307_T',\
                                                                    '308_A',\
                                                                    '308_B',\
                                                                    '308_C',\
                                                                    '308_D',\
                                                                    '308_E',\
                                                                    '308_T',\
                                                                    '309_A',\
                                                                    '309_B',\
                                                                    '309_C',\
                                                                    '309_D',\
                                                                    '309_T',\
                                                                    '310_A',\
                                                                    '310_B',\
                                                                    '310_C',\
                                                                    '310_D',\
                                                                    '310_T',\
                                                                    '311_A',\
                                                                    '311_B',\
                                                                    '311_C',\
                                                                    '311_D',\
                                                                    '311_E',\
                                                                    '311_F',\
                                                                    '311_G',\
                                                                    '311_H',\
                                                                    '311_I',\
                                                                    '311_J',\
                                                                    '311_K',\
                                                                    '311_L',\
                                                                    '311_T',\
                                                                    '401_A',\
                                                                    '401_B',\
                                                                    '401_C',\
                                                                    '401_D',\
                                                                    '401_E',\
                                                                    '401_T',\
                                                                    '402_A',\
                                                                    '402_B',\
                                                                    '402_C',\
                                                                    '402_D',\
                                                                    '402_T',\
                                                                    '403_A',\
                                                                    '403_B',\
                                                                    '403_C',\
                                                                    '403_D',\
                                                                    '403_E',\
                                                                    '403_F',\
                                                                    '403_G',\
                                                                    '403_T' ])


    
index_filler = []
for i in range(0,len(geo)):
    for j in range(0,len(age)):
        for k in range(0,len(nace)):
            for y in range(0,len(years)):
                index_filler.append((i,j,k,y))


for i in range(0,len(panel)):
    c = index_filler[i][0]
    a = index_filler[i][1]
    n = index_filler[i][2]
    y = index_filler[i][3]
    panel['Country'].iloc[i]=geo[c]
    panel['Age_Founder'].iloc[i]=age[a]
    panel['NACE'].iloc[i]=nace[n]
    panel['Year'].iloc[i]=years[y]
    

for i in range(0,len(panel)):
    c = index_filler[i][0]
    a = index_filler[i][1]
    n = index_filler[i][2]
    y = index_filler[i][3]
    mini = df[df['geo']==geo[c]]
    mini = mini[mini['age']==age[a]]
    mini = mini[mini['nace_r1']==nace[n]]
    mini = mini[mini['TIME_PERIOD']==years[y]]
    mini = mini.reset_index(drop=True)    
    for m in range(0,len(mini)):
        panel.iloc[i,m+4]=mini['OBS_VALUE'].iloc[m]


panel.to_csv("/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Firms_Managed_Age_entrepreneur.csv")
