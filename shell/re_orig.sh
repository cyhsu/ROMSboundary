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
WORK_DIR=$2
init="ROMS_init.nc"
bdry="ROMS_bdry.nc"

echo '      --- re_orig.sh : Curr DIR' $DEFU_DIR
echo '      --- re_orig.sh : Work DIR' $WORK_DIR

cd $WORK_DIR
#-- merge generated files and remove it.
echo '      --- re_orig.sh : merge init cond'
find '../ic_bdry' -maxdepth 1 -name "coper*_ic_*nc" | while read fid
do
	ncks -A $fid $init
	rm $fid
done


echo '      --- re_orig.sh : merge bdry cond'
find '../ic_bdry' -maxdepth 1 -name "coper*_bdry_*nc" | while read fid
do
	ncks -A $fid $bdry
	rm $fid
done

#-- Build ocean.in
echo '      --- re_orig.sh : build up ocean.in'
cp "$DEFU_DIR/routine_run_01.ocn.in.sample" ocean.in
hh=`awk "BEGIN {print $(date -d "$t0" +%H)/24}" |sed 's/0.//'`
TIME_REF=`date -d "$t0" +%Y%m%d`"."$hh
sed -i "s/20170922.5/$TIME_REF/g" ocean.in 

#-- Complete the init/bdry
cd $DEFU_DIR
echo '      --- re_orig.sh : revise time'
ic_time=`date -d "$1" +"%F 12:00:00"`
cp ic_bdry.py.sample ic_bdry.py
sed -i "s/2017-01-01 12:00:00/${ic_time}/g" ic_bdry.py
~/.conda/envs/nco/bin/ipython ic_bdry.py


echo '      --- re_orig.sh : Complete init/bdry Package'
echo ' '
