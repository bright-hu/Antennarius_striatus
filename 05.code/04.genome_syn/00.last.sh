##lastdb.sh
lastdb -P30 -c -u NEAR Antennarius_maculatus.NEAR Antennarius_maculatus.fa

##lastal.sh
lastal -i50G -P 50 -m 100 -E 0.05 Antennarius_maculatus.NEAR Biyu_hic.sm.chr.fa | last-split -m1 > temp.maf;

perl transfer.pl temp.maf
circos -conf circos.conf