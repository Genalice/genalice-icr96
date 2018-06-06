# Materials

## NGS data
The ICR96 Exon CNV Validation series can be accessed through the European-Genome phenome Archive (EGA) under the accession number [EGAS00001002428](https://www.ebi.ac.uk/ega/studies/EGAS00001002428). Details of how to access the data is available at EGA or from the [ICR website](https://www.icr.ac.uk/icr96).

## Reference sequences
We aligned reads and called CNVs against two assemblies of the human reference genome, including:

* GRCh37: ftp://ftp.ncbi.nlm.nih.gov/genomes/H_sapiens/GRCh37.p13_interim_annotation/

* GRCh38: ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/000/001/405/GCA_000001405.15_GRCh38/

Both reference sequences contain two types of contigs, namely: primary chromosomes and alternate loci. Genalice Map is an _alternate-loci_ aware read alignment tool. Discrimination between primary chromosomes and alternate loci can be achieved through [`alt files`](references/). The `alt files` are included as annotation, while making a [Genalice Reference File](Methods.md).

## Genalice version
Throughout this study we used Genalice version 2.x.x.

## Configuration files
Genalice tools are fully configurable to obtain the best possible data results. As a consequence, each tool has a series of options to allow customized settings. Adding multiple options to the command line can be cumbersome. Therefore, multiple option settings can be added as a single configuration file through the `cmd_file` option.

Each option is described as: `option_name=[value]` in a configuration file. Comments can be added by using the `#` character.

The configuration file(s) used in this study can be found [here](configs/).

## Open source tools
In addition to Genalice solutions, we used the following open source tools:

* [bedtools v2.20.1](http://bedtools.readthedocs.io/en/latest/content/bedtools-suite.html)

* [R version 3.3.2](https://www.r-project.org/)

## Hardware configuration
Throughout this study we used a server with the following hardware configurations: a dual Intel Xeon E5 2620 V2 (2100-2600
Mhz) CPU with a total of 12 cores and 24 threads, 128GB RAM (8x16GB, 1333 Mhz), InfiniBand adapter of 40
Gigabit/second to stream data from storage disks to compute nodes. The data is stored on Raid 50 disks with
1GB/second IO speed (read/write). Operating system is SuSE Linux Enterprise Server 12 on standard server board.
