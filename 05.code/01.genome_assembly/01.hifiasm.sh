hifiasm -o BiYu -t 60 m64066_230501_211406.hifi_reads.fastq.gz
awk '/^S/{print ">"$2;print $3}' BiYu.bp.p_ctg.gfa > BiYu.ctg.fa
