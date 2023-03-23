#!/usr/bin/perl

# This script concatenate tsv files downloaded from GISAID.

# use
# perl concatenate_tsv_files.pl
# out:
# outfile.tsv outfile.fasta

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

my %hash;
my %headers;
my $n = 0;
my $ids = 0;

#-------------------------------------------------------------------------------
# Check if outfile.tsv and outfile.fasta files already exists

if (-e 'outfile.tsv'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named outfile.tsv already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm outfile.tsv\n");
	}
}

if (-e 'outfile.fasta'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named outfile.fasta already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm outfile.fasta\n");
	}
}
#-------------------------------------------------------------------------------
# Concatenate files

my @files = glob("*.metadata.tsv");

open (ROB, ">outfile.tsv") or die ("Can't open outfile.tsv\n");
foreach my $f (@files){
	$n++;
	print ("($n) $f\n");
	$f =~ /(.+)\.metadata\.tsv/;
	my $sequencefile = $1.'.sequences.fasta';
	if (!-e $sequencefile){
		print ("file dosn't exist: $sequencefile\n");
		print ("please check whether sequence and metadata files share the same name\n");
		print ("example: Aguascalientes.sequences.fasta, Aguascalientes.metadata.tsv\n");
		die;
	}
	if ($n == 1){
		system ("cp $sequencefile outfile.fasta");
		open (MAR, "$sequencefile") or die ("Can't open $sequencefile\n");
		while (my $linea = <MAR>){
			chomp ($linea);
			if ($linea =~ />(.+)/){
				$headers{$1} = 1;
			}
		}
		close (MAR);
		my $l = 0;
		open (MIA, "$f") or die ("Can't open $f\n");
		while (my $linea = <MIA>){
			$l++;
			if ($l == 1){
				print ROB ("$linea");
			} else {
				my @a = split (/\t/, $linea);
				if (!exists $hash{$a[0]}){
					if (exists $headers{$a[0]}){
						$hash{$a[1]} = 1;
						print ROB ("$linea");
						$ids = $ids +1;
					} else {
						die ("strain not found in $sequencefile\n");
					}
				} else {
					print ("Warning, repeated strain: $a[0]\n");
				}
			}
		}
		close (MIA);
	} else {
		system ("cat $sequencefile >> outfile.fasta");
		open (MAR, "$sequencefile") or die ("Can't open $sequencefile\n");
		while (my $linea = <MAR>){
			chomp ($linea);
			if ($linea =~ />(.+)/){
				$headers{$1} = 1;
			}
		}
		close (MAR);
		my $l = 0;
		open (MIA, "$f") or die ("Can't open $f\n");
		while (my $linea = <MIA>){
			$l++;
			if ($l > 1){
				my @a = split (/\t/, $linea);
				if (!exists $hash{$a[0]}){
					if (exists $headers{$a[0]}){
						$hash{$a[1]} = 1;
						print ROB ("$linea");
						$ids = $ids +1;
					} else {
						die ("strain not found in $sequencefile\n");
					}
				} else {
					print ("Warning, repeated strain: $a[0]\n");
				}
			}
		}
		close (MIA);
	}
}
close (ROB);
print ("\n");
print ("------------------------------------------------------------------------\n");
print ("Number of files..: $n\n");
print ("Number of genomes: $ids\n");
print ("------------------------------------------------------------------------\n");
