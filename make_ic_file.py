import subprocess, os, commands, numpy as np
import matplotlib
matplotlib.use('Agg')

import pyroms
import pyroms_toolbox

from remap import remap
from remap_uv import remap_uv


file = './input/copernicus_forecast_01.nc'
dst_dir='./ic_bdry/'

print 'Build IC file from the following file:'
print file
print ' '

src_grd_file = './grid/copernicus_grid.nc'
src_grd = pyroms_toolbox.Grid_HYCOM.get_nc_Grid_Copernicus(src_grd_file)
dst_grd = pyroms.grid.get_ROMS_grid('GOM_Copernicus')

# remap
zeta = remap(file, 'ssh', src_grd, dst_grd, dst_dir=dst_dir)
dst_grd = pyroms.grid.get_ROMS_grid('GOM_Copernicus', zeta=zeta)
remap(file, 'temp', src_grd, dst_grd, dst_dir=dst_dir)
remap(file, 'salt', src_grd, dst_grd, dst_dir=dst_dir)
remap_uv(file, src_grd, dst_grd, dst_dir=dst_dir)

