import subprocess, os, commands, numpy as np
import pyroms, pyroms_toolbox
from remap_xroms import remap_xroms

src_file = './input/Copernicus_forecast.nc'
dst_dir='./xroms_bdry/'

src_grd_file = './grid/copernicus_grid.nc'
src_grd = pyroms_toolbox.Grid_HYCOM.get_nc_Grid_Copernicus(src_grd_file)
dst_grd = pyroms.grid.get_ROMS_grid('GOM_Copernicus')

# remap
xroms = remap(src_file, src_grd)

