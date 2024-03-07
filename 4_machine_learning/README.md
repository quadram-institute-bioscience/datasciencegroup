# Machine Learning  with Microbiome Data Workshop

[![Open in Colab](https://colab.research.google.com/assets/colab-badge.svg)](https://colab.research.google.com/gist/telatin/87477ec635b79ed5ecafc585a330c1c3/prediction-notes.ipynb)

> Guest speaker:
> *Dr Giovanni Birolo*, University of Turin (Italy)


## Workshop Overview

In this workshop, you will:

- Learn how to import a typical microbiome dataset into Python.
- Explore the dataset's structure, including metadata, feature tables, and taxonomy tables.
- Use statistical and machine learning libraries to classify and predict labels within your dataset.

We will focus on a [dataset from Pat Schloss's lab](https://mothur.org/wiki/miseq_sop/), examining the murine gut microbiome to understand community membership and structure changes over time.

:warning: We used this dataset with [Matteo Calgaro](https://github.com/quadram-institute-bioscience/datasciencegroup/tree/main/2_rarefaction#readme).

## Pre-requisites

Before attending, please ensure you have a basic understanding of Python and some basics on its data manipulation libraries, such as pandas and numpy. 

## Tools and Libraries

We will use the following Python libraries:

- `numpy`: For numerical operations.
- `pandas`: For data manipulation and analysis.
- `sklearn`: For applying machine learning techniques.
- `seaborn` and `matplotlib`: For data visualization.

Ensure these libraries are installed and updated in your Python environment before the workshop.

## Dataset Overview

The dataset comprises several tables reflecting different aspects of the microbiome study:
- **[Metadata](mouse-16s/metadata.csv)**: Attributes for each sample, including sample identifiers and labels.
- **[Feature Table](mouse-16s/otutab_raw.csv)**: Abundances of each feature/species in each sample (some times this is referred to as OTU table).
- **[Taxonomy Table](mouse-16s/taxonomy.csv)**: Taxonomic classification for each feature.

 
## Structure

The workshop is structured as follows:

1. **Introduction to Microbiome Data**: Understanding the structure and content of microbiome datasets.
2. **Data Importing and Exploration**: Loading datasets into Python and performing initial explorations.
3. **Visual Data Exploration**: Using PCA for visual exploration of sample similarity.
4. **Statistical Analysis**: Applying statistical tests to uncover significant differences in the data.
5. **Machine Learning Applications**: Building and evaluating predictive models using machine learning.
6. **Model Evaluation**: Assessing model performance with cross-validation.

## Installation Instructions

Please ensure you have a recent version of Python installed. 
You can download and install the necessary libraries using pip (or conda, and environment file is shared in this folder):

```bash
pip install numpy pandas scikit-learn matplotlib seaborn
```
