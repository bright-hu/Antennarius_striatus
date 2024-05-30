bwa index hifi.purged.fa -p hifi_purged
bwa mem -t 60 hifi_purged BY1-kidney2_R1.fil.fq.gz BY1-kidney2_R2.fil.fq.gz | samtools view -b -m 2g -@ 30 -o - > illu.bam
ngscstat illu.bam
calcuts TX.stat > cutoffs 2 > calcults.log
split_fa hifi.purged.fa > asm.split
minimap2 -t 50 -xasm5 -DP asm.split asm.split | pigz -c > asm.split.self.paf.gz
purge_dups -2 -T cutoffs -c TX.base.cov asm.split.self.paf.gz > dups.bed 2> purge_dups.log
get_seqs -p illu dups.bed hifi.purged.fa
