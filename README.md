# 2017-ITS-q2-output


## Study description 

This study seeks to describe the fungal epiphyte community structure & succession on
three plant species disturbed by Spotted lanternfly honeydew. SLF-affected leaf 
surfaces were sampled in 2017 over 9 weeks at a residential property in Berks Co., PA. 
Not all samples are included in this dataset, due to sample loss from primer errors in 
initial sample processing.The ITS1f-ITS2 gene region (EMP.kabir primer) was amplified 
to characterize the composition of the fungal community. We expect to see deterministic, 
facultative sussession, wherein exposure to SLF honeydew makes fungal communities more 
similar to one another, even between plant host species. 

! https://github.com/mariam-taleb/ITS-Ailanthus-Spotted-Lanternfly is using the same 
sequencing data, but bioinformatics were completed in the original QIIME pipeline.

## Project description

QIIME2 is a decentralized microbiome analysis package. Here, it is used to conduct 
initial bioinformatics analysis of Cassava1.8 formatted raw sequences from 73 samples.
Sequences are imported as a QIIME artifact, trimmed with ITSxpress, then quality 
filtered, denoised and merged using DADA2. A classifier trained to the UNITE 8.3 
dynamic threshold database was used to assign taxonomy. Reference sequences, a 
taxonomy table, an OTU/ASV table, and metadata were then exported for statistical 
analysis and data visualization in R. Downstream analysis will be published to GitHub. 

Analyses were conducted on machine with AMD Ryzen 5 5600X 6 core CPU, 3.7 GHz base 
speed, with 16 GB RAM, 2667 MHz speed. Machine ran Windows 11, analyses were conducted
in Ubuntu 20.04.3 LTS (GNU/Linux 5.10.16.3-microsoft-standard-WSL2 x86_64). 

## Folder contents

-Code and output: annotated code, .txt file with terminal output

-extracted-feature-tables: data and provenance for OTU tables

-extracted-rep-seqs: data and provenance for representative sequences

-extracted-tax: data and provenance for taxonomy tables

-summed outputs (qzv): .qzv files visualizing outputs along Qiime2 pipeline 
  
  (Use view.qiime2.org to view contents) 
