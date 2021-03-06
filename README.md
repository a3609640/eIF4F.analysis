
<!-- README.md is generated from README.Rmd. Please edit that file -->

# eIF4F.analysis

<!-- badges: start -->

[![R-CMD-check](https://github.com/a3609640/eIF4F.analysis/workflows/R-CMD-check/badge.svg)](https://github.com/a3609640/eIF4F.analysis/actions)
[![R](https://github.com/a3609640/eIF4F.analysis/actions/workflows/r.yml/badge.svg)](https://github.com/a3609640/eIF4F.analysis/actions/workflows/r.yml)
<!-- badges: end -->

The goal of eIF4F.analysis is to understand function and regulation of
interactions among translation initiation complex proteins across tumor
types

## Before you begin

Perform the following steps to ensure the proper operation of this
package.

[System requirements](#system-requirements)

[Install RStudio/R](#install-rstudior)

[Install dependent libraries](#install-dependent-libraries)

[Install eIF4F analysis package](#install-eif4f-analysis-package)

[Download datasets](#download-datasets)

[File directories](#file-directories)

[Session information](#session-information)

[Tutorials](#tutorials)

## System requirements

This project makes use of various resource-intensive R packages, which
carries relatively high demands for compute, RAM, and disk I/O resources
(but not for graphics resources). Nonetheless, the necessary hardware is
attainable in high-end consumer-grade systems.

### Description of development systems

The following systems have been used to execute the R scripts in this
project:

1.  (verified) System76 “Serval” mobile workstation

    -   Intel i7-8700k CPU
    -   64GB RAM (DDR4-3000, non-ECC)
    -   Samsung NVMe Pro SSD
    -   Pop!\_OS 20.04 LTS
    -   RStudio
    -   R 4.1.1

2.  (verified) PowerSpec G460 desktop computer

    -   Intel i7-8700k CPU
    -   64GB RAM (DDR4-3200, non-ECC)
    -   Intel M.2 SATA SSD
    -   Samsung NVMe Evo+ SSD
    -   Windows 10 Pro
    -   RStudio for Windows
    -   R 4.0.3

Additional details of these environments are provided in the “Session
Information” section below.

## Install RStudio/R

1.  Download & install R 4.1, if not already installed.
2.  Download & install RStudio, if not already installed.
    <https://www.rstudio.com/products/rstudio/download/>

## Install dependent libraries

The work here depends upon many R libraries. The following command may
be a useful way to install them all.

``` r
# use Bioconductor version 3.15 for package installation
if (!require("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
BiocManager::install(version = "3.15")

# install required packages
bio_pkgs <- c(
  "AnnotationDbi", "circlize",  "clusterProfiler", "ComplexHeatmap", "corrplot", 
  "data.table", "devtools", "dplyr", "EnvStats", "eulerr", "factoextra", 
  "FactoMineR", "forcats", "forestplot", "ggfortify", "ggplot2", "ggpubr", 
  "graphics", "grDevices", "grid", "limma", "missMDA", "org.Hs.eg.db", "purrr", 
  "RColorBrewer", "ReactomePA", "readr",  "readxl", "reshape2", "scales", 
  "stats", "stringr", "survival", "survivalAnalysis", "tibble", "tidyr", 
  "tidyselect")
BiocManager::install(bio_pkgs)

# load required packages
lapply(bio_pkgs, require, character.only = TRUE)
```

## Install eIF4F analysis package

You can install the development version of `eIF4F.analysis` from
[GitHub](https://github.com/) and load it in the R console.

``` r
# Install eIF4F.analysis package 
devtools::install_github("a3609640/eIF4F.analysis")

# Load eIF4F.analysis package 
library(eIF4F.analysis)
```

## Download datasets

Run `Download.sh` from `Script` folder of our GitHub repository.

``` bash
bash ~/github/eIF4F.analysis/Script/Download.sh
```

`Download.sh` is a bash script to download all needed datasets (TCGA,
GTEx, CPTAC, CCLE and etc) from URLs and unzip them. `Download.sh` will
create the `~/Downloads/EIF_data` directory to store all downloaded
datasets.

``` bash
#!/bin/sh

## download all datasets from the following weblinks

### create the directory to store all downloaded datasets
readonly DATA_FILE_DIRECTORY="${HOME}/Downloads/EIF_data"
mkdir -p "${DATA_FILE_DIRECTORY}"


### TCGA and GTEX DATA
#### TCGA CNV dataset (thresholded)
wget https://tcga.xenahubs.net/download/TCGA.PANCAN.sampleMap/Gistic2_CopyNumber_Gistic2_all_thresholded.by_genes.gz -P "${DATA_FILE_DIRECTORY}"

#### TCGA CNV dataset
wget https://tcga.xenahubs.net/download/TCGA.PANCAN.sampleMap/Gistic2_CopyNumber_Gistic2_all_data_by_genes.gz -P "${DATA_FILE_DIRECTORY}"

#### TCGA CNV ratio dataset
wget https://pancanatlas.xenahubs.net/download/broad.mit.edu_PANCAN_Genome_Wide_SNP_6_whitelisted.gene.xena.gz -P "${DATA_FILE_DIRECTORY}"

#### TCGA RNA-Seq dataset
wget https://tcga-pancan-atlas-hub.s3.us-east-1.amazonaws.com/download/EB%2B%2BAdjustPANCAN_IlluminaHiSeq_RNASeqV2.geneExp.xena.gz -P "${DATA_FILE_DIRECTORY}"

#### TCGA sample type annotation
wget https://pancanatlas.xenahubs.net/download/TCGA_phenotype_denseDataOnlyDownload.tsv.gz -P "${DATA_FILE_DIRECTORY}"

#### TCGA OS data
wget https://tcga-pancan-atlas-hub.s3.us-east-1.amazonaws.com/download/Survival_SupplementalTable_S1_20171025_xena_sp -P "${DATA_FILE_DIRECTORY}"

#### TCGA and GTEX RNA-Seq dataset
wget https://toil.xenahubs.net/download/TcgaTargetGtex_RSEM_Hugo_norm_count.gz -P "${DATA_FILE_DIRECTORY}"

#### TCGA and GTEX sample type annotation
wget https://toil.xenahubs.net/download/TcgaTargetGTEX_phenotype.txt.gz -P "${DATA_FILE_DIRECTORY}"


### CPTAC DATA
#### CPTAC LUAD RNA-Seq data (Gillette et al., 2020)
wget https://github.com/a3609640/EIF-analysis/raw/master/LUAD%20Data/RNA.xlsx -P "${DATA_FILE_DIRECTORY}"

#### CPTAC LUAD Proteomics (Gillette et al., 2020)
wget https://github.com/a3609640/EIF-analysis/raw/master/LUAD%20Data/Protein.xlsx -P "${DATA_FILE_DIRECTORY}"

#### CPTAC LUAD Proteomics
wget https://cptc-xfer.uis.georgetown.edu/publicData/Phase_III_Data/CPTAC_LUAD_S046/CPTAC_LUAD_Proteome_CDAP_Protein_Report.r1/CPTAC3_Lung_Adeno_Carcinoma_Proteome.tmt10.tsv -P "${DATA_FILE_DIRECTORY}"

#### CPTAC LUAD Phosproteomics (Gillette et al., 2020)
wget https://github.com/a3609640/EIF-analysis/raw/master/LUAD%20Data/Phos.xlsx -P "${DATA_FILE_DIRECTORY}"

#### CPTAC LUAD Sample Annotation
wget https://cptc-xfer.uis.georgetown.edu/publicData/Phase_III_Data/CPTAC_LUAD_S046/CPTAC_LUAD_metadata/S046_BI_CPTAC3_LUAD_Discovery_Cohort_Samples_r1_May2019.xlsx -P "${DATA_FILE_DIRECTORY}"

#### CPTAC Clinical Data
wget https://cptc-xfer.uis.georgetown.edu/publicData/Phase_III_Data/CPTAC_LUAD_S046/CPTAC_LUAD_metadata/S046_BI_CPTAC3_LUAD_Discovery_Cohort_Clinical_Data_r1_May2019.xlsx -P "${DATA_FILE_DIRECTORY}"


### CCLE DATA
#### CCLE RNA-Seq data from DepMap Public 20Q4 20Q3
wget https://ndownloader.figshare.com/files/24613349 -O "${DATA_FILE_DIRECTORY}/CCLE_expression_full.csv" #DepMap Public 20Q3

#### CCLE annotation data
wget https://ndownloader.figshare.com/files/24613394 -O "${DATA_FILE_DIRECTORY}/sample_info.csv" #DepMap Public 20Q3

#### CCLE proteomics data
wget https://gygi.hms.harvard.edu/data/ccle/protein_quant_current_normalized.csv.gz -P "${DATA_FILE_DIRECTORY}"


gunzip ${DATA_FILE_DIRECTORY}/*.gz
```

**CRITICAL**: If the root directory path `~/Downloads/EIF_data` does not
suit, they may be adjusted trivially in these lines near the top of the
`Download.sh` script.

## File directories

Confirm the directories for input and output files. The directories for
input and output files are defined in the `Load.R` as following.

``` r
data_file_directory <- "~/Downloads/EIF_data" 
output_directory <- "~/Documents/EIF_output"
```

**CRITICAL**: If the root directory paths `~/Download/EIF_data` and
`~/Documents/EIF_output` do not suit, they may be adjusted trivially in
these lines near the top of the `Download.sh` and `Load.R` scripts.

## Session information

The version information of R, Linux and attached or loaded packages for
developing this package is the following.

``` r
> sessioninfo::session_info()
─ Session info ─────────────────────────────────────────────────────────────────
 setting  value
 version  R version 4.2.0 (2022-04-22)
 os       Pop!_OS 22.04 LTS
 system   x86_64, linux-gnu
 ui       RStudio
 language en_US:en
 collate  en_US.UTF-8
 ctype    en_US.UTF-8
 tz       America/New_York
 date     2022-06-17
 rstudio  2022.02.3+492 Prairie Trillium (desktop)
 pandoc   2.17.1.1 @ /usr/lib/rstudio/bin/quarto/bin/ (via rmarkdown)

─ Packages ─────────────────────────────────────────────────────────────────────
 ! package          * version  date (UTC) lib source
   abind              1.4-5    2016-07-21 [1] CRAN (R 4.2.0)
   AnnotationDbi      1.58.0   2022-04-26 [1] Bioconductor
   ape                5.6-2    2022-03-02 [1] CRAN (R 4.2.0)
   aplot              0.1.6    2022-06-03 [1] CRAN (R 4.2.0)
   backports          1.4.1    2021-12-13 [1] CRAN (R 4.2.0)
   Biobase            2.56.0   2022-04-26 [1] Bioconductor
   BiocGenerics       0.42.0   2022-04-26 [1] Bioconductor
   BiocParallel       1.30.3   2022-06-05 [1] Bioconductor
   Biostrings         2.64.0   2022-04-26 [1] Bioconductor
   bit                4.0.4    2020-08-04 [1] CRAN (R 4.2.0)
   bit64              4.0.5    2020-08-30 [1] CRAN (R 4.2.0)
   bitops             1.0-7    2021-04-24 [1] CRAN (R 4.2.0)
   blob               1.2.3    2022-04-10 [1] CRAN (R 4.2.0)
   brio               1.1.3    2021-11-30 [1] CRAN (R 4.2.0)
   broom              0.8.0    2022-04-13 [1] CRAN (R 4.2.0)
   cachem             1.0.6    2021-08-19 [1] CRAN (R 4.2.0)
   callr              3.7.0    2021-04-20 [1] CRAN (R 4.2.0)
   car                3.0-13   2022-05-02 [1] CRAN (R 4.2.0)
   carData            3.0-5    2022-01-06 [1] CRAN (R 4.2.0)
   cellranger         1.1.0    2016-07-27 [1] CRAN (R 4.2.0)
   checkmate          2.1.0    2022-04-21 [1] CRAN (R 4.2.0)
   circlize           0.4.15   2022-05-10 [1] CRAN (R 4.2.0)
   cli                3.3.0    2022-04-25 [1] CRAN (R 4.2.0)
   clue               0.3-61   2022-05-30 [1] CRAN (R 4.2.0)
   cluster            2.1.3    2022-03-28 [4] CRAN (R 4.1.2)
   clusterProfiler    4.4.2    2022-06-05 [1] Bioconductor
   codetools          0.2-18   2020-11-04 [4] CRAN (R 4.0.3)
   colorspace         2.0-3    2022-02-21 [1] CRAN (R 4.2.0)
   ComplexHeatmap     2.12.0   2022-04-26 [1] Bioconductor
   corrplot           0.92     2021-11-18 [1] CRAN (R 4.2.0)
   cowplot            1.1.1    2020-12-30 [1] CRAN (R 4.2.0)
   crayon             1.5.1    2022-03-26 [1] CRAN (R 4.2.0)
   data.table         1.14.2   2021-09-27 [1] CRAN (R 4.2.0)
   DBI                1.1.2    2021-12-20 [1] CRAN (R 4.2.0)
   desc               1.4.1    2022-03-06 [1] CRAN (R 4.2.0)
   devtools           2.4.3    2021-11-30 [1] CRAN (R 4.2.0)
   digest             0.6.29   2021-12-01 [1] CRAN (R 4.2.0)
   DO.db              2.9      2022-06-07 [1] Bioconductor
   doParallel         1.0.17   2022-02-07 [1] CRAN (R 4.2.0)
   DOSE               3.22.0   2022-04-26 [1] Bioconductor
   downloader         0.4      2015-07-09 [1] CRAN (R 4.2.0)
   dplyr              1.0.9    2022-04-28 [1] CRAN (R 4.2.0)
   DT                 0.23     2022-05-10 [1] CRAN (R 4.2.0)
   eIF4F.analysis   * 0.1.0    2022-06-17 [?] load_all()
   ellipsis           0.3.2    2021-04-29 [1] CRAN (R 4.2.0)
   enrichplot         1.16.1   2022-05-15 [1] Bioconductor
   EnvStats           2.7.0    2022-03-07 [1] CRAN (R 4.2.0)
   eulerr             6.1.1    2021-09-06 [1] CRAN (R 4.2.0)
   evaluate           0.15     2022-02-18 [1] CRAN (R 4.2.0)
   factoextra         1.0.7    2020-04-01 [1] CRAN (R 4.2.0)
   FactoMineR         2.4      2020-12-11 [1] CRAN (R 4.2.0)
   fansi              1.0.3    2022-03-24 [1] CRAN (R 4.2.0)
   farver             2.1.0    2021-02-28 [1] CRAN (R 4.2.0)
   fastmap            1.1.0    2021-01-25 [1] CRAN (R 4.2.0)
   fastmatch          1.1-3    2021-07-23 [1] CRAN (R 4.2.0)
   fgsea              1.22.0   2022-04-26 [1] Bioconductor
   flashClust         1.01-2   2012-08-21 [1] CRAN (R 4.2.0)
   forcats            0.5.1    2021-01-27 [1] CRAN (R 4.2.0)
   foreach            1.5.2    2022-02-02 [1] CRAN (R 4.2.0)
   forestplot         2.0.1    2021-09-03 [1] CRAN (R 4.2.0)
   fs                 1.5.2    2021-12-08 [1] CRAN (R 4.2.0)
   generics           0.1.2    2022-01-31 [1] CRAN (R 4.2.0)
   GenomeInfoDb       1.32.2   2022-05-15 [1] Bioconductor
   GenomeInfoDbData   1.2.8    2022-06-07 [1] Bioconductor
   GetoptLong         1.0.5    2020-12-15 [1] CRAN (R 4.2.0)
   ggforce            0.3.3    2021-03-05 [1] CRAN (R 4.2.0)
   ggfortify          0.4.14   2022-01-03 [1] CRAN (R 4.2.0)
   ggfun              0.0.6    2022-04-01 [1] CRAN (R 4.2.0)
   ggplot2            3.3.6    2022-05-03 [1] CRAN (R 4.2.0)
   ggplotify          0.1.0    2021-09-02 [1] CRAN (R 4.2.0)
   ggpubr             0.4.0    2020-06-27 [1] CRAN (R 4.2.0)
   ggraph             2.0.5    2021-02-23 [1] CRAN (R 4.2.0)
   ggrepel            0.9.1    2021-01-15 [1] CRAN (R 4.2.0)
   ggsignif           0.6.3    2021-09-09 [1] CRAN (R 4.2.0)
   ggtree             3.4.0    2022-04-26 [1] Bioconductor
   GlobalOptions      0.1.2    2020-06-10 [1] CRAN (R 4.2.0)
   glue               1.6.2    2022-02-24 [1] CRAN (R 4.2.0)
   GO.db              3.15.0   2022-06-07 [1] Bioconductor
   GOSemSim           2.22.0   2022-04-26 [1] Bioconductor
   graph              1.74.0   2022-04-26 [1] Bioconductor
   graphite           1.42.0   2022-04-26 [1] Bioconductor
   graphlayouts       0.8.0    2022-01-03 [1] CRAN (R 4.2.0)
   gridExtra          2.3      2017-09-09 [1] CRAN (R 4.2.0)
   gridGraphics       0.5-1    2020-12-13 [1] CRAN (R 4.2.0)
   gtable             0.3.0    2019-03-25 [1] CRAN (R 4.2.0)
   hms                1.1.1    2021-09-26 [1] CRAN (R 4.2.0)
   htmltools          0.5.2    2021-08-25 [1] CRAN (R 4.2.0)
   htmlwidgets        1.5.4    2021-09-08 [1] CRAN (R 4.2.0)
   httr               1.4.3    2022-05-04 [1] CRAN (R 4.2.0)
   igraph             1.3.1    2022-04-20 [1] CRAN (R 4.2.0)
   IRanges            2.30.0   2022-04-26 [1] Bioconductor
   iterators          1.0.14   2022-02-05 [1] CRAN (R 4.2.0)
   jsonlite           1.8.0    2022-02-22 [1] CRAN (R 4.2.0)
   KEGGREST           1.36.0   2022-04-26 [1] Bioconductor
   km.ci              0.5-6    2022-04-06 [1] CRAN (R 4.2.0)
   KMsurv             0.1-5    2012-12-03 [1] CRAN (R 4.2.0)
   knitr              1.39     2022-04-26 [1] CRAN (R 4.2.0)
   lattice            0.20-45  2021-09-22 [4] CRAN (R 4.1.1)
   lazyeval           0.2.2    2019-03-15 [1] CRAN (R 4.2.0)
   leaps              3.1      2020-01-16 [1] CRAN (R 4.2.0)
   lifecycle          1.0.1    2021-09-24 [1] CRAN (R 4.2.0)
   limma              3.52.1   2022-05-15 [1] Bioconductor
   magrittr           2.0.3    2022-03-30 [1] CRAN (R 4.2.0)
   MASS               7.3-57   2022-04-22 [4] CRAN (R 4.1.2)
   Matrix             1.4-1    2022-03-23 [4] CRAN (R 4.1.2)
   matrixStats        0.62.0   2022-04-19 [1] CRAN (R 4.2.0)
   memoise            2.0.1    2021-11-26 [1] CRAN (R 4.2.0)
   mice               3.14.0   2021-11-24 [1] CRAN (R 4.2.0)
   missMDA            1.18     2020-12-11 [1] CRAN (R 4.2.0)
   munsell            0.5.0    2018-06-12 [1] CRAN (R 4.2.0)
   mvtnorm            1.1-3    2021-10-08 [1] CRAN (R 4.2.0)
   nlme               3.1-157  2022-03-25 [4] CRAN (R 4.1.2)
   org.Hs.eg.db       3.15.0   2022-06-07 [1] Bioconductor
   patchwork          1.1.1    2020-12-17 [1] CRAN (R 4.2.0)
   pillar             1.7.0    2022-02-01 [1] CRAN (R 4.2.0)
   pkgbuild           1.3.1    2021-12-20 [1] CRAN (R 4.2.0)
   pkgconfig          2.0.3    2019-09-22 [1] CRAN (R 4.2.0)
   pkgload            1.2.4    2021-11-30 [1] CRAN (R 4.2.0)
   plyr               1.8.7    2022-03-24 [1] CRAN (R 4.2.0)
   png                0.1-7    2013-12-03 [1] CRAN (R 4.2.0)
   polyclip           1.10-0   2019-03-14 [1] CRAN (R 4.2.0)
   prettyunits        1.1.1    2020-01-24 [1] CRAN (R 4.2.0)
   processx           3.5.3    2022-03-25 [1] CRAN (R 4.2.0)
   ps                 1.7.0    2022-04-23 [1] CRAN (R 4.2.0)
   purrr              0.3.4    2020-04-17 [1] CRAN (R 4.2.0)
   qvalue             2.28.0   2022-04-26 [1] Bioconductor
   R6                 2.5.1    2021-08-19 [1] CRAN (R 4.2.0)
   rappdirs           0.3.3    2021-01-31 [1] CRAN (R 4.2.0)
   RColorBrewer       1.1-3    2022-04-03 [1] CRAN (R 4.2.0)
   Rcpp               1.0.8.3  2022-03-17 [1] CRAN (R 4.2.0)
   RCurl              1.98-1.6 2022-02-08 [1] CRAN (R 4.2.0)
   reactome.db        1.79.0   2022-06-07 [1] Bioconductor
   ReactomePA         1.40.0   2022-04-26 [1] Bioconductor
   readr              2.1.2    2022-01-30 [1] CRAN (R 4.2.0)
   readxl             1.4.0    2022-03-28 [1] CRAN (R 4.2.0)
   remotes            2.4.2    2021-11-30 [1] CRAN (R 4.2.0)
   reshape2           1.4.4    2020-04-09 [1] CRAN (R 4.2.0)
   rjson              0.2.21   2022-01-09 [1] CRAN (R 4.2.0)
   rlang              1.0.2    2022-03-04 [1] CRAN (R 4.2.0)
   rmarkdown          2.14     2022-04-25 [1] CRAN (R 4.2.0)
   rprojroot          2.0.3    2022-04-02 [1] CRAN (R 4.2.0)
   RSQLite            2.2.14   2022-05-07 [1] CRAN (R 4.2.0)
   rstatix            0.7.0    2021-02-13 [1] CRAN (R 4.2.0)
   rstudioapi         0.13     2020-11-12 [1] CRAN (R 4.2.0)
   S4Vectors          0.34.0   2022-04-26 [1] Bioconductor
   scales             1.2.0    2022-04-13 [1] CRAN (R 4.2.0)
   scatterpie         0.1.7    2021-08-20 [1] CRAN (R 4.2.0)
   scatterplot3d      0.3-41   2018-03-14 [1] CRAN (R 4.2.0)
   sessioninfo        1.2.2    2021-12-06 [1] CRAN (R 4.2.0)
   shadowtext         0.1.2    2022-04-22 [1] CRAN (R 4.2.0)
   shape              1.4.6    2021-05-19 [1] CRAN (R 4.2.0)
   stringi            1.7.6    2021-11-29 [1] CRAN (R 4.2.0)
   stringr            1.4.0    2019-02-10 [1] CRAN (R 4.2.0)
   survival           3.3-1    2022-03-03 [4] CRAN (R 4.1.2)
   survivalAnalysis   0.3.0    2022-02-11 [1] CRAN (R 4.2.0)
   survminer          0.4.9    2021-03-09 [1] CRAN (R 4.2.0)
   survMisc           0.5.6    2022-04-07 [1] CRAN (R 4.2.0)
   testthat           3.1.4    2022-04-26 [1] CRAN (R 4.2.0)
   tibble             3.1.7    2022-05-03 [1] CRAN (R 4.2.0)
   tidygraph          1.2.1    2022-04-05 [1] CRAN (R 4.2.0)
   tidyr              1.2.0    2022-02-01 [1] CRAN (R 4.2.0)
   tidyselect         1.1.2    2022-02-21 [1] CRAN (R 4.2.0)
   tidytidbits        0.3.2    2022-03-16 [1] CRAN (R 4.2.0)
   tidytree           0.3.9    2022-03-04 [1] CRAN (R 4.2.0)
   treeio             1.20.0   2022-04-26 [1] Bioconductor
   tweenr             1.0.2    2021-03-23 [1] CRAN (R 4.2.0)
   tzdb               0.3.0    2022-03-28 [1] CRAN (R 4.2.0)
   usethis            2.1.6    2022-05-25 [1] CRAN (R 4.2.0)
   utf8               1.2.2    2021-07-24 [1] CRAN (R 4.2.0)
   vctrs              0.4.1    2022-04-13 [1] CRAN (R 4.2.0)
   viridis            0.6.2    2021-10-13 [1] CRAN (R 4.2.0)
   viridisLite        0.4.0    2021-04-13 [1] CRAN (R 4.2.0)
   withr              2.5.0    2022-03-03 [1] CRAN (R 4.2.0)
   xfun               0.31     2022-05-10 [1] CRAN (R 4.2.0)
   xtable             1.8-4    2019-04-21 [1] CRAN (R 4.2.0)
   XVector            0.36.0   2022-04-26 [1] Bioconductor
   yaml               2.3.5    2022-02-21 [1] CRAN (R 4.2.0)
   yulab.utils        0.0.4    2021-10-09 [1] CRAN (R 4.2.0)
   zlibbioc           1.42.0   2022-04-26 [1] Bioconductor
   zoo                1.8-10   2022-04-15 [1] CRAN (R 4.2.0)

 [1] /home/suwu/R/x86_64-pc-linux-gnu-library/4.2
 [2] /usr/local/lib/R/site-library
 [3] /usr/lib/R/site-library
 [4] /usr/lib/R/library
────────────────────────────────────────────────────────────────────────────────
```

## Tutorials

Open the `Analysis.R` from `Script` folder from our GitHub repository.
This script contains the command lines to execute all analyses.
