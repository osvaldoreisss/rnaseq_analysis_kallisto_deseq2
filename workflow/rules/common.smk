from snakemake.utils import validate
import pandas as pd

##### load config and sample sheets #####

configfile: "config/config.yaml"

validate(config, schema="../schemas/config.schema.yaml")

samples_file = config["samples"]
samples = pd.read_csv(samples_file, sep="\t").set_index("sample", drop=False)
validate(samples, schema="../schemas/samples.schema.yaml")

units = pd.read_csv(config["units"], sep="\t").set_index(['sample_name', 'unit_name'], drop=False)
validate(units, schema="../schemas/units.schema.yaml")
