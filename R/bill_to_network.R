#' Convert Bill Data to Network Graph
#'
#' @description
#' This function converts a dataframe containing legislators' bill proposals and cosignatory information
#' into network analysis objects, which can be used to analyze collaboration relationships among legislators.
#'
#' @param df A dataframe that must contain at least one of 'billProposer' or 'billCosignatory' columns
#' @param top_n Integer, selects the top N legislators by importance for analysis, default is 20
#' @param use_all Logical, if TRUE uses all legislators rather than just top_n, default is FALSE
#' @param verbose Logical, whether to output detailed information, default is TRUE
#'
#' @return Returns a list containing the following components:
#'   \item{nodes}{Dataframe of selected legislator nodes}
#'   \item{links}{Connections between selected legislators (D3 format)}
#'   \item{named_links}{Connections between selected legislators (named format)}
#'   \item{cooc_matrix}{Complete co-occurrence matrix}
#'   \item{full_graph}{Complete network graph (igraph object)}
#'   \item{igraph}{Network graph of selected legislators (igraph object)}
#'   \item{all_nodes}{Complete node data for all legislators}
#'
#' @details
#' The function first extracts the list of legislators from the proposer and cosignatory fields,
#' then calculates the co-participation relationships between them.
#' The importance of each legislator is calculated based on degree centrality, betweenness centrality,
#' and eigenvector centrality. The function can optionally return a network graph of all legislators
#' or only those with high importance rankings.
#'
#' If verbose=TRUE is specified, the function will output network statistics and community detection results.
#'
#' @examples
#' \dontrun{
#' # Assuming df is a dataframe containing billProposer and billCosignatory columns
#' network_data <- bill_to_network(df)
#'
#' # Use all legislators rather than just top 20
#' network_data_all <- bill_to_network(df, use_all = TRUE)
#'
#' # Select only the top 10 important legislators
#' network_data_10 <- bill_to_network(df, top_n = 10)
#' }
#'
#' @author davidycliao
#'
#' @importFrom igraph graph_from_adjacency_matrix degree betweenness eigen_centrality induced_subgraph as_edgelist vcount ecount edge_density cluster_louvain V "V<-" E membership
#'
#' @export


bill_to_network <- function(df, top_n = 20, use_all = FALSE, verbose = TRUE) {
  # check the data frame
  has_proposer <- "billProposer" %in% colnames(df)
  has_cosignatory <- "billCosignatory" %in% colnames(df)

  if (!has_proposer && !has_cosignatory) {
    stop("The data frame must contain at least one of the 'billProposer' or 'billCosignatory' columns")
  }

  # define the message display function
  show_msg <- function(msg) {
    if (verbose) {
      cat(msg)
    }
  }

  # extract all legislator names
  all_legislators <- c()

  # extract from the proposer column
  if (has_proposer) {
    for (i in 1:nrow(df)) {
      if (!is.na(df$billProposer[i]) && df$billProposer[i] != "") {
        proposers <- unlist(strsplit(as.character(df$billProposer[i]), ";|\uff1b|,|\uff0c| ; | \uff0c "))
        proposers <- trimws(proposers)
        all_legislators <- c(all_legislators, proposers)
      }
    }
  }

  # extract from the cosignatory column
  if (has_cosignatory) {
    for (i in 1:nrow(df)) {
      if (!is.na(df$billCosignatory[i]) && df$billCosignatory[i] != "") {
        cosigners <- unlist(strsplit(as.character(df$billCosignatory[i]), ";|\uff1b|,|\uff0c| ; | \uff0c "))
        cosigners <- trimws(cosigners)
        all_legislators <- c(all_legislators, cosigners)
      }
    }
  }

  unique_legislators <- unique(all_legislators[all_legislators != ""])
  n_legislators <- length(unique_legislators)

  show_msg(sprintf("Found the following legislators (%d total):\n", n_legislators))

  # create the node data frame
  nodes_df <- data.frame(
    id = 0:(n_legislators - 1),
    name = unique_legislators,
    stringsAsFactors = FALSE
  )

  # create the bill-legislator matrix
  bill_matrix <- matrix(0, nrow = nrow(df), ncol = n_legislators)
  colnames(bill_matrix) <- unique_legislators

  # fill the bill-legislator matrix
  for (i in 1:nrow(df)) {
    all_participants <- c()

    # add proposers
    if (has_proposer && !is.na(df$billProposer[i]) && df$billProposer[i] != "") {
      proposers <- unlist(strsplit(as.character(df$billProposer[i]), ";|\uff1b|,|\uff0c| ; | \uff0c "))
      proposers <- trimws(proposers)
      all_participants <- c(all_participants, proposers)
    }

    # add cosigners
    if (has_cosignatory && !is.na(df$billCosignatory[i]) && df$billCosignatory[i] != "") {
      cosigners <- unlist(strsplit(as.character(df$billCosignatory[i]), ";|\uff1b|,|\uff0c| ; | \uff0c "))
      cosigners <- trimws(cosigners)
      all_participants <- c(all_participants, cosigners)
    }

    # remove empty values
    all_participants <- all_participants[all_participants != ""]

    # mark participants in the matrix
    for (participant in all_participants) {
      if (participant %in% unique_legislators) {
        bill_matrix[i, participant] <- 1
      }
    }
  }

  # calculate the co-occurrence matrix
  cooc_matrix <- matrix(0, nrow = n_legislators, ncol = n_legislators)
  rownames(cooc_matrix) <- unique_legislators
  colnames(cooc_matrix) <- unique_legislators

  # iterate over every pair of legislators, counting co-participation
  show_msg("Computing co-participation relationships among legislators...\n")
  for (i in 1:(n_legislators-1)) {
    leg_i <- unique_legislators[i]

    for (j in (i+1):n_legislators) {
      leg_j <- unique_legislators[j]

      # count the number of bills co-participated in
      cooc_count <- sum(bill_matrix[, leg_i] & bill_matrix[, leg_j])

      if (cooc_count > 0) {
        cooc_matrix[leg_i, leg_j] <- cooc_count
        cooc_matrix[leg_j, leg_i] <- cooc_count  # symmetric matrix
      }
    }
  }

  # compute each legislator's connection count and participation degree
  connections <- rowSums(cooc_matrix > 0)  # number of connected legislators
  total_cooc <- rowSums(cooc_matrix)       # total co-signing count
  nodes_df$connections <- connections
  nodes_df$total_cooc <- total_cooc

  # create the full igraph object (using the adjacency matrix is safer)
  full_graph <- graph_from_adjacency_matrix(cooc_matrix,
                                            mode = "undirected",
                                            weighted = TRUE)

  # compute centrality measures
  show_msg("Computing centrality measures...\n")
  degree_cent <- degree(full_graph, normalized = TRUE)
  betweenness_cent <- betweenness(full_graph, normalized = TRUE)
  eigenvector_cent <- eigen_centrality(full_graph)$vector

  # add centrality measures to the node data frame
  nodes_df$degree_cent <- degree_cent[match(nodes_df$name, names(degree_cent))]
  nodes_df$betweenness_cent <- betweenness_cent[match(nodes_df$name, names(betweenness_cent))]
  nodes_df$eigenvector_cent <- eigenvector_cent[match(nodes_df$name, names(eigenvector_cent))]

  # compute the composite importance score (weights can be adjusted)
  nodes_df$importance <- nodes_df$degree_cent * 0.4 +
    nodes_df$betweenness_cent * 0.3 +
    nodes_df$eigenvector_cent * 0.3

  # decide which graph and node data to use
  if (use_all) {
    # use the complete graph of all legislators
    selected_graph <- full_graph
    selected_nodes <- nodes_df
    show_msg("Using all legislators for analysis...\n")
  } else {
    # select the top N legislators
    show_msg(sprintf("Selecting the top %d most important legislators...\n", top_n))
    top_legislators <- nodes_df[order(nodes_df$importance, decreasing = TRUE), ][1:min(top_n, nrow(nodes_df)), ]

    # create a subgraph - select the subset directly from the full graph
    top_names <- top_legislators$name
    selected_graph <- induced_subgraph(full_graph, which(V(full_graph)$name %in% top_names))
    selected_nodes <- top_legislators
  }

  # add node attributes to the selected graph
  V(selected_graph)$connections <- connections[match(V(selected_graph)$name, unique_legislators)]
  V(selected_graph)$total_cooc <- total_cooc[match(V(selected_graph)$name, unique_legislators)]
  V(selected_graph)$degree_cent <- degree_cent[match(V(selected_graph)$name, names(degree_cent))]
  V(selected_graph)$betweenness_cent <- betweenness_cent[match(V(selected_graph)$name, names(betweenness_cent))]
  V(selected_graph)$eigenvector_cent <- eigenvector_cent[match(V(selected_graph)$name, names(eigenvector_cent))]
  V(selected_graph)$importance <- nodes_df$importance[match(V(selected_graph)$name, nodes_df$name)]

  # get the connections among the selected legislators
  selected_edges <- as_edgelist(selected_graph)
  selected_weights <- E(selected_graph)$weight

  if (length(selected_weights) > 0) {
    selected_edges_df <- data.frame(
      from = selected_edges[,1],
      to = selected_edges[,2],
      weight = selected_weights,
      stringsAsFactors = FALSE
    )
  } else {
    selected_edges_df <- data.frame(
      from = character(0),
      to = character(0),
      weight = numeric(0),
      stringsAsFactors = FALSE
    )
  }

  # convert to NetworkD3-format links
  if (nrow(selected_edges_df) > 0) {
    d3_links <- data.frame(
      source = match(selected_edges_df$from, selected_nodes$name) - 1,
      target = match(selected_edges_df$to, selected_nodes$name) - 1,
      value = selected_edges_df$weight,
      stringsAsFactors = FALSE
    )
  } else {
    d3_links <- data.frame(
      source = integer(0),
      target = integer(0),
      value = numeric(0),
      stringsAsFactors = FALSE
    )
  }

  # return the result
  result <- list(
    nodes = selected_nodes,           # selected legislator nodes
    links = d3_links,                 # connections among selected legislators (D3 format)
    named_links = selected_edges_df,  # connections among selected legislators (named format)
    cooc_matrix = cooc_matrix,        # full co-occurrence matrix
    full_graph = full_graph,          # full network graph
    igraph = selected_graph,          # selected legislators' network graph
    all_nodes = nodes_df              # complete node data for all legislators
  )

  # print basic network statistics
  if (verbose) {
    cat("\nBasic network statistics:\n")
    cat("Total number of legislators:", nrow(nodes_df), "\n")

    if (use_all) {
      cat("Using all legislators, total", vcount(selected_graph), "\n")
    } else {
      cat("Selected top", top_n, "legislator count:", vcount(selected_graph), "\n")
    }

    cat("Number of connections:", ecount(selected_graph), "\n")

    if (ecount(selected_graph) > 0) {
      cat("Network density:", edge_density(selected_graph), "\n")

      # show legislator ranking (if in top-N mode)
      if (!use_all) {
        cat("\nTop", top_n, "important legislators ranking:\n")
        for (i in 1:nrow(selected_nodes)) {
          leg <- selected_nodes[i, ]
          cat(i, ". ", leg$name,
              " (degree centrality: ", round(leg$degree_cent, 4),
              ", betweenness centrality: ", round(leg$betweenness_cent, 4),
              ", connections: ", leg$connections, ")\n", sep="")
        }
      }

      # community detection
      if (vcount(selected_graph) > 2 && ecount(selected_graph) > 0) {
        communities <- cluster_louvain(selected_graph)
        cat("\nCommunity detection results:\n")
        cat("Number of communities:", length(unique(membership(communities))), "\n")

        # list the members of each community (may need to limit output size)
        comm_ids <- unique(membership(communities))
        for (i in comm_ids) {
          members <- V(selected_graph)$name[membership(communities) == i]
          if (length(members) > 10) {
            cat("Community", i, ":", paste(members[1:10], collapse = ", "), "... (", length(members), "total)\n")
          } else {
            cat("Community", i, ":", paste(members, collapse = ", "), "\n")
          }
        }
      }
    }
  }

  return(result)
}
