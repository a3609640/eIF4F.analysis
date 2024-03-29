% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/DEG.R
\name{.RNAseq_ind_gene}
\alias{.RNAseq_ind_gene}
\title{Analyzes differential gene expression in tumors vs adjacent normal tissues}
\usage{
.RNAseq_ind_gene(df, gene)
}
\arguments{
\item{df}{\code{.TCGA_GTEX_RNAseq_sampletype_subset} generated
inside \code{\link[=.plot_boxgraph_RNAseq_TCGA]{.plot_boxgraph_RNAseq_TCGA()}}}

\item{gene}{one gene from the input argument of \code{\link[=.plot_boxgraph_RNAseq_TCGA]{.plot_boxgraph_RNAseq_TCGA()}}}
}
\value{
a data frame of differential gene expression in tumors vs adjacent
normal tissues from individual TCGA cancer types
}
\description{
A helper function selects the RNAseq data of each EIF genes from TCGA tumors
and solid tissue normal samples in \code{.TCGA_GTEX_RNAseq_sampletype_subset}.
It should not be used directly, only inside \code{\link[=.plot_boxgraph_RNAseq_TCGA]{.plot_boxgraph_RNAseq_TCGA()}}
function.
}
\seealso{
Other helper function for differential expression analysis: 
\code{\link{.RNAratio_calculation}()},
\code{\link{.RNAratio_selection}()},
\code{\link{.RNAratio_tumortype}()},
\code{\link{.RNAseq_all_gene}()},
\code{\link{.RNAseq_tumortype}()}
}
\concept{helper function for differential expression analysis}
\keyword{internal}
