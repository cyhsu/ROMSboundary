
Regridding by nco.

— to use the latest version of nco, please do “conda install nco” based on your virtual environment
— ncremap is the command we want to use.

     Requirement
=============
    - ncremap only recognize “lon” and “lat” in horizontal. Any variable associated with the “longitude” and “latitude” attribute and not named by “lon” and “lat”, need to rename it. 
    - If an extrapolation is not needed, default interpolation is “bilinear”, 
		which can be easily use 

			ncremap -i in.nc -v name_of_var -d destination_grid.nc -o destination_regridding_output.nc 
	
		You can also specify the interpolation method by use -a argument, some examples…

				-a bilinear (or billion, blin, bln)
				-a conserve (or conservative, cns, cl, aave)
				-a conserve2nd (or conservative2nd, c2, c2nd)
				-a nearestdtos (or nds, dtos, ndtos)
				-a nearestidavg
				-a patch

				detail info, check here

		- if an extrapolation is needed, I currently use “neareststod” method, and also specify the mask template on both source/destination file. Here is the command I use in the xroms case.

			ncremap -a neareststod --rnr=0.25 -i abc_in3.nc -v temp -m copernicus2xroms_mapping.nc\
					    -d xroms_lonlat.nc -o xroms_grid_temp.nc --msk_src=temp --msk_dst=mask

		  Below is the detail of the arguments

				‘--msk_dst=msk_dst (--msk_dst, --dst_msk, --mask_destination, --mask_dst)’
					Specifies a template variable to use for the integer mask of the destination grid when inferring grid files and/or creating map-files (i.e., generating weights). Any variable on the same horizontal grid as a data file can serve as a mask template for that grid. The mask will be one (i.e., gridcells will participate in regridding) where msk_dst has valid values in the data file from which NCO infers the destination grid. The mask will be zero (i.e., gridcells will not participate in regridding) where msk_nm has a missing value. A typical example of this option would be to use Sea-surface Temperature (SST) as a template variable for an ocean mask because SST is often defined only over ocean, and missing values might denote locations to which regridded quantities should never be placed. msk_dst, msk_out, and msk_src are related yet distinct: msk_dst is the mask template variable in the destination file (whose grid will be inferred), msk_out is the name to give the destination mask in any regridded file, and msk_src is the mask template variable in the source file (whose grid will be inferred). The special value msk_dst = none prevents the regridder from inferring and treating any variable (even one named, e.g., mask) in a source file as a mask variable. This guarantees that all points in the inferred destination grid will be unmasked.

				‘--msk_out=msk_out (--msk_out, --out_msk, --mask_destination, --mask_out)’
					Use of this option tells ncremap to include a variable named msk_out in any regridded file. The variable msk_out will contain the integer-valued regridding mask on the destination grid. The mask will be one (i.e., fields may have valid values in this gridcell) or zero (i.e., fields will have missing values in this gridcell). By default, ncremap does not output the destination mask to the regridded file. This option changes that default behavior and causes ncremap to ingest the default destination mask variable contained in the map-file. ERWG generates SCRIP-format map-files that contain the destination mask in the variable named mask_b. SCRIP generates map-files that contain the destination mask in the variable named dst_grid_imask. The msk_out option works with map-files that adhere to either of these conventions. Tempest generates map-files that do not typically contain the destination mask, and so the msk_out option has no effect on files that Tempest regrids. msk_dst, msk_out, and msk_src are related yet distinct: msk_dst is the mask template variable in the destination file (whose grid will be inferred), msk_out is the name to give the destination mask in any regridded file, and msk_src is the mask template variable in the source file (whose grid will be inferred).

				‘--msk_src=msk_src (--msk_src, --src_msk, --mask_source, --mask_src)’
					Specifies a template variable to use for the integer mask of the source grid when inferring grid files and/or creating map-files (i.e., generating weights). Any variable on the same horizontal grid as a data file can serve as a mask template for that grid. The mask will be one (i.e., gridcells will participate in regridding) where msk_src has valid values in the data file from which NCO infers the source grid. The mask will be zero (i.e., gridcells will not participate in regridding) where msk_nm has a missing value. A typical example of this option would be to use Sea-surface Temperature (SST) as a template variable for an ocean mask because SST is often defined only over ocean, and missing values might denote locations from which regridded quantities should emanate. msk_dst, msk_out, and msk_src are related yet distinct: msk_dst is the mask template variable in the destination file (whose grid will be inferred), msk_out is the name to give the destination mask in any regridded file, and msk_src is the mask template variable in the source file (whose grid will be inferred). The special value msk_src = none prevents the regridder from inferring and treating any variable (even one named, e.g., mask) in a source file as a mask variable. This guarantees that all points in the inferred source grid will be unmasked.

				‘-m map_fl (--map_fl, --map, --map_file, --rgr_map, --regrid_map)’
					Specifies a mapfile (i.e., weight-file) to remap the source to destination grid. If map_fl is specified in conjunction with any of the ‘-d’, ‘-G’, ‘-g’, or ‘-s’ switches, then ncremap will name the internally generated mapfile map_fl. Otherwise (i.e., if none of the source-grid switches are used), ncremap assumes that map_fl is a pre-computed mapfile. In that case, the map_fl must be in SCRIP format, although it may have been produced by any application (usually ERWG or TempestRemap). If map_fl has only cell-center coordinates (and no edges), then NCO will guess-at or interpolate the edges. If map_fl has cell boundaries then NCO will use those. A pre-computed map_fl is not modified, and may have read-only permissions. The user will be prompted to confirm if a newly generated map-file named map_fl would overwrite an existing file. ncremap adds provenance information to any newly generated map-file whose name was specified with ‘-m map_fl’. This provenance includes a history attribute that contains the command invoking ncremap, and the map-generating command invoked by ncremap.

				‘-r rnr_thr (--rnr_thr, --thr_rnr, --rnr, --renormalize_threshold)’
					Use this option to request renormalization (see Regridding) and to specify the weight threshold. For example, ‘-r 0.9’ tells the regridder to renormalize with a weight threshold of 90%, so that all destination gridcells with at least 90% of their area contributed by valid source gridcells will be contain valid (not missing) values that are the area-weighted mean of the valid source values. This option was introduced because renormalization is a frequently used feature which previously could only be invoked by using the uglier and more generic -R rgr_opt option defined above. Specifying ‘-r 0.9’ and ‘--rnr_thr=0.9’ are equivalent.


		Additionally, I want to introduce some arguments that is related to “extrapolation”, which might be important in the future use.

				‘--xtr_typ=xtr_typ (--xtr_typ, --xtr_mth, --extrap_type, --extrap_method)’
					Specifies the extrapolation method used to compute unmapped destination point values with the ERWG weight generator. Valid values and their synonyms are neareststod (synonyms stod and nsd), nearestidavg (synonyms idavg and id), and none (synonyms nil and nowaydude). Default is xtr_typ = none. The arguments to options ‘--xtr_xpn=xtr_xpn’ and ‘--xtr_nsp=xtr_nsp’ provide parameters that control the extrapolation neareststod and nearestidavg algorithms. For more information on ERWG extrapolation, see documentation here. NCO supports this feature as of version 4.7.4 (April, 2018).

				‘--xtr_nsp=xtr_nsp (--xtr_nsp, --xtr_pnt_src_nbr, --extrap_num_src_pnts)’
					Specifies the number of source points to use in extrapolating unmapped destination point values with the ERWG weight generator. This option is only useful in conjunction with explicitly requested extrapolation types xtr_typ = neareststod and xtr_typ = nearestidavg. Default is xtr_nsp = 8. For more information on ERWG extrapolation, see documentation here. NCO supports this feature as of version 4.7.4 (April, 2018).

				‘--xtr_xpn=xtr_xpn (--xtr_xpn, --xtr_pnt_src_nbr, --extrap_num_src_pnts)’
					Specifies the number of source points to use in extrapolating unmapped destination point values with the ERWG weight generator. This option is only useful in conjunction with explicitly requested extrapolation types xtr_typ = neareststod and xtr_typ = nearestidavg. Default is xtr_xpn = 2.0. For more information on ERWG extrapolation, see documentation here. NCO supports this feature as of version 4.7.4 (April, 2018).



Note: It looks like this way is also working, even though I got a warming message….
ncremap -a neareststod --rnr=0.25 -i copernicus_forecast_00.nc -v temp -d xroms_lonlat.nc -o xroms_grid_temp2.nc --msk_src=temp --msk_dst=mask
