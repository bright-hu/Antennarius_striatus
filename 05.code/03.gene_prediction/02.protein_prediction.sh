##Transcode
#Transcriptome assembly and annotion
for i in `ls data/`;do 
    rnaspades.py -1 data/$i/${i}_1.fq.gz -2 data/$i/${i}_2.fq.gz -o data/$i/;cd data/$i; TransDecoder.LongOrfs -t transcripts.fasta;TransDecoder.Predict -t transcripts.fasta;cd-hit -i transcripts.fasta.transdecoder.pep -o $i.cdhit.pep -T 30 -M 1600 > cdhit.out 2>&1;
done

##denovo
augustus --species=human --uniqueGeneId=true Biyu_hic.sm.fa > denovo.gff
##Genwise
#blat.sh
blat Biyu_hic.sm.fa Chicken.pep -makeOoc=Biyu_hic.sm.fa.dnax.ooc -t=dnax -q=prot out.psl
blat Biyu_hic.sm.fa query.pep -ooc=Biyu_hic.sm.fa.dnax.ooc -maxIntron=5000000 -noHead -t=dnax -q=prot Biyu_hic.psl;
#genwise.sh
genewise query.fa -nosplice_gtag -trev Biyu_hic.sm.fa -silent -pretty -pseudo -gff -cdna -trans > gene.genewise

##EVM.pl
perl partition_EVM_inputs.pl --genome Biyu_hic.sm.fa --gene_predictions denovo.gff --protein_alignments homolog.gff --segmentSize 5000000 --overlapSize 10000 --partition_listing partitions_list.out 

perl write_EVM_commands.pl \
 --genome Biyu_hic.sm.fa \
 --weighqts weights.txt \
 --gene_predictions denovo.gff \
 --protein_alignments homolog.gff \
 --output_file_name evm.out \
 --partitions partition/partitions_list.out > work.sh

perl convert_EVM_outputs_to_GFF3.pl \
	--partition partition/partitions_list.out \
	--output_file_name evm.out \
	--genome Biyu_hic.sm.fa
#The weight configurations were as follows: the weight of Augustus software predicted by denovo was 2, and the weight of homologous notes and transcripts of different tissues was 10.