#!/usr/bin/perl

# This script substitutes pipes for underscores in the name of the sequences
# in both, fasta and metadata files. It also substitutes the name of the
# sequence Wuhan/Hu-1/2019 by Wuhan-Hu-1/2019. This is required in the new
# version of Nextstrain.

# use
# perl veryfinaltweak.pl metadata.sampled.tsv sequences.sampled.fasta
#out: outfile.fasta, outfile.tsv

# See https://github.com/luisdelaye/CurSa/ for more details.

# Author
# Luis Jose Delaye Arredondo
# Laboratorio de Genomica Evolutiva
# Departamento de Ingenieria Genetica
# CINVESTAV - Irapuato
# Mexico
# luis.delaye@cinvestav.mx
# Copy-Left  = : - )

# beta.1.0 version

use strict;

my $filetsv = $ARGV[0];
my $filefas = $ARGV[1];

my %hash;
open (MIA, "$filetsv") or die ("no puedo abrir $filetsv\n");
open (ROB, ">outfile.tsv") or die ("no puedo abrir outfile.tsv\n");
while (my $linea = <MIA>){
  chomp ($linea);
  my @a = split (/\t/, $linea);
  if ($a[0] =~ /\|/){
    my $id = $a[0];
    #print ("$a[0]\n");
    if ($a[0] =~ s/\|/_/g){
      $hash{$id} = $a[0];
      my $string = join ("\t", @a);
      print ROB ("$string\n");
      #my $pausa = <STDIN>;
    } else {
      die ("el patron 1 fallo: $a[0]\n");
    }
  } else {
    if ($a[0] =~ /Wuhan\/Hu-1\/2019/){
      $hash{$a[0]} = 'Wuhan-Hu-1/2019';
      $a[0] =~ s/Wuhan\/Hu-1\/2019/Wuhan-Hu-1\/2019/;
      my $string = join ("\t", @a);
      print ("->$string\n");
      print ROB ("$string\n");
    } else {
      $hash{$a[0]} = $a[0];
      print ("$linea\n");
      print ROB ("$linea\n");
    }
  }
}
close (ROB);
close (MIA);

open (MIA, "$filefas") or die ("no puedo abrir $filefas\n");
open (ROB, ">outfile.fasta") or die ("no puedo abrir outfile.fasta\n");
while (my $linea = <MIA>){
  chomp ($linea);
  if ($linea =~ />/){
    if ($linea =~ />(.+)/){
      my $id = $1;
      if (exists $hash{$id}){
        print ROB (">$hash{$id}\n");
      } else {
        print ("el id no existe: $id\n");
      }
    } else {
      die ("el patron 2 fallo: $linea\n");
    }
  } else {
    print ROB ("$linea\n");
  }
}
close (ROB);
close (MIA);
