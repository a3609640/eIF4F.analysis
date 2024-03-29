% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/COR.R
\name{.EIF_correlation}
\alias{.EIF_correlation}
\title{Identify EIF4F correlating genes}
\usage{
.EIF_correlation(df, sample_type)
}
\arguments{
\item{df}{the data frame \code{.TCGA_GTEX_RNAseq_sampletype_subset} generated
inside \code{\link[=.plot_Corr_RNAseq_TCGA_GTEX]{.plot_Corr_RNAseq_TCGA_GTEX()}}}

\item{sample_type}{sample types, either \code{all.tumor.type} or
\code{c("Normal Tissue")} generated inside \code{\link[=.plot_Corr_RNAseq_TCGA_GTEX]{.plot_Corr_RNAseq_TCGA_GTEX()}}}
}
\value{
a list output with four elements:
\itemize{
\item \code{cor_value_combined} for the heatmap
\item \code{CORs_summary_tbl} for bargraph
\item \code{posCOR_EIF4F} for Venn plots
\item \code{negCOR_EIF4F} for Venn plots
}
}
\description{
This function
\itemize{
\item takes the specific data frames
\code{.TCGA_GTEX_RNAseq_sampletype_subset} and \code{sample_type} that are
generated inside \code{\link[=.plot_Corr_RNAseq_TCGA_GTEX]{.plot_Corr_RNAseq_TCGA_GTEX()}}
\item calculates the correlation coefficiency between each EIF4F gene
and the rest of cellular mRNAs with \code{\link[=.correlation_coefficient]{.correlation_coefficient()}}
\item combines the correlation coefficiency data from EIF4E, EIF4A1, EIF4G1, and
EIF4EBP1
\item selects positive correlating genes with \code{\link[=.is_significant_poscor]{.is_significant_poscor()}} and
negative correlating genes with \code{\link[=.is_significant_negcor]{.is_significant_negcor()}}
\item summarizes the total number of posCORs or negCORs identified for
each EIF4F gene with \code{\link[=.summarize_counts]{.summarize_counts()}}
}

It should not be used directly, only inside \code{\link[=.plot_Corr_RNAseq_TCGA_GTEX]{.plot_Corr_RNAseq_TCGA_GTEX()}}
function.
}
\examples{
\dontrun{
.EIF_correlation(
  df = .TCGA_GTEX_RNAseq_sampletype_subset,
  sample_type = all.tumor.type
)
}

}
\seealso{
Other helper function to identify correlating genes for EIF4F genes: 
\code{\link{.correlation_coefficient}()},
\code{\link{.is_significant_negcor}()},
\code{\link{.is_significant_poscor}()},
\code{\link{.summarize_counts}()}
}
\concept{helper function to identify correlating genes for EIF4F genes}
\keyword{internal}
