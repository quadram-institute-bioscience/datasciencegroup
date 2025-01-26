# Compositional data analysis for microbiome data
Material for the QIB Data Science group workshop - A. Ponsero

# Setup and requirements

## Requirements

This lessons assumes that you have some minimal knowledge of the R langage and some familiarity with RStudio. In particular, being familiar with the ggplot2 packages is recommended in order to fully understand this workshop.

## Setup

### R and Rstudio

This workshop assumes you have R and RStudio installed on your computer.

The latest version of R can be downloaded [here](https://cran.r-project.org/mirrors.html).

RStudio can be downloaded [here](https://rstudio.com/products/rstudio/download/). Make sure that you download the free Desktop version for your computer.

### R libraries

This workshop will use several libraries and packages.
To install the packages, open RStudio and run in the console: 

```{r}
# Core data manipulation and visualization
install.packages("tidyverse")
install.packages("shiny")

# Microbiome data handling
install.packages("BiocManager")
BiocManager::install("phyloseq")
BiocManager::install("microbiome")
BiocManager::install("HMP16SData")

# Compositional data analysis
install.packages("compositions")

# Visualization enhancements
install.packages("ggrepel") 
install.packages("patchwork") 
install.packages("DT")
install.packages("GGally")

# diversity metrics and ordination
install.packages("vegan")
```
