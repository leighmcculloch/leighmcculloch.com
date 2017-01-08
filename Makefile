export CLOUDFLARE_ZONE = c4d2f285d1dd72ac0083f9fe16dc0925

run:
	while true ; do nc -l 4567 < source/index.txt ; done

deploy: push-gcs cdn

push-gcs:
	gsutil -m cp -a public-read -r source/* gs://leighmcculloch.com
	gsutil web set -m index.txt -e 404.txt gs://leighmcculloch.com

cdn:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" \
		-H "X-Auth-Key: $(CLOUDFLARE_CLIENT_API_KEY)" \
		-H "Content-Type: application/json" \
		--data '{"purge_everything":true}'
