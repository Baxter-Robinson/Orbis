#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Thu Mar 31 11:25:22 2022

@author: cyberdim
"""


import pandas as pd
import numpy as np

df = pd.read_csv("/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Business_Demography_LegalForm_RAW.csv")




for col in df.columns:
    print(col)

del(col)

df = df[["geo", "nace_r2","leg_form", "indic_sb", "TIME_PERIOD", "OBS_VALUE"]]

nace = sorted(list(set(df.nace_r2)))
indic = sorted(list(set(df.indic_sb)))
leg = sorted(list(set(df.leg_form)))
geo = sorted(list(set(df.geo)))
years = sorted(list(set(df.TIME_PERIOD)))


# Rows = countries x nace x time
rows = len(geo)*len(leg)*len(nace)*len(years)


# Columns
columns = 4+len(indic)
for i in range(0,len(indic)):
    print("'"+indic[i]+"',\\")

"""
panel = pd.DataFrame(data=np.full((rows, columns),0.0), columns = ['Country', \
                                                                 'Legal_Form', \
                                                                 'NACE',\
                                                                     'Year',\
                                                                   'V11910',\
                                                                'V11920',\
                                                                'V11930',\
                                                                'V16910',\
                                                                'V16911',\
                                                                'V16920',\
                                                                'V16921',\
                                                                'V16930',\
                                                                'V16931',\
                                                                'V97010',\
                                                                'V97015',\
                                                                'V97020',\
                                                                'V97022',\
                                                                'V97023',\
                                                                'V97030',\
                                                                'V97031',\
                                                                'V97120',\
                                                                'V97121',\
                                                                'V97122',\
                                                                'V97130',\
                                                                'V97131'])
"""

panel = pd.DataFrame(data=np.full((rows, columns),np.nan), columns = ['Country', \
                                                                 'Legal_Form', \
                                                                 'NACE',\
                                                                     'Year',\
                                                                   'V11910',\
                                                                'V11920',\
                                                                'V11930',\
                                                                'V16910',\
                                                                'V16911',\
                                                                'V16920',\
                                                                'V16921',\
                                                                'V16930',\
                                                                'V16931',\
                                                                'V97010',\
                                                                'V97015',\
                                                                'V97020',\
                                                                'V97022',\
                                                                'V97023',\
                                                                'V97030',\
                                                                'V97031',\
                                                                'V97120',\
                                                                'V97121',\
                                                                'V97122',\
                                                                'V97130',\
                                                                'V97131'])
    
    
index_filler=[]
for i in range(0,len(geo)):
    for j in range(0,len(leg)):
        for k in range(0,len(nace)):
            for l in range(0,len(years)):
                index_filler.append((i,j,k,l))
                
    
for i in range(0,len(panel)):
    c = index_filler[i][0]
    l = index_filler[i][1]
    n = index_filler[i][2]
    y = index_filler[i][3]
    panel['Country'].iloc[i]=geo[c]
    panel['Legal_Form'].iloc[i]=leg[l]
    panel['NACE'].iloc[i]=nace[n]
    panel['Year'].iloc[i]=years[y]
    if ((i>0) and (len(panel) % i ==1000)):
        print("missing panel info", len(panel)-i)

                

for i in range(0,len(panel)):
    c = index_filler[i][0]
    l = index_filler[i][1]
    n = index_filler[i][2]
    y = index_filler[i][3]
    mini = df[df['geo']==geo[c]]
    mini = mini[mini['leg_form']==leg[l]]
    mini = mini[mini['nace_r2']==nace[n]]
    mini = mini[mini['TIME_PERIOD']==years[y]]
    mini = mini.reset_index(drop=True)
    for m in range(0,len(mini)):
        ind = mini["indic_sb"].iloc[m]
        val = mini["OBS_VALUE"].iloc[m]
        panel[ind].iloc[i]= val
    if ((i>0) and (len(panel) % i ==1000)):
        print("missing panel values", len(panel)-i)
        
        

panel.to_csv("/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Business_Demography_LegalForm.csv", index=False)
    

