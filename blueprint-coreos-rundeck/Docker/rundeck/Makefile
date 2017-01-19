IMAGE = dalidorepo/rundeck

.PHONY: all

all:
	$(MAKE) image
	$(MAKE) push

image:
	docker build -t $(IMAGE) --rm --force-rm ./

push:
	docker push $(IMAGE)
