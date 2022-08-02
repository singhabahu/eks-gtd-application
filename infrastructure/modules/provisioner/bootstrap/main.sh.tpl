#!/bin/sh

source ~/credentials 
rm credentials

# Create kube-config
aws eks update-kubeconfig --region ${eks_region} --name ${eks_cluster_name}
chmod 600 ~/.kube/config

# Add the eks-charts repository
helm repo add eks https://aws.github.io/eks-charts
helm repo update

# Install metrics-server
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Install aws-load-balancer-controller
helm upgrade -i aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=${eks_cluster_name} \
  --set serviceAccount.create=true \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=602401143452.dkr.ecr.${eks_region}.amazonaws.com/amazon/aws-load-balancer-controller \
  --set serviceAccount.annotations."eks\.amazonaws\.com/role-arn"=${load_balancer_controller_role_arn}

# Wait for aws-load-balancer-controller to be ready
kubectl -n kube-system wait pod --for=condition=Ready -l app.kubernetes.io/name=aws-load-balancer-controller

# Install application
helm upgrade -i --create-namespace demo application/ -n servian \
  --set ingress.annotations."alb\.ingress\.kubernetes\.io/certificate-arn"=${certificate_arn} \
  --set configmap.db_name=${db_name} \
  --set configmap.db_port=${db_port} \
  --set configmap.db_host=${db_host} \
  --set secrets.db_username=${db_username} \
  --set secrets.db_password=${db_password}

# Wait for application pods to be ready
kubectl -n servian wait pod --for=condition=Ready -l app.kubernetes.io/name=tech-challenge-app

# Seed database
kubectl exec -it $(kubectl get pods -o name --no-headers=true -n servian | head -n 1) -n servian -- sh -c "./TechChallengeApp updatedb -s"

# Fetch the URL from ingress hostname
echo "Waiting for the ingress to be created (30s)"
sleep 30
url=$(kubectl get ing -n servian -o jsonpath={..hostname})

echo "Note that it can take some time to provision the ALB (~3mins) so below URL might not be available right away"
echo "Please visit to access the application: https://$url"