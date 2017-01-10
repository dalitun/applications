IMAGE_VERSION = 2.7.1
IMAGE = pavelgopanenko/rundeck:$(IMAGE_VERSION)

.PHONY: all

all:
	$(MAKE) image
	$(MAKE) push

image:
	docker build -t $(IMAGE) --rm --force-rm ./

push:
	docker push $(IMAGE)
