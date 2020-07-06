# Dockerfiles for the interview process from David leal at Team International

## Requirements to set up this infrastucture

__the following binaries should be working in your running machine__

1. aws cli v2
2. Docker
3. terrfarom

## Configure aws cli
`$> aws configure`

will ask you for some info which will be store in ~/.aws/
```
Build this image:
  docker build \
  --build-arg gitproject=break-the-monolith       \
  --build-arg branch=master                       \
  --build-arg deployenv=local                     \
  -t btm-solo-image -f Dockerfile.flask-ecs .
```

## create the docker image

## create your ecr with terraform

## push your images to the new ecr

__Login with your docker client your aws container repository__

`$> aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 068213000772.dkr.ecr.us-east-2.amazonaws.com`

you will see a message like this one:
```
WARNING! Your password will be stored unencrypted in /home/david/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded068213000772.dkr.ecr.us-east-2.amazonaws.com/debian
```

__tag yor image with the tag that you want to ecr__

get your image id from `docker images`

`$> docker tag DOCKER_IMG_ID 068213000772.dkr.ecr.us-east-2.amazonaws.com/your-ecr-repository:debian-buster`

__push your image to ecr__
`$> docker push 068213000772.dkr.ecr.us-east-2.amazonaws.com/your-ecr-repository:debian-buster`
