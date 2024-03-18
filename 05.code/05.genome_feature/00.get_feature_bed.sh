cat Type.dir/DNA-*.merge| sed 's/scaffold_//' - | awk -F "\t" 'BEGIN{OFS="\t"}{if($1<25) print $0}' - |sort -k1,1 -k2,2n -|bedtools merge -i - > DNA.bed
cat Type.dir/TRF-*.merge| sed 's/scaffold_//' - | awk -F "\t" 'BEGIN{OFS="\t"}{if($1<25) print $0}' - |sort -k1,1 -k2,2n -|bedtools merge -i - > TRF.bed
cat Type.dir/LINE-*.merge| sed 's/scaffold_//' - | awk -F "\t" 'BEGIN{OFS="\t"}{if($1<25) print $0}' - |sort -k1,1 -k2,2n -|bedtools merge -i - > LINE.bed
cat Type.dir/LTR-*.merge| sed 's/scaffold_//' - | awk -F "\t" 'BEGIN{OFS="\t"}{if($1<25) print $0}' - |sort -k1,1 -k2,2n -|bedtools merge -i - > LTR.bed
cat Type.dir/SINE-*.merge| sed 's/scaffold_//' - | awk -F "\t" 'BEGIN{OFS="\t"}{if($1<25) print $0}' - |sort -k1,1 -k2,2n -|bedtools merge -i - > SINE.bed

grep -E "CDS" biyu.gff|sed 's/scaffold_//' -| awk -F "\t" 'BEGIN{OFS="\t"}{if($1<25) print $1,$4,$5}' - > gene.bed
