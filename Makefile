export CLOUDFLARE_ZONE = c4d2f285d1dd72ac0083f9fe16dc0925

run:
	go run serve.go

clean:
	rm -fr build

build:
	mkdir -p build
	cp -R source/* build/
	go run markdown.go source/go-experience-reports/pointers.md build/go-experience-reports/pointers.html

deploy: clean build push-gcs cdn

push-gcs:
	gsutil -m cp -a public-read -r build/* gs://leighmcculloch.com
	gsutil web set -m index.html -e 404.txt gs://leighmcculloch.com

cdn:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" \
		-H "X-Auth-Key: $(CLOUDFLARE_CLIENT_API_KEY)" \
		-H "Content-Type: application/json" \
		--data '{"purge_everything":true}'

setup:
	go get github.com/russross/blackfriday
