from rich import print
from rich.panel import Panel
from glob import glob
import os
import sys
import shutil

if not os.path.isdir("data"):
    print(Panel("data directory does not exist, [red]creating. Rerun once you have placed the appropriate data files into the data directory."))
    shutil.copytree(os.getenv("out") + "/data", "./data")
    sys.exit(1)

"""
Script to convert assembly.fasta into assembly.tabular
"""
import csv
with open("./data/assembly/assembly.fasta", "r") as f:
    lines = f.readlines()
with open("./data/assembly/assembly.tabular", "w") as f:
    for gene, rna in zip(lines[::2], lines[1::2]):
        f.write(f"{gene[1::].strip()}\t{gene[1::].strip()}\t{rna}")
