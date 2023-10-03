aws iam get-role --profile am-devops1 --role-name eks-admin

aws sts assume-role --role-arn arn:aws:iam::819401076850:role/eks-admin --role-session-name manager-session --profile manager 
# eks-terraform-pro

# show configmap 
kubectl edit -n kube-system configmap/aws-auth

# change the user

aws eks --region us-east-1 update-kubeconfig --name my-eks
# show config
kubectl config view --minify 

# test
kubectl auth can-i get pods 
kubectl auth can-i create pods

# create quick pods
kubectl run nginx --image nginx

## patch svc type (for argocd // i could change it directely in terraform)//
kubectl patch svc argo-cd-argocd-argocd-server -n argocd --type='json' -p '[{"op":"replace","path":"/spec/type","value":"ClusterIP"}]'

## get password argocdc 

kubectl get secrets n argocd
kub get secrets -n argocd ------ -o yaml 

## port forawrd svc
kubectl -n monitoring port-forward service/prometheus-k8s 9090:9090