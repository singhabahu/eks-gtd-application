#!/bin/sh

source ~/credentials 
rm credentials

# Create kube-config
aws eks update-kubeconfig --region ${eks_region} --name ${eks_cluster_name}
chmod 600 ~/.kube/config

# Add the eks-charts repository
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Install aws-load-balancer-controller
helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${eks_cluster_name} \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=602401143452.dkr.ecr.${eks_region}.amazonaws.com/amazon/aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${load_balancer_controller_role_arn}
