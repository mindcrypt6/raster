# Author: Robert J. Hijmans, r.hijmans@gmail.com
# Date :  October 2008
# Version 0.9
# Licence GPL v3

if (!isGeneric("xres")) {
	setGeneric("xres", function(x)
		standardGeneric("xres"))
}

if (!isGeneric("yres")) {
	setGeneric("yres", function(x)
		standardGeneric("yres"))
}

if (!isGeneric("res")) {
	setGeneric("res", function(x)
		standardGeneric("res"))
}


setMethod('xres', signature(x='BasicRaster'), 
function(x) {
	e <- x@extent
	return ( (e@xmax - e@xmin) / x@ncols )  
} )

setMethod('yres', signature(x='BasicRaster'), 
function(x) {
	e <- x@extent
	return ( (e@ymax - e@ymin) / x@nrows )  
} )

setMethod('res', signature(x='BasicRaster'), 
function(x) {
	e <- x@extent
	xr <- (e@xmax - e@xmin) / x@ncols 
	yr <- (e@ymax - e@ymin) / x@nrows
	return( c(xr, yr) )
} )
