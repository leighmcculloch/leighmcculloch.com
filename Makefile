dev:
	cd source && hugo server --baseURL=https://$(NGROK).ngrok.io --appendPort=false

ngrok:
	ngrok http 1313

export CLOUDFLARE_ZONE = c4d2f285d1dd72ac0083f9fe16dc0925

clean:
	rm -fr source/public

build:
	cd source && hugo

deploy: clean build push

push:
	firebase login --no-localhost
	firebase deploy

cdn:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" \
		-H "X-Auth-Key: $(CLOUDFLARE_CLIENT_API_KEY)" \
		-H "Content-Type: application/json" \
		--data '{"purge_everything":true}'

setup:
	curl -o /tmp/hugo.deb -sSL https://github.com/gohugoio/hugo/releases/download/v0.45.1/hugo_0.45.1_Linux-64bit.deb
	apt install -f /tmp/hugo.deb
	rm /tmp/hugo.deb
