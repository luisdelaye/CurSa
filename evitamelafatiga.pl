#!/usr/local/bin/perl

use strict;

my $file1 = $ARGV[0];
my $file2 = $ARGV[1];

my %hash;

my $c = 0;
open (MIA, "$file1") or die ("No puedo abrir $file1\n");
while (my $linea = <MIA>){
  chomp ($linea);
  if ($linea =~ /\(\*\)/){
    $linea =~ s/\s+\(\*\)//;
    $c++;
    my @a = split (/\t/, $linea);
    $hash{$a[1]} = 0;
    #print ("$c\t($linea)\t($hash{$a[1]})\n");
    print ("$c\t($a[1])\t($hash{$a[1]})\n");
  }
}
close (MIA);
print ("\n-----\n");
$c = 0;
open (MIA, "$file2") or die ("No puedo abrir $file2\n");
open (ROB, ">outfile") or die ("No puedo abrir outfile\n");
while (my $linea = <MIA>){
  chomp ($linea);
  my @a = split (/\t/, $linea);
  if (exists $hash{$a[1]} && $hash{$a[1]} == 0){
    $c++;
    my $p = $hash{$a[1]};
    $hash{$a[1]} += 1;
    print ("$c\t$linea\t($a[1])\t($p -> $hash{$a[1]})\n");
    print ROB ("$linea\n")
  }
}
close (ROB);
close (MIA);
print ("\n-----\n");
print ("\n-----\n");
my @keys = sort keys (%hash);

$c = 0;
foreach my $key (@keys){
  if ($hash{$keys[$key]} == 1){
    $c++;
    print ("($c)\t($key)\t($hash{$keys[$key]})\n");
  }
}
