# Methods

## Genalice reference file
Genalice Map requires a reference index for read aligment. To this end, we first made a Genalice Reference File (GRF) from fasta sequences. This GRF is a binary reference sequences, which is essential to the Genalice Aligned Reads (GAR) file format. We annotated the GRF into primary assembly and alternative contigs using a so called `alt file`. Next, we made an comprehensive Genalice Index File (GRI) using GRF as input.

We used a [shell script](scripts/reference.sh) to automate GRF and GRI construction for the two human reference assemblies. The command line tool to create a GRF is called `gaReference` and it requires an input fasta and output GRF file. The `alt file` is added through the `alt_file` option. The `gaIndex` tool creates a comprehensive reference index for read alignment. It requires an input GRF and output GRI file.


## Genalice Map
Genalice Map aligns short sequence reads to the reference index (GRI) with a patented high performance mapping algorithm (REF). First, the GRI is loaded into memory (RAM) and subsequently raw sequence reads of a single sample are matched to the index in memory.  After all sequence reads have been processed the alignment result is written to disk in the GAR file format. This mapping procedure repeats itself for every sample of the ICR96 dataset, while the GRI remains in memory. 

The read alignment tool is set up for optimal results using the configuration files described in the [Materials](Materials.md) section. The exact commands and configurations used in this study can be found [here](scripts/map.sh). The `gaServer` tool loads the GRI into memory as a `named server`. The `gaMap` tool is the client that sends alignemnt jobs to the `named server` instance. Each alignment job consists of the following components:

* `input` defines raw sequence reads in FASTQ format as a list in JSON format. Each sample has its own [JSON input file](json) describing the location of (multiple) first and second in pair FASTQ files.
* `output` defines the output GAR file.
* `cmd_file` defines the [configuration file](configs/human.map.conf) consisting of alignment parameters.
* `alt_score_bias=0.9` defines a mapping bias in favor of the primary sequence relative to the alternative contigs. An `alt_score_bias` larger than 1 indicates a bias in favor of the alternative contigs, while a score of 1 indicates no bias. The bias results in a preferable mapping location when a read is equally likely to align to a primary sequence or alternative contig.
* `capture_bed_file` defines the captured regions of a targeted NGS assay in BED format. These regions are used to accurately calculate coverage depth over the captured regions, which is essential for copy number detection. 

## Genalice CNV
In this study, Genalice CNV detects copy number changes in a target sample relative to a control group.  The tool divides the genome into consecutive buckets and copy numbers are assessed for each bucket. Here, we used buckets with a length of 100 bases, which is the maximum resolution of the tool. The tool can assign a normal, loss (deletion) or gain (duplication) state to each bucket. Adjacent buckets with identical states are concatenated into larger events. Buckets without sufficient coverage in the control group are filtered out (drop) and no call is made. 

### Control group
The control group is summarized in a Genalice Coverage (GCO) file, containing average coverage depths and standard deviations for every bucket. The average values are used to calculate the CNV ratio and, together with the standard deviation, z scores to assess statistical significance. In order to include samples with varying coverage depths, each sample is first normalized to an arbitrary coverage depth. In this study, the arbitrary depth is set at 75x. 


A GCO file requires GAR files from the control samples as input. In this study, the control samples differ per target sample. First, control and target samples all come from the same library enrichment pool. The ICR96 Exon CNV Validation series is somewhat unusual in its composition, because it has a relatively high number of specific CNVs in a small number of samples. Such composition is highly unlikely in clinical testing (Fowler et al 2016). Furthermore, it may skew averages and standard deviations in the GCO file.  Therefore, we attempted to select MLPA-normal controls for every sample with an MLPA-positive CNV. In addition, we excluded the target sample from the control group. A full list of control group samples can be found [here](lists).

The [control-group.sh](scripts/control-group.sh) script automates the production of control groups. It uses the `gaStructure __create__` command to make a GCO file (`gco_file`) out of a list of GAR files (`gco_list`).

### CNV calling
Genalice CNV requires a target sample (GAR format) and control group (GCO format) to call copy number alterations in the target relative to the control group. It first calculates coverage ratios for the target sample and control groups for every bucket, separately. Coverage ratios are the bucket coverage divided by the sample/control group average coverage. This normalization procedure allows direct comparison of target and control group. Next, the tool calculates a CNV ratio for every bucket by dividing the target coverage ratio over the control group ratio. The tool calls duplications when the CNV ratio was equal to or higher than 1.25. Likewise, it calls deletions whenever the CNV ratio was equal to or less than 0.75. Any buckets with CNV ratios in between those thresholds are considered to have normal copy numbers. Moreover, the tool calculates a z score for every bucket, which can be used to filter out deletion or duplication calls that deviate to little from the control group. Here, buckets with z scores between -4.7 and 4.7 are considered to have normal copy numbers. 

The exact commands and configurations used in this study can be found in the [cnv.sh](scripts/cnv.sh) script.


## Gene plots
...

## Single base resolution analysis
...
