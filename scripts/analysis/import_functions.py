import pandas as pd
from itertools import combinations
def convert_to_WGCNA(meta_name):
    # quant files
    meta = pd.read_csv(f"data/metadata/{meta_name}.csv")
    data = pd.DataFrame()
    for i in meta.name:
        data[i] = pd.read_table(f"data/quant/{meta_name}/{i}")["TPM"]
    truth = pd.DataFrame()

    truth["sample"] = meta["name"]
    # truth table
    for col in meta.columns[1::]:
        comparisons = meta[col].unique()
        for comparison in comparisons:
            truth[col +"_"+ str(comparison)] = meta[col].apply(lambda x: int(x == col))
    extracomparisions = combinations(truth.columns[1::], 2)
    for comparison in extracomparisions:
        truth[comparison[0] + "__" + comparison[1]] = truth[[comparison[0], comparison[1]]].apply(lambda x: x[comparison[0]] or x[comparison[1]], axis=1)

    return truth
return convert_to_WGCNA("main")
