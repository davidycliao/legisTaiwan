# Convert Bill Data to Network Graph

This function converts a dataframe containing legislators' bill
proposals and cosignatory information into network analysis objects,
which can be used to analyze collaboration relationships among
legislators.

## Usage

``` r
bill_to_network(df, top_n = 20, use_all = FALSE, verbose = TRUE)
```

## Arguments

- df:

  A dataframe that must contain at least one of 'billProposer' or
  'billCosignatory' columns

- top_n:

  Integer, selects the top N legislators by importance for analysis,
  default is 20

- use_all:

  Logical, if TRUE uses all legislators rather than just top_n, default
  is FALSE

- verbose:

  Logical, whether to output detailed information, default is TRUE

## Value

Returns a list containing the following components:

- nodes:

  Dataframe of selected legislator nodes

- links:

  Connections between selected legislators (D3 format)

- named_links:

  Connections between selected legislators (named format)

- cooc_matrix:

  Complete co-occurrence matrix

- full_graph:

  Complete network graph (igraph object)

- igraph:

  Network graph of selected legislators (igraph object)

- all_nodes:

  Complete node data for all legislators

## Details

The function first extracts the list of legislators from the proposer
and cosignatory fields, then calculates the co-participation
relationships between them. The importance of each legislator is
calculated based on degree centrality, betweenness centrality, and
eigenvector centrality. The function can optionally return a network
graph of all legislators or only those with high importance rankings.

If verbose=TRUE is specified, the function will output network
statistics and community detection results.

## Author

davidycliao

## Examples

``` r
if (FALSE) { # \dontrun{
# Assuming df is a dataframe containing billProposer and billCosignatory columns
network_data <- bill_to_network(df)

# Use all legislators rather than just top 20
network_data_all <- bill_to_network(df, use_all = TRUE)

# Select only the top 10 important legislators
network_data_10 <- bill_to_network(df, top_n = 10)
} # }
```
