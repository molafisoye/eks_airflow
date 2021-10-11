data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "17.20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.21"
  subnets         = module.vpc.private_subnets

  vpc_id = module.vpc.vpc_id

  worker_groups = [
    {
      name                 = "on-demand-1"
      instance_type        = "t2.micro"
      asg_max_size         = 2
      asg_desired_capacity = 1
      kubelet_extra_args   = "--node-labels=spot=false"
      suspended_processes  = ["AZRebalance"]
    }
  ]

  worker_groups_launch_template = [
    {
      name                    = "spot-1"
      override_instance_types = ["t2.small", "m5.large", "m5a.large", "m5d.large", "m5ad.large"]
      spot_instance_pools     = 2
      asg_max_size            = 2
      asg_desired_capacity    = 1
      kubelet_extra_args      = "--node-labels=node.kubernetes.io/lifecycle=spot"
      public_ip               = true
    },
  ]

  write_kubeconfig = true
}
