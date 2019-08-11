docker build -t wtf3 .
docker run -v $PWD/releases:/usr/src/app/releases wtf3 mix release --env=prod
