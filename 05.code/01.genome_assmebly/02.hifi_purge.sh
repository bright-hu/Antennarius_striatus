minimap2 -xasm20 -t 50 BiYu.ctg.fa m64066_230501_211406.hifi_reads.fastq.gz | gzip -c - > test.ccs.bam.paf.gz
pbcstat test.ccs.bam.paf.gz
calcuts PB.stat > cutoffs 2>calcults.log
split_fa BiYu.ctg.fa > asm.split
minimap2 -t 50 -xasm5 -DP asm.split asm.split | pigz -c > asm.split.self.paf.gz
purge_dups -2 -T cutoffs -c PB.base.cov asm.split.self.paf.gz > dups.bed 2> purge_dups.log
get_seqs -p hifi dups.bed BiYu.ctg.fa