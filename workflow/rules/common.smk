from snakemake.utils import validate
import pandas as pd

##### load config and sample sheets #####


configfile: "config/config.yaml"


validate(config, schema="../schemas/config.schema.yaml")

samples_file = config["samples"]
samples = pd.read_csv(samples_file, sep="\t").set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

units = pd.read_csv(config["units"], sep="\t").set_index(
    ["sample_name", "unit_name"], drop=False
)
validate(units, schema="../schemas/units.schema.yaml")

sample_unit = tuple(zip(units["sample_name"].to_list(), units["unit_name"].to_list()))

groups = ["R1", "R2"]
if units["fq2"].isnull().any():
    groups = ["R1"]

threads = config["threads"]


def get_fastqc_input(wildcards):
    try:
        fastqs = units.loc[wildcards["sample"], wildcards["unit"]].dropna()
    except KeyError:
        raise ValueError(
            "Sample {} or unit {} not found in units file".format(
                wildcards["sample"], wildcards["unit"]
            )
        )
    if wildcards["group"] == "R1":
        return fastqs.fq1
    elif wildcards["group"] == "R2":
        return fastqs.fq2
    else:
        raise ValueError("group must be either 'R1' or 'R2'")
