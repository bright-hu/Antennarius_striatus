for i in {13,15,17,19,21,23,25,27,29,31};do
	echo "mkdir -p K_$i;cd K_$i;jellyfish count -C -m $i -s 30000000000 -t 50 -g ../generators -o reads_$i.jf;jellyfish histo -t 50 reads_$i.jf > reads_$i.histo";
done > ${0}.sh
