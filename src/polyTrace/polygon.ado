**** polyTrace (can come up with a better name)
** To set up the GPS trace collected by Survey CTO in a format usable by spmaps
** Written by: Roshni Khincha

capture program drop polyTrace

program define polyTrace
	* Set version
	version 12
	
	* Setup
	syntax varlist 	using	/// For 1 variable now. 
		, uid(varname)
		di "all good "
		
	foreach var of varlist `varlist'	{

		* Split each end of plygon into 1 variable each 
		split `var', parse(";")		// Survey CTO usese ; to separate the coordinates
		
		rename `var' `var'_str
		* Reshape to long (1 row per GPS point)
		reshape long `var', i(`uid') j(id)	
		
		drop if missing(`var'_str)	// Ensuring there are no mising values
		
		
		keep `uid' `var' id

		
		** Splitting up to get latitude and longitude in different columns
		split `var' 	// As they are separated by spaces
		drop if missing(`var')	// Dropping blank points
		
		** Renaming to make coordinates understandable
		rename `var'1 `var'_lat	
		rename `var'2 `var'_lng
		rename `var'3 `var'_alt
		
			
		drop `var' 	// We do not need this further
		
		destring `var'_lat, replace
		destring `var'_lng, replace
	}
	
	export delimited `using', replace
*/
		/*
	tempfile gps
	preserve
	g obs=_n
	bys mkt_name: g e=1+(_N==_n)
	expand e
	bys mkt_name (obs): replace lat="" if _n==_N
	bys mkt_name (obs): replace lng="" if _n==_N
	
	replace id = 0 if missing(lat)
	sort mkt_name id
	
	drop obs e
	
	rename mkt_name _ID


	
	gen byvar_pl = 1
	
		rename lat _Y
		rename lng _X
		
	
	save "$HFC/Polygon/dta/polygon_shp.dta", replace
	restore
	*/
end

** Checking command

	import delimited "C:/Users/WB528092/Downloads/trace_demo.csv", clear
	
	gen gps = trace
	polyTrace trace gps using "C:/Users/WB528092/Downloads/trace_demo_out.csv", uid(uid) 
	