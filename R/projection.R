# Author: Robert J. Hijmans
# Date :  January 2009
# Version 0.9
# Licence GPL v3




setMethod("crs", signature('ANY'), 
	function(x, asText=FALSE, ...) {
		projection(x, asText=asText)
	}
)


#'crs<-' <- function(x, value) {
#	projection(x) <- value
#	x
#}

setMethod("crs<-", signature('BasicRaster', 'ANY'), 
	function(x, ..., value) {
		projection(x) <- value
		x
	}
)

setMethod("crs<-", signature('Spatial', 'ANY'), 
	function(x, ..., value) {
		projection(x) <- value
		x
	}
)

setMethod('is.na', signature(x='CRS'), 
	function(x) {
		is.na(x@projargs)
	}
)


setMethod('as.character', signature(x='CRS'), 
	function(x, ...) {
		x@projargs
	}
)

'projection<-' <- function(x, value) {

	if (class(value)=="CRS") {
		crs <- value
	} else {	
		crs <- .newCRS(value)
	}	
	
	if (inherits(x, 'RasterStack')) {
		if (nlayers(x) > 0) {
			for (i in 1:nlayers(x)) {
				x@layers[[i]]@crs <- crs
			}
		}
	} 
	if (inherits(x, 'Spatial')) {
		x@proj4string <- crs
	} else {
		x@crs <- crs
	}
	return(x)
	
}



projection <- function(x, asText=TRUE) {

	if (methods::extends(class(x), "BasicRaster")) { 
		x <- x@crs 
	} else if (methods::extends(class(x), "Spatial")) { 
		x <- x@proj4string
	} else if (methods::extends(class(x), "sf")) {
		return( attr(x$geometry, 'crs')$proj4string )
	} else if (class(x) == 'character') { 
		if (asText) {
			return(x)
		} else {
			return( CRS(x) )
		}
	} else if (class(x) != "CRS") { 
		return(as.logical(NA))
	}
	
	if (asText) {
		if (is.na(x@projargs)) { 
			return(as.character(NA))
		} else {
			return(trim(x@projargs))
		}	
	} else {
		return(x)
	}
}


setMethod("proj4string", signature('Raster'), 
# redundant, for compatibility with sp
	function(obj) {
		projection(obj)
	}
)


setMethod("proj4string<-", signature('Raster'), 
# redundant, for compatibility with sp
	function(obj, value) {
		projection(obj) <- value
		obj
	}
)

