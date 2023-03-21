#' Computes Random Walk Centrality in normalized format
#'
#' A normalized version of Random Walk Centrality implemented as in DePaolis et al(2022)
#' @param A The adjacency matrix of the network to be analyzed.It must be square.
#' @return The vector containing the normalized values (between 0 and 1) of Random Walk Centrality of the network.
#' @examples rwc_norm(exmpl_matrix)
#' @export

rwc_norm <- function(A) {
  ## Reads the A-matrix; check if A is a matrix and if it's square. Complete with zeros if necessary
  ## If any row/column is all zeros, remove it; records their row/column number
        nn = nrow(A)
        cen = matrix(0,nn,1)
        m <- mfpt(A)   # H from mfpt{}
        for (j in 1:nn) {
                if (all(A[j,] == (c(rep(1,(j-1)),0,rep(1,(nn-j)))))) {  # This compares each row of H with a rows made of 1s and a zero on the diagonal
                        cen[j] = 0   # If TRUE (i.e. row of H == 1s) that row of CEN == zero
                } else {
                        cen[j] = nn / sum(m[,j])
                }
        }
        cen <- (cen - min(cen)) / (max(cen) - min(cen))
        return(cen)
}




