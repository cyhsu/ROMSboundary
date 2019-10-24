#!/bin/bash
#-- 
#--
#--  Goal: Copernicus Parameter Setup
#--
#--  @C.Y. Hsu at Texas A&M Univ, Mar 06 2019
motu_dir='/home/chsu1/scratch/GOM_FORECAST/ocn/Copernicus/motu-client-python/'
motu_py=$motu_dir"motu-client.py"
username='chsu1'; password='Gisr@2017'
http_m='http://nrtcmems.mercator-ocean.fr/motu-web/Motu'
http_s='GLOBAL_ANALYSIS_FORECAST_PHY_001_024-TDS'
http_d='global-analysis-forecast-phy-001-024'
leftlow_corner_lon=-101
leftlow_corner_lat=10 
rightup_corner_lon=-75
rightup_corner_lat=35
z0=0.493 
z1=5902.0583
var0='zos'
var1='thetao'
var2='so'
var3='uo'
var4='vo'
svr_info="-u $username -p $password -m $http_m -s $http_s -d $http_d"
dom_info="-x $leftlow_corner_lon -X $rightup_corner_lon"
dom_info="$dom_info -y $leftlow_corner_lat -Y $rightup_corner_lat"
dim_info="-t $t0 -T $t1 -z $z0 -Z $z1"
var_info="-v $var0 -v $var1 -v $var2 -v $var3 -v $var4"
