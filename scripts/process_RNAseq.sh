#!/bin/bash
#############################
# three steps for processing 
# RNA-seq data
############################


### step 1: mapping to mm10 for each replicate of each conditon
hisat2 -p 50 --summary-file $dirlog/$id --known-splicesite-infile $fsplicesites -x ./grcm38/genome -1 $dirin/${id}_R1_001.fastq.gz -2 $dirin/${id}_R2_001.fastq.gz | ./samtools view -Sbo $fbam


### step 2: count reads
./featureCounts -T 10 -s 2 -p --countReadPairs -t exon -g gene_id -a Mus_musculus.GRCm38.102.gtf \
-o results_step2/featureCounts_WT_KO \
./results_step1/WT_NAIVE1_S1.bam \
./results_step1/WT_NAIVE2_S3.bam \
./results_step1/WT_NAIVE3_S5.bam \
./results_step1/RAD21KO_NAIVE1_S2.bam \
./results_step1/RAD21KO_NAIVE2_S4.bam \
./results_step1/RAD21KO_NAIVE3_S6.bam \
./results_step1/WT-Sh1_S1.bam \
./results_step1/WT-Sh2_S5.bam \
./results_step1/WT-Sh3_S9.bam \
./results_step1/WT-SNC1_S2.bam \
./results_step1/WT-SNC2_S6.bam \
./results_step1/WT-SNC3_S10.bam \
./results_step1/KO-Sh1_S3.bam \
./results_step1/KO-Sh2_S7.bam \
./results_step1/KO-Sh3_S11.bam \
./results_step1/KO-SNC1_S4.bam \
./results_step1/KO-SNC2_S8.bam \
./results_step1/KO-SNC3_S12.bam



### step 3: differential analysis
# please check "process_RNAseq_DESeq2.ipynb"
