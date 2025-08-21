# DoReMiTra

<img src="man/figures/logo.png" align="right" width="120"/>

<!-- badges: start -->
  [![R-CMD-check](https://github.com/AhmedSAHassan/DoReMiTra/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/AhmedSAHassan/DoReMiTra/actions/workflows/R-CMD-check.yaml)
  <!-- badges: end -->

**DoReMiTra:** A curated data package for radiation DOse REsponse Measured In TRAnscriptomics

It is an R data package providing access to curated transcriptomic datasets related to **blood radiation**, with a focus on **neutron, x-ray, and gamma ray** studies. It is designed to facilitate radiation biology research and support data exploration and reproducibility in radiation transcriptomics.

All datasets are provided as **SummarizedExperiment** objects, allowing seamless integration with the **Bioconductor ecosystem**.

------------------------------------------------------------------------

## Installation

You can install the development version of `DoReMiTra` from GitHub using:

``` r
# Install devtools if not already installed
install.packages("devtools")

# Install DoReMiTra from GitHub
devtools::install_github("AhmedSAHassan/DoReMiTra")
```

## Overview

The package includes preprocessed and annotated datasets from public repositories (primarily GEO), with harmonized metadata and consistent formatting. All the datasets will contain the following information in a uniform way:

✅ Radiation type (neutron, x-ray, gamma ray)

✅ Dose

✅ Time point

✅ Organism (e.g., human, mouse)

✅ Experimental setting (InVivo, ExVivo)

✅ Sex (Male, Female)

## Code of Conduct
  
Please note that the DoReMiTra project is released with a [Contributor Code of Conduct](https://contributor-covenant.org/version/2/1/CODE_OF_CONDUCT.html). By contributing to this project, you agree to abide by its terms.
