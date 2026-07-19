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
#' @importFrom igraph graph_from_adjacency_matrix degree betweenness eigen_centrality induced_subgraph get.edgelist vcount ecount edge_density cluster_louvain V "V<-" E membership
#'
#' @export


bill_to_network <- function(df, top_n = 20, use_all = FALSE, verbose = TRUE) {
  # 檢查資料框架
  has_proposer <- "billProposer" %in% colnames(df)
  has_cosignatory <- "billCosignatory" %in% colnames(df)

  if (!has_proposer && !has_cosignatory) {
    stop("資料框架必須至少包含 'billProposer' 或 'billCosignatory' 欄位")
  }

  # 定義訊息顯示函數
  show_msg <- function(msg) {
    if (verbose) {
      cat(msg)
    }
  }

  # 提取所有立委名稱
  all_legislators <- c()

  # 從提案人欄位提取
  if (has_proposer) {
    for (i in 1:nrow(df)) {
      if (!is.na(df$billProposer[i]) && df$billProposer[i] != "") {
        proposers <- unlist(strsplit(as.character(df$billProposer[i]), ";|；|,|，| ; | ， "))
        proposers <- trimws(proposers)
        all_legislators <- c(all_legislators, proposers)
      }
    }
  }

  # 從連署人欄位提取
  if (has_cosignatory) {
    for (i in 1:nrow(df)) {
      if (!is.na(df$billCosignatory[i]) && df$billCosignatory[i] != "") {
        cosigners <- unlist(strsplit(as.character(df$billCosignatory[i]), ";|；|,|，| ; | ， "))
        cosigners <- trimws(cosigners)
        all_legislators <- c(all_legislators, cosigners)
      }
    }
  }

  unique_legislators <- unique(all_legislators[all_legislators != ""])
  n_legislators <- length(unique_legislators)

  show_msg(sprintf("找到以下立委(共 %d 位):\n", n_legislators))

  # 創建節點資料框
  nodes_df <- data.frame(
    id = 0:(n_legislators - 1),
    name = unique_legislators,
    stringsAsFactors = FALSE
  )

  # 創建法案-立委矩陣
  bill_matrix <- matrix(0, nrow = nrow(df), ncol = n_legislators)
  colnames(bill_matrix) <- unique_legislators

  # 填充法案-立委矩陣
  for (i in 1:nrow(df)) {
    all_participants <- c()

    # 添加提案人
    if (has_proposer && !is.na(df$billProposer[i]) && df$billProposer[i] != "") {
      proposers <- unlist(strsplit(as.character(df$billProposer[i]), ";|；|,|，| ; | ， "))
      proposers <- trimws(proposers)
      all_participants <- c(all_participants, proposers)
    }

    # 添加連署人
    if (has_cosignatory && !is.na(df$billCosignatory[i]) && df$billCosignatory[i] != "") {
      cosigners <- unlist(strsplit(as.character(df$billCosignatory[i]), ";|；|,|，| ; | ， "))
      cosigners <- trimws(cosigners)
      all_participants <- c(all_participants, cosigners)
    }

    # 去除空值
    all_participants <- all_participants[all_participants != ""]

    # 在矩陣中標記參與者
    for (participant in all_participants) {
      if (participant %in% unique_legislators) {
        bill_matrix[i, participant] <- 1
      }
    }
  }

  # 計算共同參與矩陣
  cooc_matrix <- matrix(0, nrow = n_legislators, ncol = n_legislators)
  rownames(cooc_matrix) <- unique_legislators
  colnames(cooc_matrix) <- unique_legislators

  # 遍歷每對立委，計算共同參與次數
  show_msg("計算立委間的共同參與關係...\n")
  for (i in 1:(n_legislators-1)) {
    leg_i <- unique_legislators[i]

    for (j in (i+1):n_legislators) {
      leg_j <- unique_legislators[j]

      # 計算共同參與的法案數量
      cooc_count <- sum(bill_matrix[, leg_i] & bill_matrix[, leg_j])

      if (cooc_count > 0) {
        cooc_matrix[leg_i, leg_j] <- cooc_count
        cooc_matrix[leg_j, leg_i] <- cooc_count  # 對稱矩陣
      }
    }
  }

  # 計算每位立委的連結數和參與度
  connections <- rowSums(cooc_matrix > 0)  # 連結立委數
  total_cooc <- rowSums(cooc_matrix)       # 總連署次數
  nodes_df$connections <- connections
  nodes_df$total_cooc <- total_cooc

  # 創建完整的igraph物件 (使用鄰接矩陣更安全)
  full_graph <- graph_from_adjacency_matrix(cooc_matrix,
                                            mode = "undirected",
                                            weighted = TRUE)

  # 計算中心性度量
  show_msg("計算中心性度量...\n")
  degree_cent <- degree(full_graph, normalized = TRUE)
  betweenness_cent <- betweenness(full_graph, normalized = TRUE)
  eigenvector_cent <- eigen_centrality(full_graph)$vector

  # 添加中心性度量到節點資料框
  nodes_df$degree_cent <- degree_cent[match(nodes_df$name, names(degree_cent))]
  nodes_df$betweenness_cent <- betweenness_cent[match(nodes_df$name, names(betweenness_cent))]
  nodes_df$eigenvector_cent <- eigenvector_cent[match(nodes_df$name, names(eigenvector_cent))]

  # 計算綜合指標 (可調整權重)
  nodes_df$importance <- nodes_df$degree_cent * 0.4 +
    nodes_df$betweenness_cent * 0.3 +
    nodes_df$eigenvector_cent * 0.3

  # 決定要使用哪個圖形和節點資料
  if (use_all) {
    # 使用所有立委的完整圖形
    selected_graph <- full_graph
    selected_nodes <- nodes_df
    show_msg("使用所有立委進行分析...\n")
  } else {
    # 選擇Top N的立委
    show_msg(sprintf("選擇前 %d 名重要立委...\n", top_n))
    top_legislators <- nodes_df[order(nodes_df$importance, decreasing = TRUE), ][1:min(top_n, nrow(nodes_df)), ]

    # 創建子圖 - 直接從完整圖形中選取子集
    top_names <- top_legislators$name
    selected_graph <- induced_subgraph(full_graph, which(V(full_graph)$name %in% top_names))
    selected_nodes <- top_legislators
  }

  # 添加節點屬性到選定的圖形
  V(selected_graph)$connections <- connections[match(V(selected_graph)$name, unique_legislators)]
  V(selected_graph)$total_cooc <- total_cooc[match(V(selected_graph)$name, unique_legislators)]
  V(selected_graph)$degree_cent <- degree_cent[match(V(selected_graph)$name, names(degree_cent))]
  V(selected_graph)$betweenness_cent <- betweenness_cent[match(V(selected_graph)$name, names(betweenness_cent))]
  V(selected_graph)$eigenvector_cent <- eigenvector_cent[match(V(selected_graph)$name, names(eigenvector_cent))]
  V(selected_graph)$importance <- nodes_df$importance[match(V(selected_graph)$name, nodes_df$name)]

  # 獲取選定立委間的連結
  selected_edges <- get.edgelist(selected_graph)
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

  # 轉換為NetworkD3格式的連結
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

  # 返回結果
  result <- list(
    nodes = selected_nodes,           # 選定立委節點
    links = d3_links,                 # 選定立委間的連結 (D3格式)
    named_links = selected_edges_df,  # 選定立委間的連結 (命名格式)
    cooc_matrix = cooc_matrix,        # 完整共現矩陣
    full_graph = full_graph,          # 完整網絡圖
    igraph = selected_graph,          # 選定立委網絡圖
    all_nodes = nodes_df              # 所有立委的完整節點資料
  )

  # 打印基本網絡統計
  if (verbose) {
    cat("\n基本網絡統計：\n")
    cat("全部立委數量：", nrow(nodes_df), "\n")

    if (use_all) {
      cat("使用所有立委，共", vcount(selected_graph), "位\n")
    } else {
      cat("所選Top", top_n, "立委數量：", vcount(selected_graph), "\n")
    }

    cat("連結數量：", ecount(selected_graph), "\n")

    if (ecount(selected_graph) > 0) {
      cat("網絡密度：", edge_density(selected_graph), "\n")

      # 顯示立委排名（如果是Top N模式）
      if (!use_all) {
        cat("\nTop", top_n, "重要立委排名：\n")
        for (i in 1:nrow(selected_nodes)) {
          leg <- selected_nodes[i, ]
          cat(i, ". ", leg$name,
              " (度中心性: ", round(leg$degree_cent, 4),
              ", 中介中心性: ", round(leg$betweenness_cent, 4),
              ", 連結數: ", leg$connections, ")\n", sep="")
        }
      }

      # 社群檢測
      if (vcount(selected_graph) > 2 && ecount(selected_graph) > 0) {
        communities <- cluster_louvain(selected_graph)
        cat("\n社群檢測結果：\n")
        cat("社群數量：", length(unique(membership(communities))), "\n")

        # 列出每個社群的成員 (可能需要限制輸出數量)
        comm_ids <- unique(membership(communities))
        for (i in comm_ids) {
          members <- V(selected_graph)$name[membership(communities) == i]
          if (length(members) > 10) {
            cat("社群", i, "：", paste(members[1:10], collapse = ", "), "... (共", length(members), "人)\n")
          } else {
            cat("社群", i, "：", paste(members, collapse = ", "), "\n")
          }
        }
      }
    }
  }

  return(result)
}
