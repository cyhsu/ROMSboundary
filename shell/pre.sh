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
ifile=$2

echo '      --- pre.sh:' $1
echo '      --- pre.sh: Curr DIR ' $DEFU_DIR

#--  re-dimension and rename the variables.
echo '      --- pre.sh: re-dimension and rename the variable' 
nfile='./input/copernicus_forecast.nc'
ncrename -O -d longitude,lon -v longitude,lon "$ifile" "$nfile"
ncrename -d latitude,lat -v latitude,lat "$nfile"
ncrename -d depth,z -v depth,z "$nfile"
ncrename -d time,ocean_time -v time,ocean_time "$nfile"
ncrename -v thetao,temp -v so,salt -v uo,u -v vo,v -v zos,ssh "$nfile"
ncks -O -d lon,1,-2 -d lat,1,-2 "$nfile" "$nfile"
ncks -O --fix_rec_dmn ocean_time $nfile $nfile

#--  slice up by time
echo '      --- pre.sh: subset the copernicus data by time' 
num=`ncdump -h $nfile |grep ocean_time|head -1|awk '{print $3}'`
for tid in $(eval echo {0..$((num-1))})
do
	nfid=`printf ./input/copernicus_forecast_%02d.nc $tid`
	ncks -O -h -d ocean_time,$tid $nfile $nfid
done

#--  check input_time for initial condition.
echo '      --- pre.sh: check the input hour' 
ti=`date -d "$1" +"%F %H:00:00"`
tim_ini_hour=`date -d "$1" +"%F %H:00:00"`
if [ "$tim_ini_hour" == "00" ]; then 
	cd input
	ncra copernicus_forecast_00.nc copernicus_forecast_01.nc copernicus_forecast_01.nc
fi

echo '      --- pre.sh: completed' 
echo '      '
