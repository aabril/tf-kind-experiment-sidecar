for i in $(docker ps -q); do docker stop $i; done
for i in $(docker ps -q); do docker rm $i; done

