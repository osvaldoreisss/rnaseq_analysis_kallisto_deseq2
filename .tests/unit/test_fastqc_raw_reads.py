import os
import sys

import subprocess as sp
from tempfile import TemporaryDirectory
import shutil
from pathlib import Path, PurePosixPath

sys.path.insert(0, os.path.dirname(__file__))

import common


def test_fastqc_raw_reads():

    with TemporaryDirectory() as tmpdir:
        #workdir = Path(tmpdir) / "workdir"
        workdir = ".tests"
        data_path = PurePosixPath(".tests/data")
        expected_path = PurePosixPath(".tests/unit/fastqc_raw_reads/expected")

        config_path = PurePosixPath(".tests/config")

        # Copy data to the temporary workdir.
        #shutil.copytree(data_path, workdir)
        #shutil.copytree(config_path, workdir / "config")

        # Run the test job.
        sp.check_output([
            "python",
            "-m",
            "snakemake",
            "--use-conda",
            "--snakefile",
            "workflow/Snakefile",
            "results/qc/fastqc/raw/MAQCA_1-lane1.R1_fastqc.html",
            "results/qc/fastqc/raw/MAQCA_1-lane1.R1_fastqc.zip",
            "-f", 
            "-j1",
            "--keep-target-files",
            "--directory",
            workdir,
        ])

        # Check the output byte by byte using cmp.
        # To modify this behavior, you can inherit from common.OutputChecker in here
        # and overwrite the method `compare_files(generated_file, expected_file), 
        # also see common.py.
        common.OutputChecker(data_path, expected_path, workdir).check()
