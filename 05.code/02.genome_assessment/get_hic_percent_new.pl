use warnings;
use strict;
use Cwd;
use Getopt::Long;
#use Bio::SeqIO;
my $now=getcwd;
###Mingliang Hu###
my ($fai,$chr);
GetOptions(
	'fai=s'=>\$fai,
	'chr=n'=>\$chr);
&print_help if (!($fai && $chr));

my ($total,$chr_size);
open I , "< $fai";
my $num=0;
while(<I>){
	chomp;
	my @a = split;
	next if (@a == 0);
	$num++;
	my ($id,$size)=($a[0],$a[1]);
#	$id=~s/HiC_scaffold_//;
	$chr_size+=$size if ($num <= $chr);
	$total+=$size;
}
close I;
my $per=($chr_size/$total)*100;
$per=sprintf("%0.2f",$per);
print "chr_num\tper\tchr_size\tall_size\n";
print "$chr\t$per\t$chr_size\t$total\n";

sub print_help{
	print "Usage:perl $0 --fai <fai> --chr <num>;\n";
	exit();
}
