terraform init
# terraform plan 
terraform apply -auto-approve

echo "[Cluster Info]"
kubectl cluster-info
echo " "


echo "[docker ps --all]"
docker ps --all
echo " "

