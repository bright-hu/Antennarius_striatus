export AUGUSTUS_CONFIG_PATH=~/software/augustus/config/
export BUSCO_CONFIG_FILE=~/software/busco/busco_v5.4.3/busco-5.4.3/config/config.ini
export PYTHONPATH=~/software/BUSCO/sepp-4.5.1.sepp/lib/python3.9/site-packages~/software/busco/busco_v5.4.3/busco-5.4.3/build/lib/:~/software/python3/Python-3.9.16_build/lib/python3.9/site-packages:$PYTHONPATH
export PATH=~/software/python3/Python-3.9.16_build/bin/:~/software/busco/pplacer-Linux-v1.1.alpha19:~/software/metaeuk/metaeuk-4-a0f584d/build/bin/:$PATH
export NUMEXPR_MAX_THREADS=50

genome=$1
kind=geno
sp=zebrafish
database=~/software/busco/database/actinopterygii_20240108_odb10
buscodir="${genome}_buscoV5_new"
core=20

rm -rf $buscodir
mkdir -p $buscodir && cd $buscodir

echo Start at: `date` && \
time ~/software/busco/busco_v5.4.3/busco-5.4.3/bin/busco -f -m $kind -i ../$genome -o busco -l $database -c $core && \
echo End at: `date` > ${genome}_BUSCO.log

