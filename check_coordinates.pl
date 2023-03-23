#!/usr/bin/perl

# This script checks whether all the names from geographic localities in
# color_ordering.tsv have an associated coordinate in lat_longs.tsv.

# use
# perl check_coordinates.pl metadata.tsv color_ordering.tsv lat_longs.tsv country
# out:
# names_lacking_coordinates.txt

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

my $fileMe  = $ARGV[0]; # metadata.tsv file
my $fileCo  = $ARGV[1]; # color_ordering.tsv file
my $fileLL  = $ARGV[2]; # lat_longs.tsv file
my $country = $ARGV[3]; # focus country

my %hash;              # category of geographic localities
my %meta;              # localities in metadata.tsv
my @places;            # list of locations from $country
my %coord;             # places with coordinates in lat_longs.tsv file

#-------------------------------------------------------------------------------
# Check if an outfile.tsv file already exists

if (-e 'names_lacking_coordinates.txt'){
	print ("\n------------------------------------------------------------------------\n");
	print ("A file named names_lacking_coordinates.txt already exists.\n");
	print ("If you continue with the analysis, its content will be replaced.\n");
	print ("Do you want to continue? (y/n)\n");
	my $answer = <STDIN>;
	if ($answer =~ /n/i){
		die;
	} else {
		system ("rm names_lacking_coordinates.txt\n");
	}
}

#-------------------------------------------------------------------------------
# Gather information from the metadata.tsv file

my $lm = 0;

open (MIA, "$fileMe") or die ("Can't open file $fileMe\n");
while (my $linea = <MIA>){
	chomp ($linea);
	$lm++;
	if ($lm > 1){
		my @a = split (/\t/, $linea);
		$meta{$a[7]} += 1 if ($a[7] =~ /\w/);
		$meta{$a[8]} += 1 if ($a[7] =~ /\w/);
	}
}
close (MIA);


#-------------------------------------------------------------------------------
# Gather information from the color_ordering.tsv file

my $r = 0;

open (MIA, "$fileCo") or die ("Can't open file $fileCo\n");
while (my $linea = <MIA>){
	chomp ($linea);
	if ($linea =~ /^###/ && $r == 1){
		$r = 0;
	}
	if ($r == 1){
		my @a = split (/\t/, $linea);
		$hash{$a[1]} = 1;
		push (@places, $linea);
	}
	if ($linea =~ /^###\s$country/ && $r == 0){
		push (@places, $linea);
		$r = 1;
	}
}
close (MIA);

#-------------------------------------------------------------------------------
# Gather information from the lat_longs.tsv file

open (MIA, "$fileLL") or die ("Can't open file $fileLL\n");
while (my $linea = <MIA>){
	chomp ($linea);
	my @a = split (/\t/, $linea);
	$coord{$a[1]} = 1;
}
close (MIA);

#-------------------------------------------------------------------------------
# Identify places without coordinates

print ("\n(*) Localities not in $fileMe that lack coordinates in $fileLL\n");
print ("(**) Localities included $fileMe that lack coordinates in $fileLL\n\n");

open (ROB, ">names_lacking_coordinates.txt") or die ("Can't open file names_lacking_coordinates.txt\n");
for (my $i = 0; $i <= $#places; $i++){
	print ("$places[$i]");
	print ROB ("$places[$i]");
	if ($i > 0){
		my @a = split (/\t/, $places[$i]);
		#print (" --> @a\n");
		if (!exists $coord{$a[1]}){
			if (exists $meta{$a[1]}){
				print (" (**)\n");
				print ROB (" (**)\n");
			} else {
				print (" (*)\n");
				print ROB (" (*)\n");
			}
		} else {
			print ("\n");
			print ROB ("\n");
		}
	} else {
		print ("\n");
		print ROB ("\n");
	}
}
close (ROB);

#-------------------------------------------------------------------------------
