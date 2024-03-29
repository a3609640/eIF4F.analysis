% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DEG.R
\name{.get_TCGA_GTEX_RNAseq}
\alias{.get_TCGA_GTEX_RNAseq}
\title{Read recomputed RNAseq data from both TCGA and GTEx}
\usage{
.get_TCGA_GTEX_RNAseq()
}
\value{
a data frame that contains the recomputed RNAseq data from both TCGA and GTEx
}
\description{
A helper function reads the dataset \code{TcgaTargetGtex_RSEM_Hugo_norm_count},
which contains the recomputed RNAseq data from both TCGA and GTEx.
}
\details{
The function also removes possible duplicated tumor samples and samples with
NAs in the dataset. It should not be used directly, only inside
\code{\link[=initialize_RNAseq_data]{initialize_RNAseq_data()}} function.
}
\examples{
\dontrun{
.get_TCGA_GTEX_RNAseq()
}

}
\seealso{
Other helper function for data initialization: 
\code{\link{.get_TCGA_CNV_ratio}()},
\code{\link{.get_TCGA_CNV_value}()},
\code{\link{.get_TCGA_CNV}()},
\code{\link{.get_TCGA_RNAseq}()}
}
\concept{helper function for data initialization}
\keyword{internal}
