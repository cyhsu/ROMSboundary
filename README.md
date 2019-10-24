# ROMSboundary


Goal:

  Automatic create the initial/boundary condition of ROMS.
  
Run:

  ./roms_copernicus.sh "initial_time" "end_time"
  
  ex:
  
  > ./roms_copernicus.sh "2019-01-01" "2019-02-01"
  >
  > ./roms_copernicus.sh "2019-01-01 12:00:00" "2019-02-01 12:00:00"
  
  ** Note **
  
    1. I have added two more days in case the user need to run the entire whole day of the last day, i.e. 2019-02-03 to be the "end_time" in the example.
    2. Since the Marine Copernicus Ocean Analysis product is daily product, if you pickup the hour before the 12:00:00, the program will extend your boundary condition from the day before the initial day, i.e. 2018-12-31 to be the "initial_time" in the example.
    
    
Requirements:

  1. PYROMS
  2. MARINE COPERNICUS PYTHON API
  3. YOUR ROMS Grid File
  
  
