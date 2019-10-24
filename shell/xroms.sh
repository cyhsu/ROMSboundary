#!/bin/bash
#-- 
#--
#--  Goal: processing the copernicus sst to xroms.
#--  program: 
#--              1. NCO
#--              2. PYTHON: netCDF4
#--
#--  @C.Y. Hsu at Texas A&M Univ, Feb 27 2019

module purge
module load Anaconda3/5.2.0
source activate nco
DEFU_DIR=`pwd`
cd input

#-- Convert Copernicus --> regridding --> xroms
echo "      --- xroms.sh: Curr DIR : " `pwd`
#for fid in ./copernicus_forecast_*nc
for fid in ./copernicus_forecast.nc
do
	#-- Set up the name of new files 
	nfid=`echo $fid | sed 's/copernicus_forecast/c2x/g'`
	xfid=`echo $fid | sed 's/copernicus_forecast/xroms_sst/g'`
	echo "      --- xroms.sh: Convert $fid to $nfid to $xfid ...   "

 	ncks -O -h -d z,0 -C -v temp,lat,lon $fid $nfid
 	ncwa -O -h -a z $nfid $nfid
 	#ncwa -O -h -a ocean_time,z $nfid $nfid
 	if [ ! -f './map_c2x.nc' ]; then 
 		echo '      -- Pre-compute mapping file : ./map_c2x.nc --   '
 		ncremap -s $nfid -m './map_c2x.nc' -d './xroms_lonlat.nc' \
              && --msk_src=temp --msk_dst=mask
 	fi
 	
#	time	ncremap -a neareststod --rnr=0.25 -i $nfid -m ./map_c2x.nc -o $xfid \
	ncremap -a neareststod --rnr=0.25 -i $nfid -m ./map_c2x.nc -o $xfid \
           -t 1 --msk_src=temp --msk_dst=mask > outmsg_remap
	ncks -v ocean_time -A $fid $xfid

	###	#-- testing mode
	###	echo '      break' `break`
done
#-- Back to default path
cd $DEFU_DIR

#-- pull xroms_sst to xroms file in grid.
echo "      --- xroms.sh: Pull the regridding data into ./ic_bdry/xroms_sst.nc ...   "
#ipython xroms.py
~/.conda/envs/nco/bin/ipython xroms.py

#-- Remove generated trash files.
echo "      --- xroms.sh: Remove generated trash files during processing ...   "
rm ./input/c2x*.nc
rm ./input/xroms_sst.nc
echo "      --- xroms.sh: Complete the XROMS Package ...   "
echo " "

