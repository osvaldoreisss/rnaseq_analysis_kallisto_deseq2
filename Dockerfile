FROM snakemake/snakemake:v7.8.5

LABEL maintainer="osvaldoreisss@gmail.com"

WORKDIR /pipeline
COPY . .
RUN mamba env update --file requirements.yaml --name snakemake
RUN snakemake --use-conda --conda-create-envs-only --cores 3