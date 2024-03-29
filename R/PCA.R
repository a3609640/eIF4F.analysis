# PCA on EIF4F expression in GTEx, or/and TCGA studies
# This R script contains four sections.
#
# (1) select TCGA RNA-seq dataset for PCA.
#
# (2) perform PCA or imputed PCA and plot the PCA results as biplots or
#  selected biplots
#
# (3) composite functions to execute a pipeline of functions to select related
#  RNAseq data for PCA and plot with supply of EIF4F gene names as values of
#  the arguments.
#
# (4) wrapper function to call all master functions with inputs
#

## Select RNA-seq data from specific study groups for PCA ======================

#' @title Select RNAseq data based on the sample types
#'
#' @description
#'
#' A helper function selects the RNAseq data of primary tumors (TCGA), metastatic
#'  tumors (TCGA), healthy tissues (GTEX) or all sample types combined (all),
#'  from dataframe `.TCGA_GTEX_sampletype_subset`.
#'
#' It should not be used directly, only inside [.plot_PCA_TCGA_GTEX()] or
#'  [.plot_PCA_TCGA_GTEX_tumor()] function.
#'
#' @family helper function to select RNA-seq data from specific study groups
#'  for PCA
#'
#' @param df `.TCGA_GTEX_sampletype_subset` generated inside
#'  [.plot_PCA_TCGA_GTEX()]
#'
#' @param sample.type selected sample types
#'
#' @return
#'
#' a subset dataframe from `.TCGA_GTEX_sampletype_subset` for indicate
#'  sample types
#'
#' @examples \dontrun{
#' .get_df_subset(.TCGA_GTEX_sampletype_subset, "Primary Tumor (TCGA)")
#' }
#'
#' @keywords internal
#'
.get_df_subset <- function(df, sample_type) {
  df1 <- df %>%
    dplyr::filter(sample_type == "All" | .data$sample.type == sample_type) %>%
    droplevels()
  df2 <- df1 %>% dplyr::select_if(is.numeric)

  return(list(df2, df1))
}


## Perform PCA or imputed PCA and plot the PCA results =========================

#' @title Perform PCA on RNAseq data
#'
#' @description
#'
#' A helper function performs PCA on data generated by [.get_df_subset()].
#'  It should not be used directly, only inside [.plot_PCA_TCGA_GTEX()] or
#'  [.plot_PCA_TCGA_GTEX_tumor()] function.
#'
#' @family helper function for PCA
#'
#' @param df `df` generated inside [.get_df_subset()]
#'
#' @param number_of_dimension number of components kept in the final results
#'
#' @return PCA result
#'
#' @importFrom FactoMineR PCA
#'
#' @examples \dontrun{
#' .RNAseq_PCA(df[[1]], 10)
#' }
#'
#' @keywords internal
#'
.RNAseq_PCA <- function(df, number_of_dimension) {
  return(FactoMineR::PCA(df, # remove column with characters
    scale.unit = TRUE,
    ncp = number_of_dimension,
    graph = FALSE
  ))
}

#' @title Perform imputPCA on proteomics data
#'
#' @description
#'
#' A helper function performs impute PCA on data generated by [.get_df_subset()].
#' It should not be used directly, only inside [.plot_PCA_CPTAC_LUAD()]
#'  function.
#'
#' @family helper function for PCA
#'
#' @param df `CPTAC.LUAD.Proteomics.Sample.subset` generated inside
#' [.plot_PCA_CPTAC_LUAD()]
#'
#' @param number_of_dimension maximum number of components kept in the final results
#'
#' @return imputed PCA results
#'
#' @importFrom missMDA estim_ncpPCA imputePCA
#'
#' @examples \dontrun{
#' .protein_imputePCA(CPTAC.LUAD.Proteomics.Sample.subset)
#' }
#'
#' @keywords internal
#'
.protein_imputePCA <- function(df, number_of_dimension) {
  # Impute the missing values of a dataset with the Principal Components
  # Analysis model
  nb <- missMDA::estim_ncpPCA(
    df %>% dplyr::select_if(is.numeric),
    ncp.max = number_of_dimension
  ) # estimate the number of dimensions to impute
  res.comp <- missMDA::imputePCA(
    df %>% dplyr::select_if(is.numeric),
    ncp = nb$ncp
  )

  return(FactoMineR::PCA(res.comp$completeObs,
    scale.unit = TRUE,
    ncp = number_of_dimension,
    graph = FALSE
  ))
}


#' @title Generate title for PCA plots
#'
#' @description
#'
#' This function generates title for PCA plots based on the input value.
#' It should not be used directly, only inside [.biplot()] or
#'  [.selected_biplot()] function.
#'
#' @family helper function for PCA plotting
#'
#' @param sample_type sample type such as "All", "Healthy Tissue (GTEx)",
#'  "Primary Tumor (TCGA)", or "Metastatic Tumor (TCGA)"
#'
#' @return a string for title
#'
#' @keywords internal
#'
.biplot_title <- function(sample_type) {
  if (sample_type == "All") {
    return("(Healthy Tissues + Tumors)")
  }
  return(paste0("(", sample_type, ")"))
}


#' @title Plot PCA results as biplot, scree and matrix plots
#'
#' @description
#'
#' A helper function draws biplot, screen and matrix plots for PCA results
#'
#' @details  This function
#'  * uses RNAseq data generated from [.get_df_subset()] for PCA
#'  * calls [.biplot_title()] to generate plot title using the input argument
#'   `sample_type`
#'
#' It should not be used directly, only inside [.plot_PCA_TCGA_GTEX()],
#'  [.plot_PCA_TCGA_GTEX_tumor()], or [.plot_PCA_CPTAC_LUAD()] function.
#'
#' Side effects:
#'
#' (1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
#'  PCA score plot shows the clusters of samples based on their similarity and
#'  loading plot shows how strongly each characteristic influences a principal
#'  component.
#' (2) matrix plots on screen and as pdf files to show the quality of
#'  representation of the variables.
#' (3) scree plots on screen and as pdf files to display how much variation
#'  each principal component captures from the data.
#'
#' @family helper function for PCA plotting
#'
#' @param res.pca PCA results from selected RNAseq data
#'
#' @param df selected RNAseq data with sample type annotation
#'
#' @param sample_type selected sample types for plot label
#'
#' @param column_name column name of annotation of primary diseases or
#'  healthy tissues for color of individuals
#'
#' @param color color scheme used for individual sample on the PCA
#'
#' @param folder sub directory name to store the output files
#'
#' @importFrom corrplot corrplot
#'
#' @importFrom factoextra fviz_contrib fviz_eig fviz_pca_biplot get_pca_var
#'
#' @examples \dontrun{
#' .biplot(
#'   res.pca = .RNAseq_PCA(df[[1]], 10), df = df[[2]],
#'   sample_type = "Metastatic Tumor (TCGA)",
#'   y = "primary.disease", color = col_vector, folder = "TCGA"
#' )
#' }
#'
#' @keywords internal
#'
.biplot <- function(res.pca, df, sample_type, column_name, color, folder) {
  biplot <- factoextra::fviz_pca_biplot(res.pca,
    axes = c(1, 2),
    labelsize = 5,
    col.ind = df[, column_name],
    title = paste("PCA - Biplot", .biplot_title(sample_type)),
    palette = color,
    pointshape = 20,
    pointsize = 0.75,
    label = "var",
    col.var = "black",
    repel = TRUE
  ) +
    # xlim(-7, 8) +
    # ylim(-6, 7.5) + # for EIF 8
    theme_classic() +
    theme(
      plot.background = element_blank(),
      plot.title = black_bold_16,
      panel.background = element_rect(
        fill = "transparent",
        color = "black",
        size = 1
      ),
      axis.title.x = black_bold_16,
      axis.title.y = black_bold_16,
      axis.text.x = black_bold_16,
      axis.text.y = black_bold_16,
      legend.title = element_blank(),
      legend.position = c(0, 0),
      legend.justification = c(0, 0),
      legend.background = element_blank(),
      legend.text = black_bold_16
    )
  print(biplot)
  ggplot2::ggsave(
    path = file.path(output_directory, "PCA", folder),
    filename = paste0("PCA ", sample_type, ".pdf"),
    plot = biplot,
    width = 8,
    height = 8,
    useDingbats = FALSE
  )

  eig <- factoextra::fviz_eig(res.pca,
    title = paste("Scree plot", .biplot_title(sample_type)),
    labelsize = 6,
    geom = "bar",
    width = 0.7,
    addlabels = TRUE
  ) +
    theme_classic() +
    theme(
      plot.background = element_blank(),
      plot.title = black_bold_16,
      panel.background = element_rect(
        fill = "transparent",
        color = "black",
        size = 1
      ),
      axis.title.x = black_bold_16,
      axis.title.y = black_bold_16,
      axis.text.x = black_bold_16,
      axis.text.y = black_bold_16
    )
  print(eig)

  ggplot2::ggsave(
    path = file.path(output_directory, "PCA", folder),
    filename = paste0("scree ", sample_type, ".pdf"),
    plot = eig,
    width = 8,
    height = 8,
    useDingbats = FALSE
  )

  var <- factoextra::get_pca_var(res.pca)
  pdf(file.path(
    path = file.path(output_directory, "PCA", folder),
    filename = paste0("matrix ", sample_type, ".pdf")
  ),
  width = 9,
  height = 9,
  useDingbats = FALSE
  )
  corrplot::corrplot(var$cos2, # cos2 is better than contribute
    title = paste("PCA", .biplot_title(sample_type)),
    method = "color",
    mar = c(0, 0, 2, 0), # fix title cut off
    # is.corr     = FALSE,
    tl.cex = 1.5,
    number.cex = 1.5,
    addgrid.col = "gray",
    addCoef.col = "black",
    tl.col = "black"
  )
  dev.off()
  corrplot::corrplot(var$cos2, # cos2 is better than contribute
    title = paste("PCA", .biplot_title(sample_type)),
    mar = c(0, 0, 2, 0), # fix title cut off
    # is.corr = FALSE,
    tl.cex = 1.5,
    number.cex = 1.5,
    method = "color",
    addgrid.col = "gray",
    addCoef.col = "black",
    tl.col = "black"
  )

  return(NULL)
}

#' @title Plot subgroups of PCA results as biplots
#'
#' @description A helper function draws biplots of selected PCA results from
#'  TCGA and GTEX combined data.
#'
#' @details This function
#'
#'  * uses RNAseq data generated from `.get_df_subset(.TCGA_GTEX_sampletype_subset, "All")`
#'    for PCA
#'  * calls [.biplot_title()] to generate plot title using the input argument
#'   `sample_type`
#'
#' It should not be used directly, only inside [.plot_PCA_TCGA_GTEX()] function.
#'
#' Side effects:
#'
#' (1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
#'  PCA score plot shows the clusters of samples based on their similarity and
#'  loading plot shows how strongly each characteristic influences a principal
#'  component.
#'
#' @family helper function for PCA plotting
#'
#' @param res.pca PCA results from from TCGA and GTEX combined RNAseq data
#'
#' @param df combined RNAseq data with sample type annotation
#'
#' @param sample_type sample types for plot labeling
#'
#' @param column_name column name of annotation of primary diseases or
#'  healthy tissues for color of individuals
#'
#' @param color color scheme used for individual sample on the PCA
#'
#' @param folder sub directory name to store the output files
#'
#' @importFrom factoextra fviz_contrib fviz_eig fviz_pca_biplot get_pca_var
#'
#' @examples \dontrun{
#' .selected_biplot(
#'   res.pca = .RNAseq_PCA(df[[1]], 10), df = df[[2]],
#'   x = "Healthy Tissue (GTEx)", y = "sample.type", color = "#D55E00"
#' )
#' .selected_biplot(
#'   res.pca = .RNAseq_PCA(df[[1]], 10), df = df[[2]],
#'   x = "Healthy Tissue (GTEx)", y = "primary.site", color = col_vector
#' )
#' }
#'
#' @keywords internal
#'
.selected_biplot <- function(res.pca, df, sample_type, column_name, color) {
  .selected_samples <- df %>%
    dplyr::filter(.data$sample.type == sample_type)
  biplot <- factoextra::fviz_pca_biplot(res.pca,
    axes = c(1, 2),
    labelsize = 5,
    # col.ind = TCGA.GTEX.sampletype.subset$sample.type,
    col.ind = df[, column_name],
    palette = color,
    select.ind = list(name = row.names(.selected_samples)),
    pointshape = 20,
    pointsize = 0.75,
    # addEllipses = TRUE,
    title = "PCA - Biplot (Healthy Tissues + Tumors)",
    label = "var",
    col.var = "black",
    repel = TRUE
  ) +
    xlim(-7, 8) + ylim(-6, 7.5) + # for EIF 8
    # xlim(-6, 6) + ylim (-7, 7)+ # for EIF 4
    theme_classic() +
    theme(
      plot.background = element_blank(),
      plot.title = black_bold_16,
      panel.background = element_rect(
        fill = "transparent",
        color = "black",
        size = 1
      ),
      axis.title.x = black_bold_16,
      axis.title.y = black_bold_16,
      axis.text.x = black_bold_16,
      axis.text.y = black_bold_16,
      legend.title = element_blank(),
      legend.position = c(0, 0),
      legend.justification = c(0, 0),
      legend.background = element_blank(),
      legend.text = black_bold_16
    )
  print(biplot)
  ggplot2::ggsave(
    path = file.path(output_directory, "PCA", "TCGA_tumor+GTEX_healthy"),
    filename = paste("Selected", sample_type, column_name, ".pdf"),
    plot = biplot,
    width = 8,
    height = 8,
    useDingbats = FALSE
  )

  return(NULL)
}


## Composite functions to call PCA and plot results ============================

#' @title Perform PCA on RNAseq data from all tumors and healthy tissues
#'
#' @description A composite function call PCA on RNAseq data from all tumors
#'  and healthy tissues and plot results
#'
#' @details  This function
#'
#' * selects RNAseq data of `gene_list` genes of specific sample types from
#'  `TCGA_GTEX_RNAseq_sampletype` by [.get_df_subset()].
#' * performs three PCAs by [.RNAseq_PCA()] on \enumerate{
#'   \item tumor samples from all TCGA cancer types
#'   \item healthy tissue samples from all GTEx healthy tissue types
#'   \item TCGA tumors and GTEx healthy tissue samples combined}
#' * generates biplot, screen plot and matrix plots by [.biplot()]
#' * generates subset biplots for PCA results of combined TCGA tumors and
#'  GTEx healthy tissues with [.selected_biplot()] function
#'
#' This function is not accessible to the user and will not show at the users'
#'  workspace. It can only be called by the exported [EIF4F_PCA()] function.
#'
#' Side effects:
#'
#' (1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
#'  PCA score plot shows the clusters of samples based on their similarity and
#'  loading plot shows how strongly each characteristic influences a principal
#'  component.
#'
#' (2) matrix plots on screen and as pdf files to show the quality of
#'  representation of the variables.
#'
#' (3) scree plots on screen and as pdf files to display how much variation
#'  each principal component captures from the data.
#'
#' @family composite function to call PCA and plot results
#'
#' @param gene_list gene names in a vector of characters
#'
#' @importFrom FactoMineR PCA
#'
#' @keywords internal
#'
#' @examples \dontrun{
#' .plot_PCA_TCGA_GTEX(c(
#'   "EIF4E", "EIF4G1", "EIF4A1",
#'   "EIF4EBP1", "PABPC1", "MKNK1", "MKNK2"
#' ))
#' }
#'
.plot_PCA_TCGA_GTEX <- function(gene_list) {
  .TCGA_GTEX_sampletype_subset <- TCGA_GTEX_RNAseq_sampletype %>%
    dplyr::select(
      dplyr::all_of(gene_list),
      "sample.type",
      "primary.disease",
      "primary.site",
      "study"
    ) %>%
    # as.tibble(.) %>%
    dplyr::filter(.data$EIF4E != 0 &
      .data$study %in% c("TCGA", "GTEX") &
      .data$sample.type %in% c(
        "Metastatic",
        "Primary Tumor",
        "Normal Tissue",
        "Solid Tissue Normal"
      )) %>%
    dplyr::mutate_if(is.character, as.factor) %>%
    dplyr::mutate(sample.type = factor(.data$sample.type,
      levels = c(
        "Normal Tissue",
        "Primary Tumor",
        "Metastatic",
        "Solid Tissue Normal"
      ),
      labels = c(
        "Healthy Tissue (GTEx)",
        "Primary Tumor (TCGA)",
        "Metastatic Tumor (TCGA)",
        "Adjacent Normal Tissue (TCGA)"
      )
    ))

  df <- .get_df_subset(.TCGA_GTEX_sampletype_subset, "Primary Tumor (TCGA)")
  .biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Primary Tumor (TCGA)",
    column_name = "primary.disease",
    color = col_vector,
    folder = "TCGA_tumor"
  )

  df <- .get_df_subset(.TCGA_GTEX_sampletype_subset, "Metastatic Tumor (TCGA)")
  .biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Metastatic Tumor (TCGA)",
    column_name = "primary.disease",
    color = col_vector,
    folder = "TCGA_tumor"
  )

  df <- .get_df_subset(.TCGA_GTEX_sampletype_subset, "Healthy Tissue (GTEx)")
  .biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Healthy Tissue (GTEx)",
    column_name = "primary.site",
    color = col_vector,
    folder = "GTEX_healthy"
  )


  ## TCGA and GTEx combined
  df <- .get_df_subset(.TCGA_GTEX_sampletype_subset, "All")
  .biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "All",
    column_name = "sample.type",
    color = c("#D55E00", "#009E73", "#CC79A7", "#0072B2"),
    folder = "TCGA_tumor+GTEX_healthy"
  )

  .selected_biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Healthy Tissue (GTEx)",
    column_name = "sample.type",
    color = "#D55E00"
  )
  .selected_biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Healthy Tissue (GTEx)",
    column_name = "primary.site",
    color = col_vector
  )

  .selected_biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Primary Tumor (TCGA)",
    column_name = "sample.type",
    color = "#009E73"
  )
  .selected_biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Primary Tumor (TCGA)",
    column_name = "primary.disease",
    color = col_vector
  )

  .selected_biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Metastatic Tumor (TCGA)",
    column_name = "sample.type",
    color = "#CC79A7"
  )
  .selected_biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = "Metastatic Tumor (TCGA)",
    column_name = "primary.disease",
    color = col_vector
  )

  return(NULL)
}


#' @title Perform PCA on RNAseq data from one tumor type and its matched healthy
#'  tissue
#'
#' @description A composite function performs PCA on RNAseq data from one
#'  tumor type and its matched healthy tissue, and plot results
#'
#' @details This function
#'
#' * selects RNAseq data of `gene_list` genes in TCGA tumors and GTEx healthy
#'  tissues with the same `tissue` of origin from `TCGA_GTEX_RNAseq_sampletype`,
#'  by [.get_df_subset()].
#' * performs PCA on combined tumor and healthy samples by [.RNAseq_PCA()],
#' * plots results as biplot, scree and matrix plots by [.biplot()]
#'
#' This function is not accessible to the user and will not show at the users'
#'  workspace. It can only be called by the exported [EIF4F_PCA()] function.
#'
#' Side effects:
#'
#' (1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
#'  PCA score plot shows the clusters of samples based on their similarity and
#'  loading plot shows how strongly each characteristic influences a principal
#'  component.
#'
#' (2) matrix plots on screen and as pdf files to show the quality of
#'  representation of the variables.
#'
#' (3) scree plots on screen and as pdf files to display how much variation
#'  each principal component captures from the data.
#'
#' @family composite function to call PCA and plot results
#'
#' @param gene_list gene names in a vector of characters
#'
#' @param sample_type tissue type
#'
#' @importFrom FactoMineR PCA
#'
#' @keywords internal
#'
#' @examples \dontrun{
#' .plot_PCA_TCGA_GTEX_tumor(c(
#'   "EIF4G1", "EIF4A1", "EIF4E",
#'   "EIF4EBP1", "PABPC1", "MKNK1", "MKNK2"), "Lung")
#' }
#'
.plot_PCA_TCGA_GTEX_tumor <- function(gene_list, sample_type) {
  .TCGA_GTEX_sampletype_subset <- TCGA_GTEX_RNAseq_sampletype %>%
    dplyr::select(
      dplyr::all_of(gene_list),
      "sample.type",
      "primary.disease",
      "primary.site",
      "study"
    ) %>%
    # as.data.frame(.) %>%
    dplyr::filter(.data$EIF4E != 0 &
      .data$study %in% c("TCGA", "GTEX") &
      .data$sample.type %in% c(
        "Metastatic",
        "Primary Tumor",
        "Normal Tissue",
        "Solid Tissue Normal"
      )) %>%
    dplyr::mutate_if(is.character, as.factor) %>%
    dplyr::mutate(sample.type = factor(.data$sample.type,
      levels = c(
        "Normal Tissue",
        "Primary Tumor",
        "Metastatic",
        "Solid Tissue Normal"
      ),
      labels = c(
        "Healthy Tissue (GTEx)",
        "Primary Tumor (TCGA)",
        "Metastatic Tumor (TCGA)",
        "Adjacent Normal Tissue (TCGA)"
      )
    )) %>%
    dplyr::filter(.data$primary.site == sample_type)

  df <- .get_df_subset(.TCGA_GTEX_sampletype_subset, "All")
  .biplot(
    res.pca = .RNAseq_PCA(df[[1]], 10),
    df = df[[2]],
    sample_type = sample_type,
    column_name = "sample.type",
    color = c("#D55E00", "#009E73", "#CC79A7", "#0072B2"),
    folder = "matched_tumor_and_healthy"
  )

  return(NULL)
}


#' @title Perform PCA on proteomics data from CPATC LUADs and matched healthy
#'  lung tissues
#'
#' @description A composite function performs imputed PCA on CPATC LUADs
#'  proteomics data and plot the results
#'
#' @details  This function
#' * selects proteomics data from `CPTAC_LUAD_Proteomics` prepared by
#'  [initialize_proteomics_data()].
#' * performs imputed PCA on combined tumors from CPTAC LUAD and and
#'  matched healthy lung tissues, by [.protein_imputePCA()].
#' * plots results as biplot, scree and matrix plots by [.biplot()]
#'
#' This function is not accessible to the user and will not show at the users'
#'  workspace. It can only be called by the exported [EIF4F_PCA()] function.
#'
#' Side effects:
#'
#' (1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
#'  PCA score plot shows the clusters of samples based on their similarity and
#'  loading plot shows how strongly each characteristic influences a principal
#'  component.
#'
#' (2) matrix plots on screen and as pdf files to show the quality of
#'  representation of the variables.
#'
#' (3) scree plots on screen and as pdf files to display how much variation
#'  each principal component captures from the data.
#'
#' @family composite function to call PCA and plot results
#'
#' @param gene_list gene names in a vector of characters
#'
#' @keywords internal
#'
#' @examples \dontrun{
#' .plot_PCA_CPTAC_LUAD(c(
#'  "EIF4E", "EIF4G1", "EIF4A1", "PABPC1",
#'  "MKNK1", "MKNK2", "EIF4EBP1"))
#' }
#'
.plot_PCA_CPTAC_LUAD <- function(gene_list) {
  CPTAC.LUAD.Proteomics.Sample.subset <- CPTAC_LUAD_Proteomics %>%
    tibble::column_to_rownames(var = "Sample") %>%
    dplyr::mutate(Type = factor(.data$Type,
      levels = c(
        "NAT",
        "Tumor"
      ),
      labels = c(
        "Adjacent Normal Tissue (CPTAC)",
        "Primary Tumor (CPTAC)"
      )
    )) %>%
    dplyr::select(
      dplyr::all_of(gene_list),
      "Type"
    ) %>%
    # as.data.frame(.) %>%
    dplyr::mutate_if(is.character, as.factor) %>%
    dplyr::filter(!is.na(.data$Type)) %>%
    tibble::remove_rownames()

  res.pca <- .protein_imputePCA(CPTAC.LUAD.Proteomics.Sample.subset, 10)

  .biplot(
    res.pca = res.pca,
    df = CPTAC.LUAD.Proteomics.Sample.subset,
    sample_type = "LUAD(CPTAC)",
    column_name = "Type",
    color = c("#D55E00", "#009E73"),
    folder = "LUAD"
  )

  return(NULL)
}


## Wrapper function to call all composite functions with inputs ================

#' Perform PCA and generate plots
#'
#' @description A wrapper function to call all composite functions for PCA
#'
#' @details  This function run three composite functions together:
#'
#'  * [.plot_PCA_TCGA_GTEX()]
#'  * [.plot_PCA_TCGA_GTEX_tumor()]
#'  * [.plot_PCA_CPTAC_LUAD()]
#'
#' Side effects:
#'
#' (1) PCA biplots (PCA score plot + loading plot) on screen and as pdf files:
#'  PCA score plot shows the clusters of samples based on their similarity and
#'  loading plot shows how strongly each characteristic influences a principal
#'  component.
#'
#' (2) matrix plots on screen and as pdf files to show the quality of
#'  representation of the variables.
#'
#' (3) scree plots on screen and as pdf files to display how much variation
#'  each principal component captures from the data.
#'
#' @family wrapper function to call all composite functions with inputs
#'
#' @export
#'
#' @examples \dontrun{
#' EIF4F_PCA()
#' }
#'
EIF4F_PCA <- function() {
  .plot_PCA_TCGA_GTEX(c(
    "EIF4E", "EIF4G1", "EIF4A1", "EIF4EBP1",
    "PABPC1", "MKNK1", "MKNK2"
  ))

  lapply(c("Lung", "Brain", "Breast", "Colon", "Pancreas", "Prostate", "Skin"),
    .plot_PCA_TCGA_GTEX_tumor,
    gene_list = c(
      "EIF4G1", "EIF4A1", "EIF4E",
      "EIF4EBP1", "PABPC1", "MKNK1", "MKNK2"
    )
  )

  .plot_PCA_CPTAC_LUAD(c(
    "EIF4E", "EIF4G1", "EIF4A1", "PABPC1",
    "MKNK1", "MKNK2", "EIF4EBP1"
  ))

  return(NULL)
}
