#!/usr/local/bin/perl

# This script format metadata and sequence files for Nextstrain

# use
# perl format.pl metadata.tsv sequences.fasta
# out:
# formated_metadata.tsv formated_sequences.fasta

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

#-------------------------------------------------------------------------------
# Global variables

my $fileMe = $ARGV[0]; # metadata file
my $fileSe = $ARGV[1]; # sequence fasta file

my $header;
my %accessionsN;
my %accessionsI;
my @acckeys;
my $Nacc = 0;
my $Nsec = 0;

#-------------------------------------------------------------------------------
# Check if formated_metadata.tsv and formated_sequences.fasta files already exists

if (-e 'formated_metadata.tsv'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named formated_metadata.tsv already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm formated_metadata.tsv\n")
	}
}

if (-e 'formated_sequences.fasta'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named formated_sequences.fasta already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm formated_sequences.fasta\n")
	}
}

#-------------------------------------------------------------------------------
# Gather information from the metadata.tsv file and eliminate duplicate
# records for the same strain keeping the latest record.

my $l = 0;

open (MIA, "$fileMe") or die ("Can't open file $fileMe\n");
while (my $linea = <MIA>){
	chomp ($linea);
  $l++;
  if ($l > 1){
    my @a = split (/\t/, $linea);
    $a[0] =~ s/hCoV-19\///;
    if (!exists $accessionsN{$a[0]}){
      $accessionsN{$a[0]} += 1;
      my $newlinea = join ("\t", @a);
      $accessionsI{$a[0]} = $newlinea;
      push (@acckeys, $a[0]);
      $Nacc++;
    } else {
      my @dateNew = split (/-/, $a[4]);
      my @b = split (/\t/, $accessionsI{$a[0]});
      my @dateOld = split (/-/, $b[4]);
      if ($dateOld[0] <= $dateNew[0]){
        if ($dateOld[1] <= $dateNew[1]){
          if ($dateOld[2] < $dateNew[2]){
            $accessionsN{$a[0]} += 1;
            my $newlinea = join ("\t", @a);
            $accessionsI{$a[0]} = $newlinea;
          }
        }
      }
    }
	} else {
    $header = $linea;
  }
}
close (MIA);

# Print duplicates
#my @keys = sort keys (%accessionsN);
#for (my $i = 0; $i <= $#keys; $i++){
#  if ($accessionsN{$keys[$i]} > 1){
#    print ("$keys[$i]\t($accessionsN{$keys[$i]})\n");
#    my @a = split (/\t/, $accessionsI{$keys[$i]});
#    print ("$a[2]\t$a[4]\n")
#    #my $pausa = <STDIN>;
#  }
#}

# Creates new metadata file
open (ROB, ">formated_metadata.tsv") or die ("Can't open formated_metadata.tsv\n");
print ROB ("$header\n");
for (my $i = 0; $i <= $#acckeys; $i++){
  print ROB ("$accessionsI{$acckeys[$i]}\n");
}
close (ROB);

#-------------------------------------------------------------------------------
# Creates the new sequence file eliminating duplicated sequences sharing the
# same header and strip the prefix hCoV-19/.

my $r = 0;
my $sec;
my $name;

open (MIA, "$fileSe") or die ("No puedo abrir $fileSe\n");
open (ROB, ">formated_sequences.fasta") or die ("Can't open formated_sequences.fasta\n");
while (my $linea = <MIA>){
	#chomp ($linea);
	if ($linea =~ />/ && $r == 1){
    $name =~ s/>hCoV-19\///;
    chomp ($name);
		if ($accessionsN{$name} >= 1){
      print ROB (">$name\n");
      print ROB ("$sec");
      $Nsec++;
    }
		$r = 0;
		$name = $sec = ();
	}
	if ($linea !~ />/ && $r == 1){
		$sec = $sec.$linea;
	}
	if ($linea =~ />/ && $r == 0){
		$name = $linea;
		$r = 1;
	}
}
if ($r == 1){
  $name =~ s/>hCoV-19\///;
  chomp ($name);
  if ($accessionsN{$name} >= 1){
    print ROB (">$name\n");
    print ROB ("$sec");
    $Nsec++;
  }
	$r = 0;
	$name = $sec = ();
}
close (ROB);
close (MIA);

#-------------------------------------------------------------------------------
# Summarize the results
print ("------------------------------------------------------------------------\n");
print ("Number of entries in formated_metadata.tsv...: $Nacc\n");
print ("Number of entries in formated_sequences.fasta: $Nacc\n");
print ("------------------------------------------------------------------------\n");
#-------------------------------------------------------------------------------
