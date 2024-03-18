#!/usr/bin/perl
use strict;
use warnings;

my $gff=shift or die "perl $0 bed\n";
my $leng="chr.txt";
my $wind=100000;
my $out="$gff.sta";

my %hash;
open I,"< $gff";
while(<I>){
	chomp;
	my @a=split(/\s+/);
	my $sta=$a[1];
	my $end=$a[2];
	for(my $i=$sta;$i<=$end;$i++){
		$hash{$a[0]}{$i}=1;
	}
}
close I;

my %new;
open I,"< $leng";
while(<I>){
	chomp;
	my @a=split(/\s+/);
	next if($a[1] < 1000000);
	$new{$a[0]}=$a[1];
}
close I;

open O,"> $out";
foreach my $chr(sort keys %new){
	my $len=$new{$chr};
	my $num=int($len/$wind);
	my $xu=$len%$wind;
	if($xu > 1){
		$num=$num+1;
	}
	my $sta=1;
	for(my $i=1;$i<=$num;$i++){
		my $end=($sta-1)+$wind;
		if($end > $len){
			$end=$len;
		}
		my $cds=0;
		for(my $y=$sta;$y<=$end;$y++){
			if(exists $hash{$chr}{$y}){
				$cds++;
			}
		}
		my $per=$cds/$wind;
		print O"$chr\t$sta\t$end\t$per\n";
		$sta=$sta+$wind;
	}
}
close O;
