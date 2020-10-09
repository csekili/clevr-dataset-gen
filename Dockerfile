FROM eparker05/blender:2.78c

WORKDIR /usr/src/app

COPY . .

RUN apt-get update && \
	echo $PWD/image_generation >> /usr/local/blender/2.78/python/lib/python3.5/site-packages/clevr.pth && \
	apt-get install -y python3 && \
    	apt-get install -y python3-pip


