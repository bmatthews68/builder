build:
	docker buildx build \
		--platform linux/arm64 \
		-t bmatthews68/builder:1.0.0 \
		-t bmatthews68/builder:latest \
		--push \
		.