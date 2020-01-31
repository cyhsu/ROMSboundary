# ROMSboundary


Goal:

  Automatically create the initial/boundary condition of ROMS.
  
Run:  
>  ./roms_copernicus.sh "initial_time" "end_time"
>  
>  ex:  
> ./roms_copernicus.sh "2019-01-01" "2019-02-01"  
> ./roms_copernicus.sh "2019-01-01 12:00:00" "2019-02-01 12:00:00"  
  
** Note **    
- 1. This application will automatically increase two more days of the "end_time". In other words, if the user input "2019-02-01" as the end_time, then the user will receive "2019-02-03" in the end.    
- 2. Because the Marine Copernicus Ocean Analysis product is a daily product, if you pick up the hour before the 12Z, this application will pull one more day before the initial day you provide on the boundary condition. For example, if users gave "2019-01-01 00Z" as the initial time,  the application will also build the "2018-12-31" boundary condition for use.   
    
Requirements:

  1. PYROMS
  2. MARINE COPERNICUS PYTHON API
  3. YOUR ROMS Grid File
  
  

[![DOI](https://zenodo.org/badge/217359291.svg)](https://zenodo.org/badge/latestdoi/217359291)
