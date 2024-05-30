juicer_tools="java -Xmx200G -jar ~/software/pacakges/juicer_tools.jar pre"
pretext_map="~/software/miniconda3/bin/PretextMap"
pretext_snapshot="~/software/miniconda3/bin/PretextSnapshot"
samtools="~/software/samtools/samtools-1.16.1_build/bin"
out="yahs.out"
outdir="~/00.data/purge/yahs"
contigs="illu.purged.fa" # need to be indexed, i.e., test.fa.gz.fai is available
hicaln="out/paired/bams/*.bam"



[[ -f ${out}.fa.fai ]] || samtools faidx ${out}.fa

~/software/pacakges/yahs-1.1/yahs ${out}.fa out/paired/bams/*.bam

#可视化
(~/software/pacakges/yahs-1.1/juicer pre ${outdir}/${out}.bin ${outdir}/${out}_scaffolds_final.agp ${contigs}.fai 2>${outdir}/tmp_juicer_pre.log | LC_ALL=C sort -k2,2d -k6,6d -T ${outdir} --parallel=20 -S32G | awk 'NF' > ${outdir}/alignments_sorted.txt.part) && (mv ${outdir}/alignments_sorted.txt.part ${outdir}/alignments_sorted.txt)

cat ${outdir}/tmp_juicer_pre.log | grep "PRE_C_SIZE" | cut -d' ' -f2- >${outdir}/${out}_scaffolds_final.chrom.sizes

## do juicer hic map
(${juicer_tools} ${outdir}/alignments_sorted.txt ${outdir}/${out}.hic.part ${outdir}/${out}_scaffolds_final.chrom.sizes) && (mv ${outdir}/${out}.hic.part ${outdir}/${out}.hic)
## do Pretext hic map
(awk 'BEGIN{print "## pairs format v1.0"} {print "#chromsize:\t"$1"\t"$2} END {print "#columns:\treadID\tchr1\tpos1\tchr2\tpos2\tstrand1\tstrand2"}' ${outdir}/${out}_scaffolds_final.chrom.sizes; awk '{print ".\t"$2"\t"$3"\t"$6"\t"$7"\t.\t."}' ${outdir}/ alignments_sorted.txt) | ${pretext_map} -o ${outdir}/${out}.pretext
# and a pretext snapshot
${pretext_snapshot} -m ${outdir}/${out}.pretext --sequences "=full" -o ${outdir}

#### this is to generate input file for juicer_tools - assembly (JBAT) mode (-a)
~/software/pacakges/yahs-1.1/juicer pre -a -o ${outdir}/${out}_JBAT ${outdir}/${out}.bin ${outdir}/${out}_scaffolds_final.agp ${contigs}.fai 2>${outdir}/tmp_juicer_pre_JBAT.log
cat ${outdir}/tmp_juicer_pre_JBAT.log | grep "PRE_C_SIZE" | cut -d' ' -f2- >${outdir}/${out}_JBAT.chrom.sizes
${juicer_tools} ${outdir}/${out}_JBAT.txt ${outdir}/${out}_JBAT.hic.part ${outdir}/${out}_JBAT.chrom.sizes
mv ${outdir}/${out}_JBAT.hic.part ${outdir}/${out}_JBAT.hic

#### this is to generate final genome assembly file after manual curation with JuiceBox (JBAT)
## the output assembly file after curation is ${outdir}/${out}_JBAT.review.assembly
## the final output is ${outdir}/${out}_JBAT.FINAL.agp and ${outdir}/${out}_JBAT.FINAL.fa
export PATH=$PATH:~/software/chromap/chromap-master:~/software/yahs/yahs-main:~/software/samtools/build/bin
####手动修改后到处的assembly文件
review=yahs.out_JBAT.review.assembly
agp=yahs.out_JBAT.liftover.agp
juicer post -o BiYu_hic $review $agp $contigs