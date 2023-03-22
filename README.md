# CurSa
Perl scripts to Curate metadata information and Sample SARS-CoV-2 genome sequences downloaded from GISAID for analysis and display in Nextstrain and Microreact.

## beta.1.0.0 version

Last update: March 20, 2023.

The scripts in this repository facilitate the curation of metadata downloaded from GISAID to make phylogenetic analysis of SARS-CoV-2. In particular, the scripts provided here facilitate the curation of the geographic categories 'location' and 'division'. This curation is an important step to properly display the sampling origin of genome sequences in Nextstrain and Microreact. The scripts provided here also allow to subsample sequences from GISAID to make a phylogeneitc analysis in Nextstrain (Figure 1). To run CurSa scripts you only need to have Perl and a Linux environment. We used these scripts to create [Mexstrain](https://ira.cinvestav.mx/mexstrain/).

<p align="center">
  <img width="720" height="1276" src="https://github.com/luisdelaye/CurSa/blob/main/Figure_CurSa_1.png">
</p>
Figure 1. Roadmap to use CurSa scripts.
<p></p>

Next, we show how to use the scripts to curate the names from geographical localities in the metadata and sample SARS-CoV-2 sequences for phylogenetic analysis with Nextstrain and display in Microreact.

### Collect data

The first step is to select a focal country. In our case we will select Mexico. Go to GISAID database and search all complete, high coverage genomes with collection date complete from the country of interest and download them in the format: 'Input for the Augur pipeline'. If there are more than 5000 genome sequences from the focal country, you will have to download the genome sequences in different batches. In the case of Mexico, we downloaded the sequences from each one of the states separatedly (Figure 2).

<p align="center">
  <img width="735.75" height="490.5" src="https://github.com/luisdelaye/CurSa/blob/main/Figure_CurSa_2.png">
</p>
<p style='text-align: right;'> Figure 2. Search and download all genome sequences from the focal country. </p>

We recommend to download the files to a separate folder. For instance we download them to GISAID20230223/. 
<p></p>
When downloading the sequences from the different states (Aguascalientes, Baja California, Baja California Sur, etc.) decompress them and add the name of the state to each one of the files (avoiding spaces or accents in the name of the files), for example:

```
GISAID20230223/
$ tar -xf gisaid_auspice_input_hcov-19_2023_02_23_20.tar
$ mv 1677184368344.metadata.tsv Aguascalientes.metadata.tsv
$ mv 1677184368344.sequences.fasta Aguascalientes.sequences.fasta
$ rm gisaid_auspice_input_hcov-19_2023_02_23_20.tar
```

Just keep the '.metadata.tsv' and '.sequences.fasta' extensions. These will be used by the next script to recognize the files. Next, within the folder that contains the files, you will need to run the script:

```
GISAID20230223/
$ perl concatenate_tsv_files.pl
(1) Aguascalientes.metadata.tsv
(2) Baja_California.metadata.tsv
(3) Baja_California_Sur.metadata.tsv
(4) Campeche.metadata.tsv
(5) Cancun.metadata.tsv
(6) CDMX.metadata.tsv
(7) Chiapas.metadata.tsv
(8) Chihuahua.metadata.tsv
(9) Ciudad_de_Mexico.metadata.tsv
(10) CMX.metadata.tsv
(11) Coahuila.metadata.tsv
(12) Colima.metadata.tsv
(13) Distrito_Federal.metadata.tsv
(14) Durango.metadata.tsv
(15) Estado_de_Mexico.metadata.tsv
(16) Guanajuato.metadata.tsv
(17) Guerrero.metadata.tsv
(18) Hidalgo.metadata.tsv
(19) Jalisco.metadata.tsv
(20) Mexico_City_2019-01-01_2020-12-31.metadata.tsv
(21) Mexico_City_2021-01-01_2021-06-30.metadata.tsv
(22) Mexico_City_2021-07-01_2021-12-31.metadata.tsv
(23) Mexico_City_2022-01-01_2022-12-31.metadata.tsv
(24) Michoacan.metadata.tsv
(25) Morelos.metadata.tsv
(26) Nayarit.metadata.tsv
(27) Nuevo_Leon.metadata.tsv
(28) Oaxaca.metadata.tsv
(29) Puebla.metadata.tsv
(30) Queretaro.metadata.tsv
(31) Quintana_Roo.metadata.tsv
(32) San_Luis_Potosi.metadata.tsv
(33) Sinaloa.metadata.tsv
(34) Sonora.metadata.tsv
(35) State_of_Mexico.metadata.tsv
(36) Tabasco.metadata.tsv
(37) Tamaulipas.metadata.tsv
(38) Tlaxcala.metadata.tsv
(39) Veracruz.metadata.tsv
(40) Yucatan.metadata.tsv
(41) Zacatecas.metadata.tsv

------------------------------------------------------------------------
Number of files..: 41
Number of genomes: 35633
------------------------------------------------------------------------

```

Now, rename the outfiles and move them to a working directory (for instance, we use data20230223/): 

```
GISAID20230223/
$ mv outfile.tsv ../data20230223/Mexico.metadata.tsv
$ mv outfile.fasta ../data20230223/Mexico.sequences.fasta
```

### Curate the files containing the names of geographic localities 

Now comes the toughest part: to assure that the names of the geographic localities are spelled the same in color_ordering.tsv, lat_longs.tsv and metadata.tsv files (Figure 3). First, a bit of background. We will asume that you have a [local Nextstrain installation](https://docs.nextstrain.org/en/latest/install.html). Now, Nextstrain store the names of geographic localities in two files: color_ordering.tsv and lat_longs.tsv. These files live in: ncov/defaults/ wihtin your Nextstrain installation directory. The first file (color_ordering.tsv) is used by Nextstrain to know if a given locality is a 'region', 'country', 'division' or a 'location'; the second file (lat_longs.tsv) keep record of the geographic coordinates of all the places found in color_ordering.tsv. These files were prepared by the people of Nextstrain and (almost always!) share the same geographic localities. The names in color_ordering.tsv will be used as "gold standards" to identify typos and other inconsistencies in metadata.tsv and lat_longs.tsv, so before proceeding it is a good practice to open the file with a text editor (like [ATOM](https://atom.io)) and correct any error you find.

<p align="center">
  <img width="720" height="405" src="https://github.com/luisdelaye/CurSa/blob/main/Figure_CurSa_3.jpeg">
</p>
<p style='text-align: right;'> Figure 3. The names of the geographic localities (highlighted in yellow) have to coincide between color_ordering.tsv, lat_longs.tsv and metadata.tsv files. </p>

By the way, [Sombrerete](https://es.wikipedia.org/wiki/Sombrerete) is a Mexican city declared as a UNESCO World Heritage Site were the film [Caveman](https://en.wikipedia.org/wiki/Caveman_(film)) was filmed nearby (starred by Ringo Starr). You can see the full movie [here](https://www.youtube.com/watch?v=YxDjnTrRSiA).

Next, the metadata.tsv file donwloaded from GISAID has a column whith the geographic location where each coronavirus was sampled. The information in this column is used by Nextstrain to geolocalize the samples. To do so, each geographic location whithin metadata.tsv has to be represented in color_ordering.tsv and lat_longs.tsv files. However, this is not always the case because the names in metadata.tsv are captured by many different people around the world and sometimes these people introduce typos; or the names in metadata.tsv and in color_ordering.tsv and lat_longs.tsv files can be in different languages. In addition, there can be geographic localities in metadata.tsv that are lacking in color_ordering.tsv (and lat_longs.tsv) because the people from Nextstrain hasn't had the time to add them. We will see next how to fix these problems. Just keep in mind that at the end, all names from the geographic localities in metadata.tsv have to be in color_ordering.tsv; and every name from a geographic locality in metadata.tsv has to be associated to a geographic coordinate in lat_longs.tsv.

The first thing to do is to check whether the names of the geographic localities in metadata.tsv are found in color_ordering.tsv. We will do this specifically for the names of the country on which you would like to focus your Nextstrain analysis (in this case Mexico). For this we use the script compare_names.pl. We recommend you to make security copies of the original color_ordering.tsv and lat_longs.tsv files (in case you would like to recover the original files) and then make a copy of color_ordering.tsv and lat_longs.tsv to your working directory. Then run the script:

```
data20230223/
$ cp ~/Software/ncov/defaults/color_ordering.tsv .
$ cp ~/Software/ncov/defaults/lat_longs.tsv .
$ perl compare_names.pl color_ordering.tsv Mexico.metadata.tsv Mexico
```

This script will check if the names of the geographical localities in metadata.tsv are found in color_ordering.tsv. If a name is not found, it will print a warning message to the screen (Part 1 of the output). This script will also check whether the same name is repeated whithin different geographic contexts (Part 2). We will see later that this may not be an error by itself. Note that if you analyze the sequences from a country whose name contain spaces (like 'Costa Rica') you have to replace spaces with underscores (i.e. Costa_Rica). In our example data, the first time you run the compare_names.pl script you will get the following output:

```
------------------------------------------------------------------------
Part 1
Are there names in Mexico.metadata.tsv lacking in color_ordering.tsv?

Warning! name not found in color_ordering.tsv: 'Aguasacalientes'
context in Mexico.metadata.tsv: North America / Mexico / Aguascalientes / Aguasacalientes

Warning! name not found in color_ordering.tsv: 'Pabello de A'
context in Mexico.metadata.tsv: North America / Mexico / Aguascalientes / Pabello de A

Warning! name not found in color_ordering.tsv: 'Ensenada'
context in Mexico.metadata.tsv: North America / Mexico / Baja California / Ensenada

Warning! name not found in color_ordering.tsv: 'La Paz'
context in Mexico.metadata.tsv: North America / Mexico / Baja California Sur / La Paz

Warning! name not found in color_ordering.tsv: 'Carmen'
context in Mexico.metadata.tsv: North America / Mexico / Campeche / Carmen

Warning! name not found in color_ordering.tsv: 'Cancun'
context in Mexico.metadata.tsv: North America / Mexico / Cancun

Warning! name not found in color_ordering.tsv: 'CDMX'
context in Mexico.metadata.tsv: North America / Mexico / CDMX

Warning! name not found in color_ordering.tsv: 'Cuauhtemoc'
context in Mexico.metadata.tsv: North America / Mexico / Chihuahua / Cuauhtemoc

Warning! name not found in color_ordering.tsv: 'Ciudad de Mexico'
context in Mexico.metadata.tsv: North America / Mexico / Ciudad de Mexico

Warning! name not found in color_ordering.tsv: 'CMX'
context in Mexico.metadata.tsv: North America / Mexico / CMX

Warning! name not found in color_ordering.tsv: 'Frontera'
context in Mexico.metadata.tsv: North America / Mexico / Coahuila / Frontera

Warning! name not found in color_ordering.tsv: 'Cardonal Hgo'
context in Mexico.metadata.tsv: North America / Mexico / Hidalgo / Cardonal Hgo

Warning! name not found in color_ordering.tsv: 'Cuauhtemoc'
context in Mexico.metadata.tsv: North America / Mexico / Mexico City / Cuauhtemoc

Warning! name not found in color_ordering.tsv: 'Guadalupe'
context in Mexico.metadata.tsv: North America / Mexico / Nuevo Leon / Guadalupe

Warning! name not found in color_ordering.tsv: 'Gral. Escobedo'
context in Mexico.metadata.tsv: North America / Mexico / Nuevo Leon / Gral. Escobedo

Warning! name not found in color_ordering.tsv: 'Abasolo Nvo Leon'
context in Mexico.metadata.tsv: North America / Mexico / Nuevo Leon / Abasolo Nvo Leon

Warning! name not found in color_ordering.tsv: 'Rioverde'
context in Mexico.metadata.tsv: North America / Mexico / San Luis Potosi / Rioverde

Warning! name not found in color_ordering.tsv: 'Nogales'
context in Mexico.metadata.tsv: North America / Mexico / Sonora / Nogales

Warning! name not found in color_ordering.tsv: 'State of Mexico'
context in Mexico.metadata.tsv: North America / Mexico / State of Mexico

Warning! name not found in color_ordering.tsv: 'State of Mexico'
context in Mexico.metadata.tsv: North America / Mexico / State of Mexico / Nicolas Romero

Warning! name not found in color_ordering.tsv: 'State of Mexico'
context in Mexico.metadata.tsv: North America / Mexico / State of Mexico / Naucalpan de Juarez

Warning! name not found in color_ordering.tsv: 'Cardenas'
context in Mexico.metadata.tsv: North America / Mexico / Tabasco / Cardenas

Warning! name not found in color_ordering.tsv: 'Altamira'
context in Mexico.metadata.tsv: North America / Mexico / Tamaulipas / Altamira

Warning! name not found in color_ordering.tsv: 'Cordoba'
context in Mexico.metadata.tsv: North America / Mexico / Veracruz / Cordoba

Warning! name not found in color_ordering.tsv: 'Rio Grande'
context in Mexico.metadata.tsv: North America / Mexico / Zacatecas / Rio Grande

Warning! name not found in color_ordering.tsv: 'Calera'
context in Mexico.metadata.tsv: North America / Mexico / Zacatecas / Calera

Warning! name not found in color_ordering.tsv: 'Guadalupe'
context in Mexico.metadata.tsv: North America / Mexico / Zacatecas / Guadalupe

------------------------------------------------------------------------
Part 2
Checking if the same name is repeated in different geographic contexts

Warning! the name 'Cuauhtemoc' is in more than one geographic context:
North America / Mexico / Chihuahua / 'Cuauhtemoc'
North America / Mexico / Mexico City / 'Cuauhtemoc'

Warning! the name 'Guadalupe' is in more than one geographic context:
North America / Mexico / Nuevo Leon / 'Guadalupe'
North America / Mexico / Zacatecas / 'Guadalupe'

Warning! the name 'Tecate' is in more than one geographic context:
North America / Mexico / Baja California / 'Tecate'
North America / Mexico / Baja California Sur / 'Tecate'

------------------------------------------------------------------------
Now run substitute_names.pl.
See https://github.com/luisdelaye/CurSa/ for more details.
------------------------------------------------------------------------
```

As mentioned above, the output has two sections. The first part, shows if there is a name in metadata.tsv that is not found in color_ordering.tsv. The warning shows the name that is lacking together with its geographical context. For instance, the name 'Rio Grande' is lacking in color_ordering.tsv and its geographical context whitin metadata.tsv is: 'North America / Mexico / Zacatecas / Rio Grande'. It is important to understand that whithin metadata.tsv the names of the geographic localities are organized in the following way: 'region\tcountry\tdivision\tlocation' (where \t stands for tab). Not all entries in metadata.tsv have the four categories, some of them have only 'region\tcountry\tdivision' or less. In this case 'Rio Grande' is a 'location'.

The second part of the output shows whether there are names repeated within differen geographical contexts. Note that this may not be an error by itself since it is common to find localities sharing the same name. For instance, see the case of 'Guadalupe' which can refer to a city in 'Nuevo Leon' or to a city in the state of Zacatecas. We will see how to fix these cases. 

In addition to report the inconsistencies to the screen, compare_names.pl creates a text file named substitute_proposal.tsv that contains three columns separated by tabs:

```
'Aguasacalientes'	'North America / Mexico / Aguascalientes / Aguasacalientes'	'North America / Mexico / Aguascalientes / Aguasacalientes'
'Pabello de A'	'North America / Mexico / Aguascalientes / Pabello de A'	'North America / Mexico / Aguascalientes / Pabello de A'
'Ensenada'	'North America / Mexico / Baja California / Ensenada'	'North America / Mexico / Baja California / Ensenada'
'La Paz'	'North America / Mexico / Baja California Sur / La Paz'	'North America / Mexico / Baja California Sur / La Paz'
'CDMX'	'North America / Mexico / CDMX'	'North America / Mexico / CDMX'
'CMX'	'North America / Mexico / CMX'	'North America / Mexico / CMX'
'Carmen'	'North America / Mexico / Campeche / Carmen'	'North America / Mexico / Campeche / Carmen'
'Cancun'	'North America / Mexico / Cancun'	'North America / Mexico / Cancun'
'Cuauhtemoc'	'North America / Mexico / Chihuahua / Cuauhtemoc'	'North America / Mexico / Chihuahua / Cuauhtemoc'
'Ciudad de Mexico'	'North America / Mexico / Ciudad de Mexico'	'North America / Mexico / Ciudad de Mexico'
'Frontera'	'North America / Mexico / Coahuila / Frontera'	'North America / Mexico / Coahuila / Frontera'
'Cardonal Hgo'	'North America / Mexico / Hidalgo / Cardonal Hgo'	'North America / Mexico / Hidalgo / Cardonal Hgo'
'Cuauhtemoc'	'North America / Mexico / Mexico City / Cuauhtemoc'	'North America / Mexico / Mexico City / Cuauhtemoc'
'Abasolo Nvo Leon'	'North America / Mexico / Nuevo Leon / Abasolo Nvo Leon'	'North America / Mexico / Nuevo Leon / Abasolo Nvo Leon'
'Gral. Escobedo'	'North America / Mexico / Nuevo Leon / Gral. Escobedo'	'North America / Mexico / Nuevo Leon / Gral. Escobedo'
'Guadalupe'	'North America / Mexico / Nuevo Leon / Guadalupe'	'North America / Mexico / Nuevo Leon / Guadalupe'
'Rioverde'	'North America / Mexico / San Luis Potosi / Rioverde'	'North America / Mexico / San Luis Potosi / Rioverde'
'Nogales'	'North America / Mexico / Sonora / Nogales'	'North America / Mexico / Sonora / Nogales'
'State of Mexico'	'North America / Mexico / State of Mexico'	'North America / Mexico / State of Mexico'
'State of Mexico'	'North America / Mexico / State of Mexico / Nicolas Romero'	'North America / Mexico / State of Mexico / Nicolas Romero'
'Cardenas'	'North America / Mexico / Tabasco / Cardenas'	'North America / Mexico / Tabasco / Cardenas'
'Altamira'	'North America / Mexico / Tamaulipas / Altamira'	'North America / Mexico / Tamaulipas / Altamira'
'Cordoba'	'North America / Mexico / Veracruz / Cordoba'	'North America / Mexico / Veracruz / Cordoba'
'Calera'	'North America / Mexico / Zacatecas / Calera'	'North America / Mexico / Zacatecas / Calera'
'Guadalupe'	'North America / Mexico / Zacatecas / Guadalupe'	'North America / Mexico / Zacatecas / Guadalupe'
'Rio Grande'	'North America / Mexico / Zacatecas / Rio Grande'	'North America / Mexico / Zacatecas / Rio Grande'
'Tecate'	'North America / Mexico / Baja California / Tecate'	'North America / Mexico / Baja California / Tecate'
'Tecate'	'North America / Mexico / Baja California Sur / Tecate'	'North America / Mexico / Baja California Sur / Tecate'
```

The first column shows the name of the geographic location in metadata.tsv that is lacking in color_ordering.tsv; the second column shows the geographical context of the name; and the third column is identical to the second one. Each column is separated by a tab. By editing and correcting the information in the third column, a new metadata file will be created with the error corrected. Please, rename this file in case you have to do several rounds of curation:

```
data20230223/
$ mv substitute_proposal.tsv substitute_proposal_round1.tsv
```

Now that you have an overview of which names do not match, we are going to proceed to fix them. For this, we will use the script substitute_names.pl, the file substitute_proposal_round1.tsv and some manual curation. We will review three main cases.

#### Case 1: a name in metadata.tsv is lacking in color_ordering.tsv and lat_longs.tsv

We will begin by adding to color_ordering.tsv (and lat_longs.tsv) those extra names that are found in metadata.tsv. Start by opening the color_ordering.tsv file with a text edditor ([ATOM](https://atom.io)). Then, take a look at the first part of the output from compare_names.pl. We will start by analysing 'Cancun'. By looking at color_ordering.tsv you will find that the location of 'Cancun' is lacking. In this case, simply add the name 'Cancun' to color_ordering.tsv. You will have to add this name under the state of 'Quintana Roo'. For instance, 'Cancun' is a 'location' whithin de 'division' of 'Quintana Roo'. Therefore you will have to add the following text to color_ordering.tsv:

```
# Quintana Roo
location	Cancun
```

Note that there is a tab between the word 'location' and 'Cancun'. Because you added a new name to color_ordering.pl, you will have to add this name also to lat_longs.tsv file. Open lat_longs.tsv with a text edditor (like [ATOM](https://atom.io)) and find the correct place (names are in alphabetical order) to add:

```
location	Cancun	21.16	-86.82
```

Note that the fields are separated by tabs. You can find the coordinates from 'Cancun' through its [Wikipedia](https://es.wikipedia.org/wiki/Cancún) page of the city and then clicking on its geographic coordinates: 21°09′41″N 86°49′29″O. This will take you to a [GeoHack page](https://geohack.toolforge.org/geohack.php?language=es&pagename=Cancún&params=21.161416111111_N_-86.824811111111_E_type:city) where you can find the coordinates in decimal. You will need to do the same for all names you add to color_ordering.tsv. 

#### Case 2: the name in metadata.tsv is not spelled correctly

In some occasions the geographic locality is in metadata.tsv and in color_ordering.tsv (and in lat_longs.tsv), but it is written in a different language between files or the name in one of the files has some typos. Lets take a look at: 'Aguascalientes / Pabello de A'. If you google 'Aguascalientes Pabello de A' you will find that 'Pabello de A' refers to a small city named 'Pabellon de Arteaga' in the State of 'Aguascalientes'. Therefore, you have to substitute 'Pabello de A' by 'Pabellon de Arteaga' in metadata.tsv. To do this, open the file substitute_proposal_round1.tsv with a text editor ([ATOM](https://atom.io)) and find the row containing 'Pabello de A'. Then substitute 'Pabello de A' by 'Pabellon de Arteaga' in the third column (do not remove the single quotes nor the spaces between the slashes /). Example:

```
'Pabello de A'  'North America / Mexico / Aguascalientes / Pabello de A'  'North America / Mexico / Aguascalientes / Pabellon de Arteaga'
```

In addition to the above, check if 'Pabellon de Arteaga' is in color_ordering.tsv and lat_longs.tsv. If not, you will have to add this name to both files as described above. 

#### Case 3: a name is repeated in different geographical contexts

Now we will review the second part of the output of compare_names.pl. Take a look to the case of 'Guadalupe'. In Mexico there are two cities with the name 'Guadalupe', one is in the state of 'Nuevo Leon' and the other is in the state of 'Zacatecas'. Because of this, we will have to change the name of the cities to differentiate one from the other. One possibility is to name the cities as 'Guadalupe (Nuevo Leon)' and 'Guadalupe (Zacatecas)'. Use the third column in the file substitute_proposal_round1.tsv as explained before to change these names. In addition, add the names of 'Guadalupe (Nuevo Leon)' and 'Guadalupe (Zacatecas)' to color_orderin.tsv and their geographic coordinates to lat_longs.tsv.

Just remember, the idea is that all names in metadata.tsv have a match in color_ordering.tsv and lat_longs.tsv files.

#### Create a new metadata.tsv file

Once you have finished correcting all the names as described above, run the following script:

```
data20230203/
$ perl substitute_names.pl Mexico.metadata.tsv substitute_proposal_round1.tsv
------------------------------------------------------------------------
A substitute_proposal.tsv file was provided: substitute_proposal_round1.tsv
------------------------------------------------------------------------
Analysing: Mexico.metadata.tsv
------------------------------------------------------------------------
The following names were substituted, please check:

old: 'North America / Mexico / Aguascalientes / Aguasacalientes'
new: 'North America / Mexico / Aguascalientes / Aguascalientes'

old: 'North America / Mexico / Aguascalientes / Pabello de A'
new: 'North America / Mexico / Aguascalientes / Pabellon de Arteaga'

old: 'North America / Mexico / Baja California / Ensenada'
new: 'North America / Mexico / Baja California / Ensenada MX'

old: 'North America / Mexico / Baja California Sur / La Paz'
new: 'North America / Mexico / Baja California Sur / La Paz MX'

old: 'North America / Mexico / Baja California Sur / Tecate'
new: 'North America / Mexico / Baja California / Tecate'

old: 'North America / Mexico / CDMX'
new: 'North America / Mexico / Mexico City'

old: 'North America / Mexico / CMX'
new: 'North America / Mexico / Mexico City'

old: 'North America / Mexico / Campeche / Carmen'
new: 'North America / Mexico / Campeche / Ciudad del Carmen'

old: 'North America / Mexico / Chihuahua / Cuauhtemoc'
new: 'North America / Mexico / Chihuahua / Ciudad Cuauhtemoc'

old: 'North America / Mexico / Ciudad de Mexico'
new: 'North America / Mexico / Mexico City'

old: 'North America / Mexico / Coahuila / Frontera'
new: 'North America / Mexico / Coahuila / Frontera MX'

old: 'North America / Mexico / Hidalgo / Cardonal Hgo'
new: 'North America / Mexico / Hidalgo / Cardonal'

old: 'North America / Mexico / Mexico City / Cuauhtemoc'
new: 'North America / Mexico / Mexico City / Cuauhtemoc (Mexico City)'

old: 'North America / Mexico / Nuevo Leon / Abasolo Nvo Leon'
new: 'North America / Mexico / Nuevo Leon / Abasolo (Nuevo Leon)'

old: 'North America / Mexico / Nuevo Leon / Gral. Escobedo'
new: 'North America / Mexico / Nuevo Leon / Ciudad General Escobedo'

old: 'North America / Mexico / Nuevo Leon / Guadalupe'
new: 'North America / Mexico / Nuevo Leon / Guadalupe (Nuevo Leon)'

old: 'North America / Mexico / San Luis Potosi / Rioverde'
new: 'North America / Mexico / San Luis Potosi / Rioverde MX'

old: 'North America / Mexico / Sonora / Nogales'
new: 'North America / Mexico / Sonora / Nogales MX'

old: 'North America / Mexico / State of Mexico'
new: 'North America / Mexico / Estado de Mexico'

old: 'North America / Mexico / State of Mexico / Naucalpan de Juarez'
new: 'North America / Mexico / Estado de Mexico / Naucalpan de Juarez'

old: 'North America / Mexico / State of Mexico / Nicolas Romero'
new: 'North America / Mexico / Estado de Mexico / Nicolas Romero'

old: 'North America / Mexico / Tabasco / Cardenas'
new: 'North America / Mexico / Tabasco / Cardenas MX'

old: 'North America / Mexico / Tamaulipas / Altamira'
new: 'North America / Mexico / Tamaulipas / Altamira (Tamaulipas)'

old: 'North America / Mexico / Veracruz / Cordoba'
new: 'North America / Mexico / Veracruz / Cordoba MX'

old: 'North America / Mexico / Zacatecas / Calera'
new: 'North America / Mexico / Zacatecas / Calera MX'

old: 'North America / Mexico / Zacatecas / Guadalupe'
new: 'North America / Mexico / Zacatecas / Guadalupe (Zacatecas)'

old: 'North America / Mexico / Zacatecas / Rio Grande'
new: 'North America / Mexico / Zacatecas / Rio Grande MX'

------------------------------------------------------------------------
Results are written to outfile.tsv.
Now run compare_names.pl.
See https://github.com/luisdelaye/CurSa/ for more details.
------------------------------------------------------------------------
```

This script will output the file: outfile.tsv. This file is an exact copy of metadata.tsv except for those names that were substituted according to the third column in substitute_proposal_round1.tsv. You have to rename the outfile.tsv, in case you need to do several rounds of curation:

```
data20230223/
$ mv outfile.tsv metadata_round1.tsv
```

Next, run the script compare_names.pl again, but now on outfile_round1.tsv to see if there are no more mismatches:

```
data20230223/
$ perl compare_names.pl color_ordering.tsv metadata_round1.tsv Mexico
```

i) If there were mismatches, go for another round of curation, just remember to rename the new file substitute_proposal.tsv to substitute_proposal_round2.tsv: 

```
data20230203/
$ mv substitute_proposal.tsv substitute_proposal_round2.tsv
```

Make the corresponding editions to substitute_proposal_round2.tsv and then apply the script substitute_names.pl again:

```
data20230203/
$ perl substitute_names.pl metadata_round1.tsv substitute_proposal_round2.tsv
```

An so on...

ii) Alternatively, if there are no more mismatches you should get the following output:

```
------------------------------------------------------------------------
Part 1
Are there names in metadata_round1.tsv lacking in color_ordering.tsv?

------------------------------------------------------------------------
Part 2
Checking if the same name is repeated in different geographic contexts

There are no names repeated in different geographic contexts
------------------------------------------------------------------------
All names in metadata_round1.tsv have a match in color_ordering.tsv
See https://github.com/luisdelaye/CurSa/ for more details.
------------------------------------------------------------------------
```

Now change the name of the metadata file that has no inconsistencies:

```
data20230223/
$ mv metadata_round1.tsv substituted.metadata.tsv
```

#### Checking for the correspondence between color_ordering.tsv and lat_longs.tsv

Next, we are going to check whether all the names in color_ordering.tsv have a coordinate in lat_longs.tsv. For this, run the next script:

```
$ perl check_coordinates.pl color_ordering.tsv lat_longs.e1.tsv Mexico
```

And you will get an output similar to the next one:

```
The names marked with an (*) lack coordinates in lat_longs.e1.tsv:

### Mexico
# Baja California
location	Rosarito
location	Tijuana
location	Ensenada
location	Mexicali
location	Tecate

# Baja California Sur
location	Los Cabos

# Nuevo Leon
location	San Nicolas De Los Garza
location	Monterrey
location	Abasolo
location	Altamira Nuevo Leon
location	Apodaca
location	Cadereyta Jimenez
location	Cerralvo
location	Cienega de Flores (*)

```

Note that the location 'Cienega de Flores' is marked with an (\*), meaning that there are no coordinates in lat_longs.tsv file for this place. To fix this, simply open lat_longs.tsv and add the geographic coordinates as explined before.

A final tweak to the color_ordering.tsv file is necessary before we go to the next step. Open the color_ordering.tsv file with a text editor (like [ATOM](https://atom.io)) and replace 'Sobral de Monte Agrac O' by 'Sobral de Monte Agraco'. There is a hidden caracter in the last word 'Agrac O' that has to be removed this way. Don't forget to do the same in lat_longs.tsv file. 

Now, copy the color_ordering.tsv and lat_longs.tsv files to their directory:

```
$ cp color_ordering.tsv  /Users/jose/Software/ncov/defaults/
$ cp lat_longs.tsv  /Users/jose/Software/ncov/defaults/
```

### Format the metadata file for Nextstrain

Next, we are going to create the metadata file in the format required for Nextstrain. But first, we need to prepare some files:

```
$ grep '>' sequences.fasta > sequences.fasta.headers.txt
$ grep '>' spikeprot####.fasta > spikeprot####.fasta.headers.txt 
```

Now, run the script format_metadata.pl:

```
$ perl format_metadata.pl metadata.e1.tsv sequences.fasta.headers.txt spikeprot####.fasta.headers.txt
```

You will get the following message:


```
------------------------------------------------------------------------
Number of headers in outfile.tsv: 6912788
------------------------------------------------------------------------
```

This output indicates the number of entries in the new metadata file outfile.tsv. Each entry has its corresponding genome sequence in sequences.fasta.
Next, rename the outfile.tsv:

```
$ mv outfile.tsv metadata.e2.tsv 
```

### Sample sequences for Nextstrain analysis

Nextstrain can handle and display approximately 5000 sequences. But you may have much more. For instance, at the date of writing there are about 15000 sequences from Mexico. Therefore, you need to sample a set of sequences to make the Nextstrain analysis. Here we provide a script to sample a percentage of N genomes from each [Pangolin](https://cov-lineages.org/pangolin.html) lineage per month. This script uses a random number generator to select which genomes to sample. If you use the same number in subsequent runs, you will get the same set of sequences. In our example, we will select to sample 5 per cent of genome sequences from each Pangolin lineage per month and use the number 2718 to seed the random number generator.

Before running the script, we have to delete hidden new line characters:

```
$ perl replace_mc.pl gisaid_hcov-19_2022_##_##.tsv 
$ mv gisaid_hcov-19_2022_##_##.tsv.e1 gisaid_hcov-19_2022_##_##.e1.tsv 
```

Now, run the script to sample the sequences:

```
$ perl sample_genomes_GISAID.pl gisaid_hcov-19_2022_##_##.e1.tsv 2718 5
```

The script will print to the screen: number of genomes per collection date; number of genomes per Pangolin lineage; number of genomes per clade; and will indicate which genomes were sampled per month per lineage. Next, rename the output:

```
$ mv outfile.tsv gisaid_hcov-19_2022_##_##.e1.sampled.tsv
```

Now, you may whant to sample the genomes downloaded from [Nextstrain global analysis](https://nextstrain.org/ncov/gisaid/global). We can us the same seed to generate random numbers and select at most 5 sequences from each Pangolin lineage per month:

```
$ perl sample_genomes_Nextstrain.pl metadata.e2.tsv nextstrain_ncov_gisaid_global_acknowledgements.tsv 2718 5
$ mv outfile.tsv nextstrain_ncov_global_metadata.sampled.tsv
```

The script will print the same statistics as the previous one. Then, rename the output:

```
$ mv outfile.tsv nextstrain_ncov_gisaid_global.sampled.tsv
```

### Create the sequence and metadata files for Nextstrain analysis

Now we are going to join those genomes sequences that were sampled in the previous steps (from GISAID and Nextstrain) into a single file for Nextstrain analysis. Their associated metadata will be joined too into a single metadata file. This will take a while...

```
$ perl join_sampled_genomes.pl gisaid_hcov-19_2022_##_##.e1.sampled.tsv nextstrain_ncov_gisaid_global.sampled.tsv metadata.e2.tsv sequences.fasta
out: outfile.tsv, outfile.fasta
$ mv outfile.tsv metadata.sampled.tsv
$ mv outfile.fasta sequences.sampled.fasta
```

Now, check wheter the sequences used as external group by Nextstrain are among those that are selected:

```
$ grep 'EPI_ISL_402125' metadata.sampled.tsv 
$ grep 'EPI_ISL_406798' metadata.sampled.tsv 
```

If they are not, includ them with the following script:

```
$ perl add_outgroup.pl metadata.sampled.tsv
$ mv outfile.tsv metadata.sampled.tsv
$ cat sequences.sampled.fasta EPI_ISL_402125.fasta EPI_ISL_406798.fasta > outfile.fasta
$ mv outfile.fasta sequences.sampled.fasta
```

Note that you have to download the sequences EPI_ISL_402125 and EPI_ISL_406798 from [GISAID](https://www.gisaid.org) before concatenating the fasta files. Make sure that the sequence EPI_ISL_402125 contains the FASTA header: >hCoV-19/Wuhan/Hu-1/2019|2019-12-31|2020-01-12; and the sequence EPI_ISL_406798 contains the FASTA header >hCoV-19/Wuhan/WH01/2019|2019-12-26|2020-01-30.

Now, a final tweaks to the metadata and sequences file:

```
$ perl substitute_outgroup_name.pl metadata.sampled.tsv

bingo!
The sequence:
hCoV-19/Wuhan/Hu-1/2019|2019-12-31|2020-01-12
was substituted by: Wuhan/Hu-1/2019

bingo!
The sequence:
hCoV-19/Wuhan/WH01/2019|2019-12-26|2020-01-30
was substituted by: Wuhan/WH01/2019

------------------------------------------------------------------------
The IDs of both outgroups were changed successfully
------------------------------------------------------------------------

$ mv outfile metadata.sampled.tsv
$ perl substitute_outgroup_name.pl sequences.sampled.fasta

bingo!
The sequence:
hCoV-19/Wuhan/Hu-1/2019|2019-12-31|2020-01-12
was substituted by: Wuhan/Hu-1/2019

bingo!
The sequence:
hCoV-19/Wuhan/WH01/2019|2019-12-26|2020-01-30
was substituted by: Wuhan/WH01/2019

------------------------------------------------------------------------
The IDs of both outgroups were changed successfully
------------------------------------------------------------------------

$ mv outfile sequences.sampled.fasta
```

The above step is required because Nextstrain requires the outgroup sequences to have the names: Wuhan/WH01/2019 and Wuhan/Hu-1/2019. 

Now, check whether there are hiden characters in the sequence file:

```
$ perl replace_mc.pl sequences.sampled.fasta
$ mv sequences.sampled.fasta.e1 sequences.sampled.fasta
```

And finally:

```
$ perl veryfinaltweak.pl metadata.sampled.tsv sequences.sampled.fasta
$ mv outfile.fasta sequences.sampled.fasta
$ mv outfile.tsv metadata.sampled.tsv
```

With this, you have the sequence and the metadata files required to run a Nextstrain analysis:

```
metadata.sampled.tsv
sequences.sampled.fasta
```

Copy these files to the proper location within your Nextstrain local installation (in my case this is):

```
$ cp metadata.sampled.tsv /Users/jose/Software/ncov/data/
$ cp sequences.sampled.fasta /Users/jose/Software/ncov/data/
```

Configure the files builds.yaml, config.yaml, my_auspice_config.json, my_description.md that live within ncov/my_profiles/yourprofileforthisrun/.

But we haven't finished yet. You may want to tell Nextstrain to include in the analysis all the sequences you sampled from the chosen country (in this case Mexico) you which to focus on. For this, you can use the following script:

```
$ perl select_sequences_to_include.pl sequences.sampled.fasta Mexico > add_to_the_include_file.txt
```

Now you simply add the names of the sequences in the file add_to_the_include_file.txt to the file ncov/defaults/include.txt. If you do not add these sequence names to include.txt, Nextstrain will sample from your sample, and this may not be what you want.

Now, run Nextstrain!

```
$ conda activate nextstrain
$ nextstrain build . --cores all --configfile my_profiles/yourprofileforthisrun/config.yaml
```

### Optional: add columns to the metadata file

If you like, yo can add special columns to the metadata file. Just run:

```
#$ perl add_columns_to_metadata.pl metadata.sampled.tsv
#$ mv outfile.tsv metadata.sampled.tsv
```
Of course, you have to do the above step just before copying the metadata file to: /Users/jose/Software/ncov/data/.

By default, the script will add a column named VOC where the [Variants of Concern](https://cov-lineages.org/lineage_list.html) will be indicated (Alpha, Beta, Gamma, Delta and Omicron). You can modify the behavior of the script by opening with a text editor (like [ATOM](https://atom.io)) and changing the following section:

```
				#-----------------------------------------------------------------------
				# Here you can modify the options to add the column you want
				# VOC
				if ($a[15] eq 'B.1.1.7'){
					print ROB ("$a[$i]\tAlpha\n");
				} elsif ($a[15] eq 'B.1.351'){
					print ROB ("$a[$i]\tBeta\n");
				} elsif ($a[15] eq 'P.1'){
					print ROB ("$a[$i]\tGamma\n");
				} elsif ($a[15] eq 'B.1.617.2' || $a[15] =~ /^AY\.[\d\.]+$/){
					print ROB ("$a[$i]\tDelta\n");
				} elsif ($a[15] eq 'B.1.1.529' || $a[15] eq 'BA.1' || $a[15] eq 'BA.1.1'
				 			|| $a[15] eq 'BA.2' || $a[15] eq 'BA.3'){
					print ROB ("$a[$i]\tOmicron\n");
				} else {
					print ROB ("$a[$i]\tother\n");
				}
				#-----------------------------------------------------------------------
```

Because the script add_columns_to_metadata.pl adds the column VOC to the metadata file, you will need to modify the my_auspice_config.json file. You can find this file in one of the folders of: ncov/my_profiles/. Open the file and add where properly:

```
    {
      "key": "VOC",
      "title": "Variants of concern",
      "type": "categorical"
    },
```

## Microreact
-----

If you would like to visualize the above sequences in [Microreact](https://microreact.org/showcase) follow these instructions. First, you will need the metadata file created above (metadata.sampled.tsv) and three files from Nextstrain (lat_longs.tsv, aligned.fasta, tree_raw.nwk). Copy the ncov/defaults/lat_longs.tsv file to your working directory and change its name to lat_longs.e1.tsv. Open this file with a text editor and at the bottom of it, add the following:

```
region	Africa	4.070194	21.824559
region	Asia	30.451098	86.654576
region	Europe	49.646237	10.799454
region	North America	28.2367447	-97.738017
region	Oceania	-25.0562891	152.008576
region	South America	-13.083583	-58.470721
```

Now, you have to localize were is the aligned.fasta file in your computer. The aligned.fasta file is the result of running Nextstrain on a given set of sequences. It contains tha alignment of the sequences that will be displyed in auspice. For instance, in the example above, the file in my computer is in: ncov/results/global-mex/aligned.fasta. You can copy this file to your working directory. Once you localized this file, run the following script:

```
$ perl create_microreact.pl lat_longs.e1.tsv aligned.fasta metadata.sampled.tsv Mexico
$ mv outfile.tsv metadata.sampled.mr.tsv 
$ mv outfile_subset.tsv metadata.sampled.mrMexico.tsv
```

The above script will create three files: outfile.tsv, outfile_subset.tsv. The first file contains the table required by Microreact with all the sequences found in metadata.sampled.tsv. The second file contains the table required by Microreact only with the sequences from the country of selection (in this case Mexico). 

Now you can go to [Microreact](https://microreact.org/showcase) and upload the metadata.sampled.mr.tsv and the tree_raw.nwk to visualize your data (Figure 6). You can find the tree_raw.nwk in /ncov/results/global-mex/. The tree_raw.nwk file contains a phylogeny of all the sequences in aligned.fasta.

Note: single quotes "'" in the name of the sequences are transformed to underscores _ in the names of the sequences in the tree. For instance, the sequence name in metadata: Lu'an/5073Y is transformed to Lu_an/5073Y in tree_raw.nwk. If you have sequence names with single quotes, simply open the outfile.tsv with a text editor and remplace the single quote by an underscore. In the example above, just open the outfile.tsv file with a text editor and rename the sequence Lu'an/5073Y to Lu_an/5073Y. Otherwise Microreact will not work.

<p align="center">
  <img width="707.5" height="371.5" src="https://github.com/luisdelaye/CurSa/blob/main/Figure-6-CurSa.png">
</p>
Figure 6. Microreact visualization of sequences.



If you would like to visualize in [Microreact](https://microreact.org/showcase) only those sequences from the selected country (Mexico) altogether with a phylogenetic tree, follow the next instructions. You will need to run the script:

```
$ perl exstract_secs.pl metadata.sampled.mrMexico.tsv aligned.fasta
$ mv outfile metadata.sampled.mrMexico.fasta
```

This will create a file named outfile that contains the sequences whose ids are found in outfile_subset.tsv. This is, all the sequences from Mexico originaly found in metadata.sampled.tsv. Rename this file to metadata.sampled.mrMexico.fasta. Then run [iqtree](http://www.iqtree.org) to infer a phylogenetic tree:

```
$ iqtree -s metadata.sampled.mrMexico.fasta -m GTR+I+G
```

Now add the extension nwk to the phylogeny file and upload the phylogeny and the metadata.sampled.mrMexico.tsv files to [Microreact](https://microreact.org/showcase).

### Display all sequences from a country in Microreact

You may want to display all sequences from a country in Microreact. For this, you will need the metadata.e2.tsv file and the following script:

```
$ perl create_microreact_all.pl lat_longs.e1.tsv metadata.e2.tsv Mexico
$ mv outfile_all.tsv metadata.mrMexico.tsv
```

The above script will create the file outfile_all.tsv. Simply upload this (metadata.mrMexico.tsv) file to [Microreact](https://microreact.org/showcase). Because the number of genomes is usually very high, it is not practical to do a phylogenetic analysis.


