#q2_taleb.12.2021_V2
##final script run 01.2022, all 2017

#Establish environments and directory to copy from windows directory: /mnt/c/Users/
conda update conda
conda update packages
conda upgrade packages
conda activate qiime2-2021.1 

mkdir qiime2_all 
cd ~/qiime2_all

## File set up

###copy fastq files and mapping file to directory
cp -r ~/casava-18-paired-end-demultiplexed ~/qiime2_all/ 
  cp ~/mapping.txt ~/qiime2-all 

###Convert from cassava 1.8 to .qza 
##Time: 5m41s
qiime tools import  --type 'SampleData[PairedEndSequencesWithQuality]' \
--input-path casava-18-paired-end-demultiplexed \
--input-format CasavaOneEightSingleLanePerSampleDirFmt \
--output-path demux-paired-end.qza --verbose

###summarize quality of demux reads
##Quality: median qual score <20 at f220, r190
qiime demux summarize --i-data demux-paired-end.qza \
--o-visualization sequences.qzv 

#(To view .qzv files, open in view.qiime2.org)

###(To subsample if testing code.)
qiime demux subsample-paired \
--i-sequences demux-full.qza \
--p-fraction 0.3 \
--o-subsampled-sequences demux-subsample.qza

#Trimming & denoising

##ITSxpress: trim adapters and conserved regions

###Install q2-itsxpress plugin 
conda config --add channels defaults
conda config --add channels conda-forge
conda config --add channels bioconda 
conda install -c bioconda itsxpress 
pip install q2-itsxpress 
qiime dev refresh-cache 

#if installed once in q2 env, just check that plugin is installed properly
qiime itsxpress 

###Trim adapters and conserved regions
##Time: 95m05s
time qiime itsxpress trim-pair-output-unmerged --i-per-sample-sequences demux-paired-end.qza --p-region ITS1 --p-taxa F --p-threads 4 --o-trimmed itsx_trimmed.qza --verbose 

####Summarize output
## Qual: median qual <20 220f 187r
qiime demux summarize --i-data itsx_trimmed.qza --o-visualization trimmed_sequences.qzv 
#Demux summarize shows sequences per sample, mean quality scores at each bp position. 

##DADA2 for denoising 

###Denoising for paired reads
##Time:14m09s 
time qiime dada2 denoise-paired --i-demultiplexed-seqs itsx_trimmed.qza --p-trunc-len-r 220 --p-trunc-len-f 190 --o-table table.qza --o-representative-sequences rep-seqs.qza --o-denoising-stats denoising-stats.qza 

####Summarize output from DADA2
qiime feature-table summarize --i-table table.qza --o-visualization tableviz.qzv 
#Tableviz shows ASVs (or "features") per sample, frequency per ASV


#Assign tax with UNITE

##Training classifier to most recent dataset-- use dynamic UNITE data

###Import ref seqs from download
Download from: https://unite.ut.ee/repository.php 

###Unzip/move files

cp /mnt/c/Users/maria/Downloads/C5547B97AAA979E45F79DC4C8C4B12113389343D7588716B5AD330F8BDB300C9.tgz ~/
  
  tar xzf "file name"

###Import reference sequences (.fasta) and taxonomy file (.txt). 
#Use dynamic version!
qiime tools import --type 'FeatureData[Sequence]' --input-path ~/sh_qiime_release_10.05.2021/sh_refs_qiime_ver8_dynamic_10.05.2021.fasta --output-path ~/qiime2-testd/unite.qza
qiime tools import --type 'FeatureData[Taxonomy]' --input-format HeaderlessTSVTaxonomyFormat --input-path ~/sh_qiime_release_10.05.2021/sh_taxonomy_qiime_ver8_dynamic_10.05.2021.txt --output-path ~/qiime2-testd/unite-taxonomy.qza 

###Train the QIIME classifier to unite data -Do not repeat if not neceesary 
#Time: 45min
#DO NOT repeat this step if it can be helped. Copy over from qiime2-testd. 
time qiime feature-classifier fit-classifier-naive-bayes --i-reference-reads unite.qza --i-reference-taxonomy unite-taxonomy.qza --o-classifier classifier.qza  --p-classify--chunk-size 100 --verbose

##Copy pre-trained classifier
cp ~/classifier.qza ~/qiime2-all/
  
  ##Classify Sequence variants 
  #Time: 6m19s
  time qiime feature-classifier classify-sklearn --i-classifier classifier.qza --i-reads rep-seqs.qza --p-reads-per-batch 500 --o-classification taxonomy.qza --verbose 

###View output w/barplots
qiime taxa barplot --i-table table.qza  --i-taxonomy taxonomy.qza --m-metadata-file mapping.txt --o-visualization taxa-bar-plots.qzv



#Exporting files for R

##Extract biom files
mkdir -p Phyloseq
qiime tools export 'Demo_Data/table.qza' --output-dir 'Phyloseq/'
qiime tools export Demo_Data/taxonomy.qza --output-dir Phyloseq/
  
  ###rename headers to match tax file and biom file
  sed 's/Feature ID/#OTUID/' Phyloseq/taxonomy.tsv | sed 's/Taxon/taxonomy/' | sed 's/Confidence/confidence/' > Phyloseq/biom-taxonomy.tsv

###Merge tax with biom file
biom add-metadata \
-i Phyloseq/feature-table.biom \
-o Phyloseq/taxa_table.biom \
--observation-metadata-fp Phyloseq/biom-taxonomy.tsv \
--sc-separated taxonomy

##Copy all files
Copy extracted data, mapping files, .qza, .qzv files to directory, along with text of terminal output.
