for i in `ls *fa`;do perl get_hic_percent_new.pl --fai <fai> --chr <num> > $i.ratio 2>&1;done