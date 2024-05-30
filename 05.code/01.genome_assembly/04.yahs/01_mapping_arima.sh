#! /bin/bash

##############################################
# ARIMA GENOMICS MAPPING PIPELINE 02/08/2019 #
##############################################

#Below find the commands used to map HiC data.

#Replace the variables at the top with the correct paths for the locations of files/programs on your system.

#This bash script will map one paired end HiC dataset (read1 & read2 fastqs). Feel to modify and multiplex as you see fit to work with your volume of samples and system.

##########################################
# Commands #
##########################################

# main path
main_folder="~/Software/mapping_pipeline"

SRA='BY1hic'
LABEL='biyu'
BWA='~/Software/bwa/bwa'
SAMTOOLS='samtools'
IN_DIR='fastq'
REF='biyu.fa'
FAIDX='$REF.fai'
PREFIX='biyu'
RAW_DIR='out/bams'
FILT_DIR='out/filtered/bams'
FILTER=${main_folder}'/filter_five_end.pl'
COMBINER=${main_folder}'/two_read_bam_combiner.pl'
STATS=${main_folder}'/get_stats.pl'
PICARD='~/Software/picard/picard.jar'
TMP_DIR='temp'
PAIR_DIR='out/paired/bams'
# REP_DIR='/path/to/where/you/want/deduplicated/files'
#REP_LABEL=$LABEL\_rep1
# MERGE_DIR='/path/to/final/merged/alignments/from/any/biological/replicates'
MAPQ_FILTER=10
CPU=40

echo "### Step 0: Check output directories exist & create them as needed"
[ -d $RAW_DIR ] || mkdir -p $RAW_DIR
[ -d $FILT_DIR ] || mkdir -p $FILT_DIR
[ -d $TMP_DIR ] || mkdir -p $TMP_DIR
[ -d $PAIR_DIR ] || mkdir -p $PAIR_DIR
 [ -d $REP_DIR ] || mkdir -p $REP_DIR
 [ -d $MERGE_DIR ] || mkdir -p $MERGE_DIR

echo "### Step 0: Index reference" # Run only once! Skip this step if you have already generated BWA index files
[[ -f ${PREFIX}.bwt ]] || $BWA index -a bwtsw -p $PREFIX $REF

echo "### Step 0.5: Building fai file"
[[ -f ${PREFIX}.fa.fai ]] || $SAMTOOLS faidx ${PREFIX}.fa

echo "### Step 1.A: FASTQ to BAM (1st)"
$BWA mem -t $CPU `basename -s .fa $REF` $IN_DIR/$SRA\_1.fq.gz | $SAMTOOLS view -@ $CPU -Sb - > $RAW_DIR/$SRA\_1.bam

echo "### Step 1.B: FASTQ to BAM (2nd)"
$BWA mem -t $CPU `basename -s .fa $REF` $IN_DIR/$SRA\_2.fq.gz | $SAMTOOLS view -@ $CPU -Sb - > $RAW_DIR/$SRA\_2.bam

echo "### Step 2.A: Filter 5' end (1st)"
$SAMTOOLS view -h $RAW_DIR/$SRA\_1.bam | perl $FILTER | $SAMTOOLS view -Sb - > $FILT_DIR/$SRA\_1.bam

echo "### Step 2.B: Filter 5' end (2nd)"
$SAMTOOLS view -h $RAW_DIR/$SRA\_2.bam | perl $FILTER | $SAMTOOLS view -Sb - > $FILT_DIR/$SRA\_2.bam

echo "### Step 3A: Pair reads & mapping quality filter"
perl $COMBINER $FILT_DIR/$SRA\_1.bam $FILT_DIR/$SRA\_2.bam $SAMTOOLS $MAPQ_FILTER | $SAMTOOLS view -bS -t $FAIDX - | $SAMTOOLS sort -@ $CPU -o $TMP_DIR/$SRA.bam -

echo "### Step 3.B: Add read group"
java -Xmx4G -Djava.io.tmpdir=temp/ -jar $PICARD AddOrReplaceReadGroups INPUT=$TMP_DIR/$SRA.bam OUTPUT=$PAIR_DIR/$SRA.bam ID=$SRA LB=$SRA SM=$LABEL PL=ILLUMINA PU=none
