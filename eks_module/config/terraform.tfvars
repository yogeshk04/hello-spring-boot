
aws_eks_cluster_config = {

  "demo-cluster" = {

    eks_cluster_name = "demo-cluster1"
    eks_subnet_ids   = ["subnet-02e0add379898fc06", "subnet-0909682c02e76e63a"]
    tags = {
      "Name" = "demo-cluster"
    }
  }
}

eks_node_group_config = {

  "node1" = {

    eks_cluster_name = "demo-cluster"
    node_group_name  = "mynode"
    nodes_iam_role   = "eks-node-group-general1"
    node_subnet_ids  = ["subnet-02e0add379898fc06", "subnet-0909682c02e76e63a"]

    tags = {
      "Name" = "node1"
    }
  }
}
