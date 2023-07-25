# Rarefaction of microbiome data

Guest speaker: Dr Matteo Calgaro *University of Verona, Italy*

* [Rarefaction Practice in Microbiome Data Analysis](https://mcalgaro93.github.io/randomtopics/rarefaction-practice-in-microbiome-data-analysis.html)

Bibliography
* [Paul J. McMurdie, Susan Holmes: Waste Not, Want Not: Why Rarefying Microbiome Data Is Inadmissible](https://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1003531)
* [Pat Schloss: Waste not, want not: Revisiting the analysis that called into question the practice of rarefaction](https://www.biorxiv.org/content/10.1101/2023.06.23.546312v1)

Data files in this directory:

* Output of 16S analysis of [MiSeq SOP dataset](https://mothur.org/wiki/miseq_sop/) using [Dadaist2](https://quadram-institute-bioscience.github.io/dadaist2/)
  * feature table
  * taxonomy table
  * metadata
  * representative sequences
  * tree


```bash
# Download Silva 138 with `dadaist2-getdb` first
dadaist2 -r ~/refs/silva_nr_v138_train_set.fa.gz -i MiSeq_SOP/ -m metadata.csv -o dadaist2-output/ --threads 16
```
