#' Create a Cost-Effectiveness Tree Object
#'
#' @param yaml_tree YAML file or location address
#'
#' @return data.tree object of class costeffectiveness.tree
#' @export
#'
#' @examples create.costeffectiveness.tree(yaml_tree="raw data/LTBI_dtree-cost-distns.yaml")
#'
create.costeffectiveness.tree <- function(yaml_tree){

  stopifnot(is.character(yaml_tree))

  if (grep(pattern = ".yaml$", x = yaml_tree))
    osList <- yaml::yaml.load_file(yaml_tree)
  else{
    osList <- yaml.load(yaml_tree)}

  osNode <- data.tree::as.Node(osList)

  stopifnot(all(osNode$Get("distn")%in%c("unif","gamma","triangle")))
  stopifnot(all(osNode$Get("type", filterFun = isLeaf)=="terminal"))

  class(osNode) <- c(class(osNode),"costeffectiveness.tree")

  osNode
}