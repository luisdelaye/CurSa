#!/usr/bin/perl

# This script creates files for Microreact.

# use
# perl create_microreact.pl lat_longs.e1.tsv aligned.fasta metadata.tsv Mexico
# out: outfile_for_microreact.tsv

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

my $file1   = $ARGV[0]; # lat_longs.e1.tsv
my $file2   = $ARGV[1]; # aligned.fasta
my $file3   = $ARGV[2]; # metadata.tsv

my $l = 0;

my %seq;
my %subseq;

my %location_lat;
my %division_lat;
my %country_lat;
my %region_lat;
my %location_lon;
my %division_lon;
my %country_lon;
my %region_lon;

#-------------------------------------------------------------------------------
# Check if an outfile.tsv file already exists

if (-e 'outfile_for_microreact.tsv'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named outfile_for_microreact.tsv already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm outfile_for_microreact.tsv\n")
	}
}

#-----------------------------------------------------------------------------------------
# Save in a hash the information of latitude and longitude

open (MIA, "$file1") or die ("Can't open file $file1\n");
while (my $linea = <MIA>){
	chomp ($linea);
	my @a = split (/\t/, $linea);
	#print ("($a[0])\t($a[1])\t($a[2])\t($a[3])\n");
	if ($a[0] =~ /location/){
		$location_lat{$a[1]} = $a[2];
		$location_lon{$a[1]} = $a[3];
	} elsif ($a[0] =~ /division/){
		$division_lat{$a[1]} = $a[2];
		$division_lon{$a[1]} = $a[3];
	} elsif ($a[0] =~ /country/){
		$country_lat{$a[1]} = $a[2];
		$country_lon{$a[1]} = $a[3];
	} elsif ($a[0] =~ /region/){
		$region_lat{$a[1]} = $a[2];
		$region_lon{$a[1]} = $a[3];
	}
}
close (MIA);

#-----------------------------------------------------------------------------------------
# Save in a hash the names of the OTUs to preserve in the pruned tree

open (MIA, "$file2") or die ("Can't open file $file2\n");
while (my $linea = <MIA>){
	chomp ($linea);
	if ($linea =~ />(.+)/){
		my $OTU = $1;
		$seq{$OTU} = 0;
	}
}

#-----------------------------------------------------------------------------------------
# Create the files for Microreact

open (MIA, "$file3") or die ("Can't open file $file3\n");
open (ROB, ">outfile_for_microreact.tsv") or die ("Can't open file outfile_for_microreact.tsv\n");
print ROB ("id\tlatitude\tlongitude\tyear\tmonth\tday\tvariant\tvariant__color\n");
while (my $linea = <MIA>){
	chomp ($linea);
	$l++;
	my @a = split (/\t/, $linea);
	if ($l > 1){
		$a[0] =~ s/^hCoV-19\///;
		# Collect dates
		my @b = split (/-/, $a[4]);
		my $day   = ();
		my $month = ();
		my $year  = ();
		if ($b[0] !~ /\d/){
			$year = '?';
		} else {
			$year = $b[0];
		}
		if ($b[1] !~ /\d/){
			$month = '?';
		} else {
			$month = $b[1];
		}
		if ($b[2] !~ /\d/){
			$day = '?';
		} else {
			$day = $b[2];
		}
		# Color VOCs
		my $v  = 'other';
		my $vc = '#A5A9A9';
		if ($a[18] eq 'B.1.1.7'){
			$v  = 'Alpha';
			$vc = '#F5F507';
		} elsif ($a[18] eq 'B.1.351'){
			$v  = 'Beta';
			$vc = '#F507F5';
		} elsif ($a[18] eq 'P.1'){
			$v  = 'Gamma';
			$vc = '#07F507';
		} elsif ($a[18] eq 'B.1.617.2' || $a[18] =~ /^AY\.[\d\.]+$/){
			$v  = 'Delta';
			$vc = '#0707F5';
		} elsif ($a[18] eq 'B.1.1.529' || $a[18] eq 'BA.1' ||
			$a[18] eq 'BA.1.1' || $a[18] eq 'BA.2' ||
			$a[18] eq 'BA.4' || $a[18] eq 'BA.5'){
			$v  = 'Omicron';
			$vc = '#F50707';
		}
		if (exists $seq{$a[0]}){
			if ($a[8] =~ /\w/){
					$seq{$a[0]} = 1;
					print ROB ("$a[0]\t$location_lat{$a[8]}\t$location_lon{$a[8]}\t$year\t$month\t$day\t$v\t$vc\n");
			} elsif ($a[7] =~ /\w/){
					$seq{$a[0]} = 1;
					print ROB ("$a[0]\t$division_lat{$a[7]}\t$division_lon{$a[7]}\t$year\t$month\t$day\t$v\t$vc\n");
			} elsif ($a[6] =~ /\w/){
					$seq{$a[0]} = 1;
					print ROB ("$a[0]\t$country_lat{$a[6]}\t$country_lon{$a[6]}\t$year\t$month\t$day\t$v\t$vc\n");
			} elsif ($a[5] =~ /\w/){
					$seq{$a[0]} = 1;
					print ROB ("$a[0]\t$region_lat{$a[5]}\t$region_lon{$a[5]}\t$year\t$month\t$day\t$v\t$vc\n");
			}
		}
	}
}
close (ROB);
close (MIA);
