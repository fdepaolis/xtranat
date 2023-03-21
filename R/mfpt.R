#' Computes mfpt
#'
#' mean first-passage time implemented as in DePaolis et al(2022)
#' @param A The adjacency matrix of the network to be analyzed
#' @return  mfpt.
#' @export
mfpt <- function(A) {
        A <- as.matrix(A)
        n = nrow(A)
        rrss = rowSums(A)
        for (i in 1:n) {
                if (rrss[i] != 0) {
                        rrss[i] = 1/rrss[i]
                }
        }
        AA = diag(n) - diag(rrss) %*% A  #compute transition matrix.
        H = matrix(0, n, n)
        I = solve(AA[-1,-1])            ## inverse of AA without 1st column & 1st row
        ones = matrix(1, n-1, 1)        ## vector of "1"s of length 'n-1'
        for (i in 1:n) {
                H[-i,i] = I %*% ones    ## matrix product; otherwise, non-conformable
                if (i < n){
                        u = AA[-(i+1),i] - AA[-i, (i+1)]
                        I = I - ((I*u) * I[i,]) / (1 + (I[i,] * u))
                        v = AA[i, -(i+1)] - AA[(i+1), -i]
                        I = I - ((I[,i] * (v * I)) / 1 + v * I[,i])
                        if (AA[(i+1),(i+1)]!=1){
                                I = solve(AA[-(i+1),-(i+1)], tol = 1e-29)
                        }
                        if (any(is.infinite(I))) {
                                I[is.infinite(I)] <- 0
                        }
                }
        }
        return(H)  #  H is called by RWC and RWC_norm
}
