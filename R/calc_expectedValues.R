#' Calculate Expected Values for Each Node of Decision Tree
#'
#' Takes an object of class costeffectiveness.tree.
#'
#' @param osNode
#'
#' @return osNode
#' @export
#'
#' @seealso create.costeffectiveness.tree, payoff
#'
#' @examples
#' ## read-in decision tree
#' osNode <- create.costeffectiveness.tree(yaml_tree = "raw data/LTBI_dtree-cost-distns.yaml")
#' print(osNode, "type", "p", "distn", "mean", "sd")
#'
#' ## calculate a single realisation expected values
#' osNode <- calc.expectedValues(osNode)
#' print(osNode, "type", "p", "distn", "mean", "sd", "payoff")
#'
#' ## calculate multiple realisation for specific nodes
#' MonteCarlo.expectedValues(osNode, n=100)
#'
calc.expectedValues <- function(osNode){

  stopifnot("costeffectiveness.tree" %in% class(osNode))

  rpayoff <- osNode$Get(sampleNode)
  osNode$Set(payoff = rpayoff)

  osNode$Do(payoff, traversal = "post-order")#, filterFun = isNotLeaf)

  osNode
}


#' Monte Carlo Forward Simulation of Decision Tree
#'
#' Results are returned for the nodes labelled logical in decision tree.
#' Require at least one logical node.
#'
#' @param osNode A data.tree object with class costeffectiveness.tree
#' @param n Number of simulations
#'
#' @return list containing array of n sets of expected values and sampled nodes full names
#' @export
#' @seealso calc.expectedValues
#'
#' @examples
#' ## read-in decision tree
#' osNode <- create.costeffectiveness.tree(yaml_tree = "raw data/LTBI_dtree-cost-distns.yaml")
#' print(osNode, "type", "p", "distn", "mean", "sd")
#'
#' ## calculate a single realisation expected values
#' osNode <- calc.expectedValues(osNode)
#' print(osNode, "type", "p", "distn", "mean", "sd", "payoff")
#'
#' ## calculate multiple realisation for specific nodes
#' MonteCarlo.expectedValues(osNode, n=100)
#'
MonteCarlo.expectedValues <- function(osNode, n=100){

  stopifnot("costeffectiveness.tree" %in% class(osNode))

  if(!any(osNode$Get("type") == "logical"))
    stop("Error: Need at least one node labeled 'logical'")

  NodeNames <- osNode$Get("pathString", filterFun = function(x) x$type=="logical")
  names(NodeNames) <- NULL

  out <-  matrix(data=NA, nrow=n, ncol=length(NodeNames))
  for (i in 1:n){

    osNode <- calc.expectedValues(osNode)
    res <- osNode$Get("payoff", filterFun = function(x) x$type=="logical")
    out[i,] <- res
  }

  list("expected values" = out,
       "node names" = NodeNames)
}
