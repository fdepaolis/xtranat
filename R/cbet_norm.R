#' Computes Counting Betweenness in normalized format
#'
#' A normalized version of Counting Betweenness implemented as in DePaolis et al(2022)
#' @param A The adjacency matrix of the network to be analyzed.It must be square.
#' @return The vector containing the normalized values (between 0 and 1) of Counting Betweenness of the network.
#' @examples cbet_norm(exmpl_matrix)
#' @export

cbet_norm <- function(A) {
        ## Reads the A-matrix; removes row/column with all zeros; records their row/column number
        A <- as.matrix(A)
        m = nrow(A)
        rrss = rowSums(A)
        retain.vector <- vector(mode="numeric", length=0)
        if (0.0 %in% rrss){    ## Checks if there is a row with all zeros
          retain.vector <- row(as.matrix(rrss))[which(as.matrix(rrss) == 0)]
          AA1 = A[-retain.vector,-retain.vector]  ## this is the A-matrix without row/columns of zeros
        } else {
          AA1 = A
        }

        d = diag(rowSums(AA1))
        n = nrow(AA1)
        ones = matrix(1, n, 1) ## this is a vector of "n" rows by 1 col of "1"
        re = matrix(0, n, 1 )  ## this is a vector of "n" rows by 1 col of "0"
        for (p in 1:n){
                atemp = AA1[-p,-p]
                T = solve(d[-p,-p] - atemp, tol = 1e-29)
                for (s in 1:n){
                        if (s != p){
                                if (s < p){
                                    indx = s
                                } else if (s > p) {
                                    indx = s - 1
                                }
                        N = as.matrix(diag(T[indx,])) %*% atemp
                        I = abs(N + t(N)) / 2
                        re[-p,1] = re[-p,1] + 0.5*((t(colSums(I))) + rowSums(I))
                        }
                }
        }
        re2 = (re + 2 * (n-1) * ones) / ((n) * (n-1))

        res = matrix(0, m, 1)
        # restore one or more rows/columns of zeros to their original positions
        if (length(retain.vector)!=0) {
          res[-retain.vector] <- re2
        } else
          res <- re2

        res <- (res - min(res)) / (max(res) - min(res))   # This is a normalized version with values between "0" and "1"
        return(res)

}


