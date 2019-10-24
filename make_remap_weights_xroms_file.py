import matplotlib
import pyroms
import pyroms_toolbox
matplotlib.use('Agg')

# load the grid
srcgrd = pyroms_toolbox.Grid_HYCOM.get_nc_Grid_Copernicus('./grid/copernicus_grid.nc')
dstgrd = pyroms.grid.get_ROMS_grid('GOM_Copernicus')

# make remap grid file for scrip
pyroms_toolbox.Grid_HYCOM.make_remap_grid_file(srcgrd)
pyroms.remapping.make_remap_grid_file(dstgrd, Cpos='rho')

# compute remap weights
# input namelist variables for bilinear remapping at rho points
grid1_file = './remap_grid_XROMS_PHY001_024_TDS_t.nc'
grid2_file = './remap_grid_XROMS_GOM_Copernicus_rho.nc'
interp_file1 = './remap/weights_XROMS_t_to_rho.nc'
interp_file2 = './remap/weights_XROMS_rho_to_t.nc'
map1_name = 'COP_001_024_TDS to ROMS Bilinear Mapping'
map2_name = 'ROMS to COP_001_024_TDS Bilinear Mapping'
num_maps = 1
map_method = 'bilinear'

pyroms.remapping.compute_remap_weights(grid1_file, grid2_file, \
              interp_file1, interp_file2, map1_name, \
              map2_name, num_maps, map_method)
