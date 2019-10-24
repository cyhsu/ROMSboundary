from netCDF4 import Dataset, num2date, date2num
from scipy.interpolate import interp2d 
from glob import glob
from datetime import datetime, timedelta
import numpy as np, os 

#-- parameters
ictim='2010-01-01 12:00:00'
units='seconds since '+ictim 
ictim=datetime.strptime(ictim,'%Y-%m-%d %H:%M:%S')

try:
	fid = glob('./ic_bdry/copernicus*bdry*.nc')[0]
	nc = Dataset(fid,'r+')
	tm = nc.variables['ocean_time']; tim= num2date(tm[:],tm.units); tm.units = units
	tm[:] = date2num(tim,tm.units)
	tm[1] = date2num(ictim,tm.units) 
	nc.close()
except:
	pass

try :
	fid = glob('./ic_bdry/copernicus*ic*.nc')[0]
	nc = Dataset(fid,'r+')
	tm = nc.variables['ocean_time']; tm.units = units
	tm[:] = date2num(ictim,tm.units)
	nc.close()
except:
	pass
