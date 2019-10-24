from netCDF4 import Dataset, num2date, date2num
from scipy.interpolate import interp2d 
from glob import glob
import numpy as np, os 
#-- Set up the time unit
units = 'days since 1900-01-01 00:00:00'

#-- Copy the xroms sample to a new nc file
fid = './ic_bdry/xroms_sst.nc'
os.system('cp ./ic_bdry/xroms_sst.nc.sample '+fid)

#-- Source file
nc = Dataset('./input/xroms_sst.nc')
tm = nc.variables['ocean_time']
tim= num2date(tm[:], tm.units)
sst= nc.variables['temp'][:]
nc.close()

#-- Target file
nc = Dataset(fid,'r+')
tmp= nc.variables['time']
tmp.units = units
tmp[:len(tim)] = date2num(tim,tmp.units)
tmp= nc.variables['SST']
tmp[:len(tim)] = sst
nc.close()
