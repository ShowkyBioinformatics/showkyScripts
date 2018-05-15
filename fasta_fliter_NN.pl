#!/usr/bin/perl -w
use strict;
sub Usage(){
	print STDERR "
	fasta_fliter_NN.pl <fasta> <less length>
	\n";
	exit(1);
}

&Usage() unless $#ARGV==1;
my %hash_fasta;
my $id;
my @array_order;
open IN,"<",$ARGV[0];
while (<IN>) {
	next if /^\s*$/;
	chomp();
	if (/^>([^\s]+)/){
		$id=$1;
		$hash_fasta{$id}->{"id"}=$_;
		$hash_fasta{$id}->{"sequence"}="";
		push @array_order,$id;
	}
	else{
		$hash_fasta{$id}->{"sequence"}.=$_;;
	}
}
close IN;

$ARGV[0]=~s/(\.\w+)$/_$ARGV[1]$1/;
open OUT,">",$ARGV[0];
foreach my $i(@array_order){
	my $len=length($hash_fasta{$i}->{"sequence"});
	next if $len<$ARGV[1];
	print OUT $hash_fasta{$i}->{"id"}."\n";
	for(my $j=0;$j<$len;$j+=60){
		print OUT substr($hash_fasta{$i}->{"sequence"},$j,60)."\n";
	}
}
close OUT;