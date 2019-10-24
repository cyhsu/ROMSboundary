#!/bin/bash
#-- 
#--
#--  Goal: pre-processing the copernicus dataset
#--  program: 
#--              1. NCO
#--
#--  @C.Y. Hsu at Texas A&M Univ, Mar 06 2019

module purge
module load Anaconda3/5.2.0
source activate nco
DEFU_DIR=`pwd`
ifile=$1

echo '      --- pre.sh / pyroms_grid.sh: Curr DIR' $DEFU_DIR

#-- Build up the grid file
gridnc='./grid/copernicus_grid.nc'	
ncrename -d longitude,lon -v longitude,lon "$ifile" "$grid_nc"
ncrename -d latitude,lat -v latitude,lat "$grid_nc"
ncrename -d depth,z -v depth,z "$grid_nc"
ncrename -d time,ocean_time -v time,ocean_time "$grid_nc"
ncrename -v thetao,temp -v so,salt -v uo,u -v vo,v -v zos,ssh "$grid_nc"
ncks -O -d ocean_time,0 -v temp "$grid_nc" "$grid_nc"
