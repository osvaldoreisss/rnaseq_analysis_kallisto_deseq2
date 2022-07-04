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
