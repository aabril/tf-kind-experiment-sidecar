NOW=$(date +"%Y%m%d-%H%M%S")

echo [ Create folder ] : mkdir -p ./archive/$NOW
mkdir -p ./archive/$NOW

files=(".terraform" ".terraform.lock.hcl" "new-cluster-config" "terraform.tfstate" "terraform.tfstate.backup")

for i in "${files[@]}"
do
  if test -f ./"$i"; then
      echo "[ Move file ] : mv ./$i ./archive/$NOW/$i" ;
      mv ./$i ./archive/$NOW/$i ;
  else 
      echo "[ Not existent  ] : $i"
  fi
done

