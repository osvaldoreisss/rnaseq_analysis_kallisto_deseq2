rule fastqc_raw_reads:
    input:
        get_fastqc_input,
    output:
        html="results/qc/fastqc/raw/{sample}-{unit}.{group}_fastqc.html",
        zip="results/qc/fastqc/raw/{sample}-{unit}.{group}_fastqc.zip",  # the suffix _fastqc.zip is necessary for multiqc to find the file. If not using multiqc, you are free to choose an arbitrary filename
    params:
        "--quiet",
    log:
        "logs/fastqc/raw/{sample}-{unit}.{group}.log",
    threads: threads
    wrapper:
        "v1.7.0/bio/fastqc"


rule cutadapt:
    input:
        get_input_cutadapt_se,
    output:
        fastq="results/trimmed/{sample}-{unit}.{group}.fastq",
        qc="results/trimmed/{sample}-{unit}.{group}.qc.txt",
    params:
        adapters="-a AGATCGGAAGAGCACACGTCTGAACTCCAGTCAC",
        extra="-q 20",
    log:
        "logs/cutadapt/{sample}-{unit}.{group}.log",
    threads: 4  # set desired number of threads here
    wrapper:
        "v1.7.0/bio/cutadapt/se"
