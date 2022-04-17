#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Apr  1 20:32:35 2022

@author: cyberdim
"""


import pandas as pd
import numpy as np

df = pd.read_csv("/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Raw/EuroStat_Annual_Enterprise_Statistics_RAW.csv")

df = df.fillna(" ")

columns = []
for col in df.columns:
    columns.append(col)

del(col)

df = df[["nace_r2", "indic_sb", "geo", "size_emp", "TIME_PERIOD", "OBS_VALUE"]]


nace = sorted(list(set(df.nace_r2)))
indic = sorted(list(set(df.indic_sb)))
countries = sorted(list(set(df.geo)))
years = sorted(list(set(df.TIME_PERIOD)))
size =  sorted(list(set(df.size_emp)))

#Rows are countries x years x nace
rows = len(nace)*len(countries)*len(years)*len(size)


columns = ["Country", "Year", "NACE_Rev2", "Size", "Index"]
cols = 5

panel =  pd.DataFrame(data=np.full((rows,cols),0.0), columns = columns)


countries_index = []
for i in range(0,len(countries)):
    countries_index.append(i)

nace_index=[]
for i in range(0,len(nace)):
    nace_index.append(i)
    
years_index=[]
for i in range(0,len(years)):
    years_index.append(i)

size_index=[]
for i in range(0,len(size)):
    size_index.append(i)



countries_dic = {countries[i]: countries_index[i] for i in range(len(countries))}
nace_dic = {nace[i]: nace_index[i] for i in range(len(nace))}
years_dic = {years[i]: years_index[i] for i in range(len(years))}
size_dic = {size[i]: size_index[i] for i in range(len(size))}

countries_dic2 = {countries_index[i]: countries[i] for i in range(len(countries))}
nace_dic2 = {nace_index[i]: nace[i] for i in range(len(nace))}
years_dic2 = {years_index[i]: years[i] for i in range(len(years))}
size_dic2 = {size_index[i]:size[i] for i in range(len(size))}


del(countries_index, nace_index, years_index, size_index )
del(i)


def dicvalue(x,dic):
    return(dic[x])

#dicvalue('AT',countries_dic)

def index_maker(country,nace,year,size):
    c=dicvalue(country,countries_dic)
    n=dicvalue(nace,nace_dic)
    y=dicvalue(year,years_dic)
    s=dicvalue(size,size_dic)
    return str(c)+"-"+str(n)+"-"+str(y)+"-"+str(s)


df["Index"]=np.vectorize(index_maker)(df["geo"],df["nace_r2"],df["TIME_PERIOD"],df["size_emp"] )


index_filler = []
for i in range(0,len(countries)):
    for j in range(0,len(nace)):
        for k in range(0,len(years)):
            for l in range(0,len(size)):
                index_filler.append((i,j,k,l))

l_country = []
l_nace = []
l_years =[]
l_size = []

for i in range(0,len(index_filler)):
    l_country.append(index_filler[i][0])
    l_nace.append(index_filler[i][1]) 
    l_years.append(index_filler[i][2])
    l_size.append(index_filler[i][3]) 

del(i)

panel["Country"] = np.vectorize(dicvalue)(l_country,countries_dic2 )
panel["NACE_Rev2"] = np.vectorize(dicvalue)(l_nace,nace_dic2 )
panel["Year"] = np.vectorize(dicvalue)(l_years,years_dic2 )
panel["Size"] = np.vectorize(dicvalue)(l_size,size_dic2 )

panel["Index"] = np.vectorize(index_maker)(panel["Country"],panel["NACE_Rev2"],panel["Year"],panel["Size"])

del(l_country, l_nace, l_years, l_size)

index_df = sorted(list(set(df["Index"])))


panel["Index2"]=panel["Index"]
df["Index2"]=df["Index"]
panel=panel.set_index('Index2')
df=df.set_index('Index2')


for i in range(0,len(indic)):
    mini = df[df['indic_sb']==str(indic[i])]
    mini = mini[['OBS_VALUE']]
    mini = mini.rename(columns={"OBS_VALUE":str(indic[i])})
    panel = pd.concat([panel,mini], axis=1)
    print(i)


panel = panel.reset_index(drop=True)
panel.to_csv('/Users/cyberdim/Dropbox/Shared-Folder_Baxter-Javier/Orbis/Data_Cleaned/EuroStat_Structural.csv')  



