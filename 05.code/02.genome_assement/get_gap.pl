use warnings;
use strict;
use Cwd;
use Getopt::Long;
my $now=getcwd;
#use Bio::SeqIO;
#####Mingliang Hu###
my $file=shift;
my $out="$file.gap";
$/=">";
open I , "< $file";
open O , "> $out";
my $gap=0;
my $num_total=0;
my $num = 0;
while(<I>){
    chomp;
    my @a = split(/\n/);
    next if (@a == 0);
    shift @a;
    my $seq = join("",@a);
    my @sort =  ($seq =~ /(n+)/ig) ;
    $num+=@sort;
    foreach my $xx (@sort){
        $num_total+=length($xx);
    }
}
close I;
$gap=$num;
print O "gap\t$gap\n";
close O;
print "gap : $gap;\nN number : $num_total\n"
