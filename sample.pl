#!/usr/bin/perl

# This script sample genomes for Nextstrain analysis.

# use
# perl sample.pl metadata.tsv sequences.fasta seed n dd-mm-yyyy dd-mm-yyyy
# out:
# sampled_metadata.tsv sampled_sequences.fasta sampled_report.txt

# seed			is an integer used to generate random numbers. Example: 2718
# n				is the percentage of genomes to sample per Pango lineage per month
# dd-mm-yyyy	is a date range in format day-month-year to start and end sampling

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

my $fileMe = $ARGV[0]; # metadata.tsv file
my $fileSe = $ARGV[1]; # sequence.fasta file
my $seed   = $ARGV[2]; # random number
my $rounds = $ARGV[3]; # 'n'
my $date1  = $ARGV[4]; # starting date
my $date2  = $ARGV[5]; # ending date

if ($date1 !~ /\d{4}-\d{2}-\d{2}/){
	$date1 = '2019-12-26';
}
if ($date2 !~ /\d{4}-\d{2}-\d{2}/){
	system ("date \"+DATE: %Y-%m-%d%n\" > date.tmp");
	open (MIA, "date.tmp") or die ("Can't open date.tmp\n");
	while (my $linea = <MIA>){
		chomp ($linea);
		if ($linea =~ /DATE: (\d{4}-\d{2}-\d{2})/){
			$date2 = $1;
		}
	}
	close (MIA);
	system ("rm date.tmp");
}

print ("------------------------------------------------------------------------\n");
print ("Sampling report\n");
print ("Metadata file....................: $fileMe\n");
print ("Sequence file....................: $fileSe\n");
print ("Seed number......................: $seed\n");
print ("Percentage of sequences to sample: $rounds\n");
print ("Genome sequences will be sampled from $date1 to $date2\n");
print ("\nDo you want to continue? (y/n)\n");
my $respuesta = <STDIN>;
if ($respuesta =~ /n/i){
	die ("\n");
}

srand($seed);

my %dates;
my $hashA = {};
my %selected;
my @selected;

my %accessions;
my $header;
my %strain;

my $l = 0;
my $n = 0;
my $N = 0;
my $Nsec = 0;

#-------------------------------------------------------------------------------
# Check if sampled_metadata.tsv and sampled_sequences.fasta files already exists

if (-e 'sampled_metadata.tsv'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named sampled_metadata.tsv already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm sampled_metadata.tsv\n")
	}
}

if (-e 'sampled_sequences.fasta'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named sampled_sequences.fasta already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm sampled_sequences.fasta\n")
	}
}

if (-e 'sampled_report.txt'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named sampled_report.txt already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm sampled_report.txt\n")
	}
}

#-------------------------------------------------------------------------------
# Gather information from the metadata.tsv file

open (MIA, "$fileMe") or die ("Can't open $fileMe\n");
while (my $linea = <MIA>){
	chomp ($linea);
	$l++;
	if ($l > 1 && $linea =~ /\w/){
		my @a = split (/\t/, $linea);
		if ($a[4] =~ /(\d{4}-\d{2})/){
			my $date = $1;
			$dates{$date}  += 1;
			push(@{$hashA->{$date}}, $a[2]);
			$accessions{$a[2]} = $linea;
		}
	} else {
		$header = $linea;
	}
}
close (MIA);
my @kdates = sort keys (%dates);
my @kpango;
my @kclade;

open (SOL, ">sampled_report.txt") or die ("Can't open sampled_report.txt\n");
print SOL ("\n------------------------------------------------------------------------\n");
print SOL ("Sampling report\n");
print SOL ("Metadata file....................: $fileMe\n");
print SOL ("Sequence file....................: $fileSe\n");
print SOL ("Seed number......................: $seed\n");
print SOL ("Percentage of sequences to sample: $rounds\n");
print SOL ("Genome sequences will be sampled from $date1 to $date2\n");
print SOL ("\n------------------------------------------------------------------------\n");
print SOL ("Number of genomes per collection date\n\n");
for (my $i = 0; $i <= $#kdates; $i++){
	print SOL ("$kdates[$i]\t$dates{$kdates[$i]}\n");
}
#-------------------------------------------------------------------------------
# Select genomes per month

print ("\n------------------------------------------------------------------------\n");
print ("Sampling genome sequences\n");

print SOL ("\n------------------------------------------------------------------------\n");
print SOL ("Sampling genomes on a monthly basis\n\n");
for (my $i = 0; $i <= $#kdates; $i++){
	print SOL ("---------------------------------------------------------\n");
	print SOL ("---------------------------------------------------------\n");
	print SOL ("Date.............: $kdates[$i]\n");
	print SOL ("Number of genomes: $dates{$kdates[$i]}\n");
	print SOL ("Genomes:\n");
	for (my $k = 0; $k <= $#{$hashA->{$kdates[$i]}}; $k++){
		if ($k < $#{$hashA->{$kdates[$i]}}){
			print SOL ("${$hashA->{$kdates[$i]}}[$k]; ");
		} else {
			print SOL ("${$hashA->{$kdates[$i]}}[$k]\n");
		}
	}
	my $Ng = $#{$hashA->{$kdates[$i]}} +1;
	my $treshold = $Ng*$rounds/100;
	my $redondeado = int($treshold + 0.5);
	my $s = 1;
	if ($s <= $redondeado){
		print SOL ("Sampled genomes:\n")
	}
	CICLOA:
	while ($s <= $redondeado){
		my $retval = int(rand($#{$hashA->{$kdates[$i]}} +1));
		#print ("\t\tselected (index: $retval; N: $N) -> (${$hashA->{$kdates[$i]}}[$retval])\n");
		#print ("${$hashA->{$kdates[$i]}}[$retval]\n");
		if (!exists $selected{${$hashA->{$kdates[$i]}}[$retval]}){
			print SOL ("${$hashA->{$kdates[$i]}}[$retval]\n");
			$selected{${$hashA->{$kdates[$i]}}[$retval]} = 1;
			push (@selected, ${$hashA->{$kdates[$i]}}[$retval]);
			$s++;
			my @tmp = @{$hashA->{$kdates[$i]}};
			my $idt = ${$hashA->{$kdates[$i]}}[$retval];
			@{$hashA->{$kdates[$i]}} = ();
			for (my $k = 0; $k <= $#tmp; $k++){
				if ($tmp[$k] !~ /$idt/){
					push (@{$hashA->{$kdates[$i]}}, $tmp[$k]);
				}
			}
		} else {
			print ("this genome was selected already: ${$hashA->{$kdates[$i]}}[$retval]}\n");
			die ("run again the script but using a different seed for the random number generator\n");
		}
		my $asize = @{$hashA->{$kdates[$i]}};
		if ($asize == 0){
			last (CICLOA);
		}
	}
}
open (ROB, ">sampled_metadata.tsv") or die ("Can't open file sampled_metadata.tsv\n");
print ROB ("$header\n");
for (my $i = 0; $i <= $#selected; $i++){
	print ROB ("$accessions{$selected[$i]}\n");
	my @a = split (/\t/, $accessions{$selected[$i]});
	$strain{$a[0]} = 1;
	$N++;
}
close (ROB);
#-------------------------------------------------------------------------------
# Gather sampled sequences

print ("\n------------------------------------------------------------------------\n");
print ("Making the fasta file\n");

my $r = 0;
my $sec;
my $name;

open (MIA, "$fileSe") or die ("No puedo abrir $fileSe\n");
open (ROB, ">sampled_sequences.fasta") or die ("Can't open sampled_sequences.fasta\n");
while (my $linea = <MIA>){
	#chomp ($linea);
	if ($linea =~ />/ && $r == 1){
    $name =~ s/>//;
    chomp ($name);
		if ($strain{$name} == 1){
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
  $name =~ s/>//;
  chomp ($name);
  if ($strain{$name} == 1){
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

print ("\n");
print ("------------------------------------------------------------------------\n");
print ("Number of genomes sampled in metadata..: $N\n");
print ("Number of genomes sampled in fasta file: $Nsec\n");
print ("------------------------------------------------------------------------\n");
print SOL ("\n");
print SOL ("------------------------------------------------------------------------\n");
print SOL ("Number of genomes sampled in metadata..: $N\n");
print SOL ("Number of genomes sampled in fasta file: $Nsec\n");
print SOL ("------------------------------------------------------------------------\n");
close (SOL);
#-------------------------------------------------------------------------------
