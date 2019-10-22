set -e
docker build -t davhunt/neuropythy .
docker tag davhunt/neuropythy davhunt/neuropythy:1.4
docker push davhunt/neuropythy
