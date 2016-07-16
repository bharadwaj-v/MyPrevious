## The makeCacheMatrix function will take an empty matrix as input value. It will create
## a list with variables $setMatrix,$getMatrix,$setInvMat,$getInvMat.

## The cacheSolve function will take the list returned from makeCacheMatrix function and
## returns the inverse of the matrix input at makeCacheMatrix$setMatrix. If the inverse has
## been calculated it stores in the cache and returns value from this cache.

## Intially call g<-matrixCacheMatrix()
## set matrix using g$setMatrix(c)
## set matrix inverse using g$setInvMat()

makeCacheMatrix <- function(x = matrix()) {
    m <- NULL
    setMatrix <- function(y) {
      x <<- y
      m <<- NULL
    }
    getMatrix <- function() x
    setInvMat <- function(invMat=NULL) m<<-invMat
    getInvMat <- function() m
    list(setMatrix = setMatrix, getMatrix = getMatrix,
         setInvMat = setInvMat,
         getInvMat = getInvMat)
}


## call cacheSolve(g)

cacheSolve <- function(x, ...) {
    m <- x$getInvMat()
    if(!is.null(m)) {
      message("getting cached data")
      return(m)
    }
    data <- x$getMatrix()
    m <- solve(data, ...)
    x$setInvMat(m)
    m
        ## Return a matrix that is the inverse of 'x'
}
