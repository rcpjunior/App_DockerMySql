echo "Acessar no DockerHub"

docker login

echo "Criando as imagens..."
docker build -t rcjunior/projeto-backend:1.0 backend/.
docker build -t rcjunior/projeto-database:1.0 database/.

echo "Realizando push das imagens..."

docker push rcjunior/projeto-backend:1.0
docker push rcjunior/projeto-database:1.0

echo "Criando serviços no cluster kubernets..."

kubectl apply -f ./services.yml --insecure-skip-tls-verify=true 

echo "Criando os deployments..."

kubectl apply -f ./deployment.yml --insecure-skip-tls-verify=true 