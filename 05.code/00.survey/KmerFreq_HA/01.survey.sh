for i in {13,15,17,19,21,23,25,27};do
	echo "mkdir -p K_$i;cd K_$i;KmerFreq_HA -k $i -t 50 -p biyu_$i -l ../reads.list -L 150 >kmerfreq.log 2>kmerfreq.err";
done > ${0}.sh
