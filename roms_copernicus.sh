#!/bin/bash
#-   Downloading the Marine Copernicus analysis and forecast data  
#-       - horizontal resolution : 0.083 x 0.083
#-       - temporal resolution : daily-mean
#-       - vertical resolution : 75 layers
#-       - from today to 9 days after
#---
#--- @C.Y. Hsu (2017-09-20)
#===================================================================

DEFU_DIR=`pwd`
WORK_DIR=$DEFU_DIR/ocn
#--  B4 initial the code  --
#- 1 : turn on python run  -
#- 0 : turn off python run -
debug_dw_python=1 #-- dw : download copernicus data
debug_pr_proces=0 #-- pr : pre-processing the netCDF
debug_xr_python=0 #-- xr : xroms regridding
debug_ic_python=0 #-- ic : initial condition
debug_bc_python=0 #-- bc : boundary condition 
debug_ro_python=0 #-- ro : reorginize the init/bdry cond

##--  PARAMETERS from cpl_gom.sh  --
t0=`date -d "$1 1 days ago" +"%F %H:00:00"`
t1=`date -d "$2 2 days" +"%F %H:00:00"`
dirc=run_"$3"

odir="${WORK_DIR}/input/previous/"
file=`echo $t0"_"$t1".nc"| sed -s 's/ ..:00:00//g'| sed -s 's/-//g'`
file="${odir}${file}"
savepath="${WORK_DIR}/${dirc}"

echo '   !!!  IMPORTANT WARNING: The input datetime "hours" is'
echo '        affecting when builting up the initial condition of ROMS.'
echo '        hours = "00", will ave the current data and 1 days ago  !!!'
echo '  '
echo '   roms_copernicus.sh: Curr DIR : ' $DEFU_DIR
echo '   roms_copernicus.sh: time in  : ' $t0
echo '   roms_copernicus.sh: time out : ' $t1
echo '   roms_copernicus.sh: save path: ' ${savepath}
echo '   roms_copernicus.sh: dw output: ' ${file}
echo '  '

if [ "$3" ] ; then
	mkdir -p "${savepath}"
fi

##--  ENVIRONMENTAL SET UP  --
if [ $debug_ic_python -eq 1 -o $debug_bc_python -eq 1 -o $debug_dw_python == 1 ]; then 
	module purge
	module load intel/2015a netCDF-Fortran/4.4.0-intel-2015a Anaconda/2-4.0.0 
	source activate chsu1
	export PYROMS_GRIDID_FILE=$WORK_DIR/grid/gridid.txt
	echo " "
fi

##--  PARAMETER SET UP : ..download process.. --
if [ $debug_dw_python == 1 ]; then 
	source "${WORK_DIR}/shell/coper_params.sh"
	echo '   **- Copernicus Download  ...... on'; echo ' '

	##-- DOWNLOAD : ..Copernicus analysis/forecast data.. --
	echo "      python $motu_py $svr_info $dom_info $dim_info $var_info -f $file"
	python $motu_py $svr_info $dom_info $dim_info $var_info -f $file

	##- .. Record the simulation ..
	ftime=`ls -l $file | awk '{print $6 $7}'`
	ftime=`date -d $ftime +%b%d`
	ntime=`date +%b%d`
	if [ $ntime == $ftime ]; then 
		echo "   Processing the simulation begins from "`date +%F ` "successful."
	else 
		echo "   Processing the simulation begins from "`date +%F ` " UNSUCCESSFUL."
		exit 1
	fi
fi

##--  Pre-PROCESS for PYROMS  --
cd $WORK_DIR
if [ $debug_pr_proces == 1 ]; then
	echo '   **- Pre-Process Dataset  ...... on'; echo ' '
	./shell/pre.sh "$1" "$file"

	##-- 	GRID FILE  --
	if [ $debug_ic_python -eq 1 -o $debug_bc_python -eq 1 ]; then 
		if [ ! -f ./grid/copernicus_grid.nc ]; then 
			echo '   **- Grid File for Copers ...... on'; echo ' ' 
			echo '       Grid File for Copers is missing. May I create one for you (yes/no)'
			read -p '       yes -- here, no -- yourself:' grid_ans
			if [ 'yes' == "$grid_ans" ]; then 
				./shell/pyroms_grid.sh "$file"
				ipython make_remap_weights_file.py
			else
				echo '      You choose no.' 
				echo '      Program stops here.'
				echo '      Notice: 1. size of the grid points have to larger than data point'
				echo '                         (x-1:x+1,y-1:y+1)                     (x,y)'
				echo '              2. run "make_remap_weights_file.py" if needed'
				exit 1
			fi
			echo '   **- Grid File for Copers ...... completed' 
		fi
	fi
fi

##--  XROMS SST update  --
if [ $debug_xr_python == 1 ]; then 
	echo '   **- XOMS Process         ...... on'; echo ' '
	./shell/xroms.sh
	mv ./ic_bdry/xroms_sst.nc ${savepath}/.
fi

##--  PYROMS Init Cond  --
if [ $debug_ic_python == 1 ]; then 
	echo '   **- Process Initial Cond ...... on'; echo ' '
	ipython make_ic_file.py > make_ic_file.out
	echo ' '
fi

##--  PYROMS Bdry Cond  --
if [ $debug_bc_python == 1 ]; then 
	echo '   **- Process BoundaryCond ...... on'; echo ' '
	ipython make_bdry_file.py > make_bdry_file.out
	echo ' '
fi

##--  revise routine_run_01.ocn.in ((i.e. ocean.in))  --
##--  revise ocean_time for ini/bdry  --
if [ $debug_ro_python -eq 1 -o $debug_ic_python -eq 1 -o $debug_bc_python -eq 1 ]; then 

	echo '   **- Process Final        ...... on'; echo ' '
	./shell/re_orig.sh "$1" ${savepath}
fi

##--  Remove all generated unnecessary files
rm ./input/copernicus_forecast*.nc


##-- Success the processing message
echo "	roms_copernicus.sh: Done! Completed all of the ocean process"
echo '   roms_copernicus.sh: time in  : ' $t0
echo '   roms_copernicus.sh: time out : ' $t1
echo '   roms_copernicus.sh: save path: ' ${savepath}
