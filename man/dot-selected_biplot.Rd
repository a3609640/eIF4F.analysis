% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/PCA.R
\name{.selected_biplot}
\alias{.selected_biplot}
\title{Plot subgroups of PCA results as biplots}
\usage{
.selected_biplot(res.pca, df, sample_type, column_name, color)
}
\arguments{
\item{res.pca}{PCA results from from TCGA and GTEX combined RNAseq data}

\item{df}{combined RNAseq data with sample type annotation}

\item{sample_type}{sample types for plot labeling}

\item{column_name}{column name of annotation of primary diseases or
healthy tissues for color of individuals}

\item{color}{color scheme used for individual sample on the PCA}

\item{folder}{sub directory name to store the output files}
}
\description{
A helper function draws biplots of selected PCA results from
TCGA and GTEX combined data.
}
\details{
This function
\itemize{
\item uses RNAseq data generated from \code{.get_df_subset(.TCGA_GTEX_sampletype_subset, "All")}
for PCA
\item calls \code{\link[=.biplot_title]{.biplot_title()}} to generate plot title using the input argument
\code{sample_type}
}

It should not be used directly, only inside \code{\link[=.plot_PCA_TCGA_GTEX]{.plot_PCA_TCGA_GTEX()}} function.

Side effects:

(1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
PCA score plot shows the clusters of samples based on their similarity and
loading plot shows how strongly each characteristic influences a principal
component.
}
\examples{
\dontrun{
.selected_biplot(
  res.pca = .RNAseq_PCA(df[[1]], 10), df = df[[2]],
  x = "Healthy Tissue (GTEx)", y = "sample.type", color = "#D55E00"
)
.selected_biplot(
  res.pca = .RNAseq_PCA(df[[1]], 10), df = df[[2]],
  x = "Healthy Tissue (GTEx)", y = "primary.site", color = col_vector
)
}

}
\seealso{
Other helper function for PCA plotting: 
\code{\link{.biplot_title}()},
\code{\link{.biplot}()}
}
\concept{helper function for PCA plotting}
\keyword{internal}
