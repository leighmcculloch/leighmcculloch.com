dev:
	cd source && hugo server --baseURL=https://$(NGROK).ngrok.io --appendPort=false

ngrok:
	ngrok http 1313

clean:
	rm -fr source/public

build:
	cd source && hugo

deploy: clean build push

push:
	firebase login --no-localhost
	firebase deploy

setup:
	curl -o /tmp/hugo.deb -sSL https://github.com/gohugoio/hugo/releases/download/v0.45.1/hugo_0.45.1_Linux-64bit.deb
	apt install -f /tmp/hugo.deb
	rm /tmp/hugo.deb
