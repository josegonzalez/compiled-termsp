ARCHITECTURES := arm arm64

TERMSP_VERSION := 5116aeda84b8d4bb125a214464c131c177260140

clean:
	rm -f bin/*/termsp || true
build: $(foreach arch,$(ARCHITECTURES),bin/$(arch)/termsp)

bin/arm/termsp:
	mkdir -p bin/arm
	docker buildx build --platform linux/arm/v7 --load -f arm/Dockerfile --build-arg TERMSP_VERSION=$(TERMSP_VERSION) --progress plain -t app/termsp:$(TERMSP_VERSION)-arm arm
	docker container create --name extract app/termsp:$(TERMSP_VERSION)-arm
	docker container cp extract:/go/src/github.com/Nevrdid/TermSP/build/TermSP bin/arm/termsp
	docker container rm extract
	chmod +x bin/arm/termsp

bin/arm64/termsp:
	mkdir -p bin/arm64
	docker buildx build --platform linux/arm64 --load -f arm64/Dockerfile --build-arg TERMSP_VERSION=$(TERMSP_VERSION) --progress plain -t app/termsp:$(TERMSP_VERSION)-arm64 arm64
	docker container create --name extract app/termsp:$(TERMSP_VERSION)-arm64
	docker container cp extract:/go/src/github.com/Nevrdid/TermSP/build/TermSP bin/arm64/termsp
	docker container rm extract
	chmod +x bin/arm64/termsp
