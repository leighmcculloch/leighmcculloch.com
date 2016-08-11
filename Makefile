export CLOUDFLARE_ZONE = c4d2f285d1dd72ac0083f9fe16dc0925

run:
	bundle exec middleman

deploy: clean build push-gcs

clean:
	rm -fR build

build:
	bundle exec middleman build

push-gcs:
	gsutil -m cp -a public-read -r build/* gs://leighmcculloch.com
	gsutil web set -m index.html -e 404.html gs://leighmcculloch.com

cdn:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" \
		-H "X-Auth-Key: $(CLOUDFLARE_CLIENT_API_KEY)" \
		-H "Content-Type: application/json" \
		--data '{"purge_everything":true}'
