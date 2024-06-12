#!/bin/bash
#############################
# steps for processing 
# CUT&Tag H3K27ac data
############################


### step 1: trim adapters
#./TrimGalore-0.6.6/trim_galore --paired ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_SNC-3_H3K27ac_S6/WT_SNC-3_H3K27ac_S6_R1_001.fastq.gz ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_SNC-3_H3K27ac_S6/WT_SNC-3_H3K27ac_S6_R2_001.fastq.gz --fastqc -j 8  -o ./trim_WT_SNC3

#./TrimGalore-0.6.6/trim_galore --paired ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_SNC-2_H3K27ac_S5/WT_SNC-2_H3K27ac_S5_R1_001.fastq.gz ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_SNC-2_H3K27ac_S5/WT_SNC-2_H3K27ac_S5_R2_001.fastq.gz --fastqc -j 8  -o ./trim_WT_SNC2

#./TrimGalore-0.6.6/trim_galore --paired ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_SNC-1_H3K27ac_S4/WT_SNC-1_H3K27ac_S4_R1_001.fastq.gz ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_SNC-1_H3K27ac_S4/WT_SNC-1_H3K27ac_S4_R2_001.fastq.gz --fastqc -j 8  -o ./trim_WT_SNC1

#./TrimGalore-0.6.6/trim_galore --paired ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_Sham-3_H3K27ac_S3/WT_Sham-3_H3K27ac_S3_R1_001.fastq.gz ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_Sham-3_H3K27ac_S3/WT_Sham-3_H3K27ac_S3_R2_001.fastq.gz --fastqc -j 8  -o ./trim_WT_Sham3

#./TrimGalore-0.6.6/trim_galore --paired ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_Sham-2_H3K27ac_S2/WT_Sham-2_H3K27ac_S2_R1_001.fastq.gz ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_Sham-2_H3K27ac_S2/WT_Sham-2_H3K27ac_S2_R2_001.fastq.gz --fastqc -j 8  -o ./trim_WT_Sham2

#./TrimGalore-0.6.6/trim_galore --paired ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_Sham-1_H3K27ac_S1/WT_Sham-1_H3K27ac_S1_R1_001.fastq.gz ../data/H3K27ac/Ilaria_Palmisano_SOUK009718/WT_Sham-1_H3K27ac_S1/WT_Sham-1_H3K27ac_S1_R2_001.fastq.gz --fastqc -j 8  -o ./trim_WT_Sham1




### step 2: mapping to mm10 with bowtie
cores=80
ref="reference/mm10"
projPath="CUTTag"

bowtie2 --local --very-sensitive --no-mixed --no-discordant --phred33 \
-I 10 -X 700 \
-p ${cores} -x ${ref} \
-1 $1 -2 $2 \
-S ${projPath}/alignment/sam_local_afterTrim/${3}_bowtie2.sam &> ${projPath}/alignment/sam_local_afterTrim/bowtie2_summary/${3}_bowtie2.txt



### step 3: convert from .sam to .bed

sampleList=("WT_Sham1" "WT_Sham2" "WT_Sham3" "WT_SNC1" "WT_SNC2" "WT_SNC3")

for sid in ${sampleList[@]}
do

        ## Filter and keep the mapped read pairs
        samtools view -bS -F 0x04 $projPath/alignment/sam_local_afterTrim/${sid}_bowtie2.sam >$projPath/alignment/bam/${sid}_bowtie2.mapped.bam

        ## Convert into bed file format
        bedtools bamtobed -i $projPath/alignment/bam/${sid}_bowtie2.mapped.bam -bedpe >$projPath/alignment/bed/${sid}_bowtie2.bed

        ## Keep the read pairs that are on the same chromosome and fragment length less than 1000bp.
        awk '$1==$4 && $6-$2 < 1000 {print $0}' $projPath/alignment/bed/${sid}_bowtie2.bed >$projPath/alignment/bed/${sid}_bowtie2.clean.bed

        ## Only extract the fragment related columns
        cut -f 1,2,6 $projPath/alignment/bed/${sid}_bowtie2.clean.bed | sort -k1,1 -k2,2n -k3,3n  >$projPath/alignment/bed/${sid}_bowtie2.fragments.bed

done 


### step 4: convert form .bed to .bedgraph

seqDepth=(39249734 33993019 42331545 24969683 46839429 38639864)
chromSize="mm10.sizes"

for i in ${!seqDepth[@]}
do
        scale_factor=`echo "40000000 / ${seqDepth[$i]}" | bc -l`

        echo "Scaling factor for ${sampleList[$i]} is: $scale_factor!"

        bedtools genomecov -bg -scale $scale_factor -i $projPath/alignment/bed/${sampleList[$i]}_bowtie2.fragments.bed -g $chromSize > $projPath/alignment/bedgraph/${sampleList[$i]}_bowtie2.fragments.normalized.bedgraph

done


### step 5: call peaks with SEACR


seacr="SEACR_1.3.sh"
mkdir -p $projPath/peakCalling/SEACR


for i in ${!seqDepth[@]}
do
        bash $seacr $projPath/alignment/bedgraph/${sampleList[$i]}_bowtie2.fragments.normalized.bedgraph 0.05 non stringent $projPath/peakCalling/SEACR/${sampleList[$i]}_seacr_top0.05.peaks

done



