##TRF.sh
trf Biyu_hic.fa 2 7 7 80 10 50 500 -d -h -ngs > Biyu_hic.fa.dat; perl convertTRF2gff.pl Biyu_hic.fa.dat Biyu_hic.fa.gff

##Repeatmasker.sh
RepeatMasker -pa 12 -species danio -nolow -norna -no_is -gff Biyu_hic.fa -dir Biyu_hic

##repeatProteinMask.sh
RepeatProteinMask -engine ncbi -noLowSimple -pvalue 1e-04 Biyu_hic.fa

##RepeatModeler.sh
BuildDatabase -name Biyu_hic -engine ncbi Biyu_hic.fa 
RepeatModeler -database Biyu_hic -pa 10
RepeatMasker -e ncbi -lib consensi.fa.classified -gff Biyu_hic.fa -dir Biyu_hic

## softmask genome
cat ../*/*.gff > repeat.gff
maskFastaFromBed -soft -fi Biyu_hic.fa -bed repeat.gff -fo Biyu_hic.sm.fa