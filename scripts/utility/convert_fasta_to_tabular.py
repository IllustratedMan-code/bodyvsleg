import csv
with open("data/assembly/assembly.fasta", "r") as f:
    lines = f.readlines()
with open("data/assembly/assembly.tabular", "w") as f:
    for gene, rna in zip(lines[::2], lines[1::2]):
        f.write(f"{gene.strip()}\t{gene.strip()}\t{rna}")
