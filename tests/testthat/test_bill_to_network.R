sample_bills <- data.frame(
  billProposer = c("王小明", "王小明;李小華", "李小華;張小美", "張小美", "王小明;張小美"),
  billCosignatory = c("李小華", "張小美", "王小明", "", "李小華"),
  stringsAsFactors = FALSE
)

test_that("bill_to_network errors when required columns are missing", {
  bad_df <- data.frame(billTitle = c("a", "b"), stringsAsFactors = FALSE)
  expect_error(bill_to_network(bad_df),
               "The data frame must contain at least one of the 'billProposer' or 'billCosignatory' columns")
})

test_that("bill_to_network returns the expected structure", {
  result <- bill_to_network(sample_bills, verbose = FALSE)

  expect_type(result, "list")
  expect_named(result, c("nodes", "links", "named_links", "cooc_matrix",
                          "full_graph", "igraph", "all_nodes"))

  expect_s3_class(result$nodes, "data.frame")
  expect_s3_class(result$all_nodes, "data.frame")
  expect_true(all(c("name", "connections", "total_cooc",
                     "degree_cent", "betweenness_cent",
                     "eigenvector_cent", "importance") %in% colnames(result$all_nodes)))

  expect_true(is.matrix(result$cooc_matrix))
  expect_equal(nrow(result$cooc_matrix), ncol(result$cooc_matrix))

  expect_s3_class(result$full_graph, "igraph")
  expect_s3_class(result$igraph, "igraph")
})

test_that("bill_to_network respects top_n", {
  result <- bill_to_network(sample_bills, top_n = 2, verbose = FALSE)
  expect_lte(nrow(result$nodes), 2)
  expect_equal(nrow(result$all_nodes), 3)
})

test_that("bill_to_network use_all returns every legislator", {
  result <- bill_to_network(sample_bills, use_all = TRUE, verbose = FALSE)
  expect_equal(nrow(result$nodes), nrow(result$all_nodes))
  expect_equal(igraph::vcount(result$igraph), nrow(result$all_nodes))
})
