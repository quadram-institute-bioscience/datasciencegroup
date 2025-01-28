# Load required libraries
library(HMP16SData)
library(microbiome)
library(tidyverse)
library(compositions)
library(vegan)
library(ggrepel)


# Upload and prepare data
##########################################
dataset <- readRDS("physeq_undigested_fava.rds")

##########################################

## Method 1: Bray-Curtis PCoA
##########################################
ps.gen <- microbiome::aggregate_taxa(dataset, level="Genus")
otu_table <- as.data.frame(t(otu_table(ps.gen)))
metadata <- as.data.frame(sample_data(ps.gen))
bc_dist <- vegdist(otu_table, method = "bray")
bc_pcoa <- cmdscale(bc_dist, k = 2, eig = TRUE)

pcoa_df <- data.frame(
  PC1 = bc_pcoa$points[,1],
  PC2 = bc_pcoa$points[,2],
  Treatment = metadata$Treatment, 
  TimePoint = metadata$Timepoint, 
  Donor = metadata$Donor
)

bc_var_explained <- (bc_pcoa$eig/sum(bc_pcoa$eig))[1:2] * 100

# Bray-Curtis PCoA
bc_plot <- ggplot(pcoa_df, aes(x = PC1, y = PC2, color = Treatment)) +
  geom_point(alpha = 0.7, size = 3, aes(shape = factor(TimePoint))) +
  theme_minimal() +
  labs(title = "Bray-Curtis PCoA",
       x = sprintf("PCo1 (%.1f%%)", bc_var_explained[1]),
       y = sprintf("PCo2 (%.1f%%)", bc_var_explained[2])) +
  scale_color_brewer(palette = "Set2") +
  theme(legend.title = element_blank())
bc_plot
##########################################

## Method 2: Aitchinson PCA biplot
##########################################
ps.gen <- microbiome::aggregate_taxa(dataset, level="Genus")
ps.gen.clr <- microbiome::transform(ps.gen, transform = "clr") 
otu_table2 <- as.data.frame(t(otu_table(ps.gen.clr)))
metadata2 <- as.data.frame(sample_data(ps.gen.clr))
pca_result <- prcomp(otu_table2, scale. = FALSE)

pca_df <- data.frame(
  PC1 = pca_result$x[,1],
  PC2 = pca_result$x[,2],
  Treatment = metadata$Treatment, 
  TimePoint = metadata$Timepoint, 
  Donor = metadata$Donor
)

pca_var_explained <- (pca_result$sdev^2/sum(pca_result$sdev^2))[1:2] * 100

loadings <- pca_result$rotation[,1:2]
loading_magnitude <- sqrt(rowSums(loadings^2))
top_taxa <- names(sort(loading_magnitude, decreasing = TRUE))[1:10]
loadings_df <- data.frame(
  Taxa = rownames(loadings),
  PC1 = loadings[,1],
  PC2 = loadings[,2]
) %>% filter(Taxa %in% top_taxa)

# Create sample points PCA plot
pca_scores_plot <- ggplot(pca_df, aes(x = PC1, y = PC2, color = Treatment)) +
  geom_point(alpha = 0.7, size = 3, aes(shape = factor(TimePoint))) +
  theme_minimal() +
  labs(title = "Aitchison PCA - Sample Ordination",
       x = sprintf("PC1 (%.1f%%)", pca_var_explained[1]),
       y = sprintf("PC2 (%.1f%%)", pca_var_explained[2])) +
  scale_color_brewer(palette = "Set2") +
  theme(legend.title = element_blank())

pca_scores_plot

# Prepare loadings for taxa plot
loadings_df <- data.frame(
  Taxa = rownames(loadings),
  PC1 = loadings[,1],
  PC2 = loadings[,2]
) %>%
  mutate(
    magnitude = sqrt(PC1^2 + PC2^2),
    label = str_replace(Taxa, "^([^_]+_[^_]+).*$", "\\1")
  ) %>%
  top_n(15, magnitude)

# Create taxa loadings plot
pca_loadings_plot <- ggplot(loadings_df) +
  geom_hline(yintercept = 0, linetype = "dashed", color = "grey70") +
  geom_vline(xintercept = 0, linetype = "dashed", color = "grey70") +
  geom_segment(aes(x = 0, y = 0, xend = PC1, yend = PC2),
               arrow = arrow(length = unit(0.2, "cm")),
               color = "grey50") +
  geom_text_repel(aes(x = PC1, y = PC2, label = label),
                  size = 3,
                  max.overlaps = Inf,
                  box.padding = 0.5) +
  theme_minimal() +
  labs(title = "Aitchison PCA - Taxa Contributions",
       x = "PC1 Loading",
       y = "PC2 Loading") +
  coord_fixed(ratio = 1) +
  scale_x_continuous(expand = expansion(mult = 0.2)) +
  scale_y_continuous(expand = expansion(mult = 0.2))

pca_loadings_plot
##########################################

# Compare plots & summaries
##########################################
pca_scores_plot + pca_loadings_plot
bc_plot + pca_scores_plot


# Print summary statistics
cat("\nNumber of samples per donor:\n")
print(table(metadata$Donor))

cat("\nNumber of taxa:", nrow(otu_table), "\n")

cat("\nVariance explained:\n")
cat("Bray-Curtis PCoA - First two axes:", 
    sprintf("%.1f%%, %.1f%%", bc_var_explained[1], bc_var_explained[2]), "\n")
cat("Aitchison PCA - First two axes:", 
    sprintf("%.1f%%, %.1f%%", pca_var_explained[1], pca_var_explained[2]), "\n")
##########################################
