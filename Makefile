dev: .bin/hugo
	.bin/hugo -s source server --baseURL=https://$(NGROK).ngrok.io --appendPort=false

ngrok:
	ngrok http 1313

deploy: build push

clean:
	rm -fr source/public

build: clean .bin/hugo
	.bin/hugo -s source

push: .bin/node_modules/.bin/firebase
	[ ! -t 0 ] || .bin/node_modules/.bin/firebase login --no-localhost
	.bin/node_modules/.bin/firebase deploy

.bin:
	mkdir .bin

.bin/hugo: .bin
	curl -sSL https://github.com/gohugoio/hugo/releases/download/v0.53/hugo_0.53_Linux-64bit.tar.gz | tar xvz -C .bin/ -- hugo && chmod +x .bin/hugo

.bin/node_modules/.bin/firebase: .bin
	yarn --no-lockfile --modules-folder=.bin/node_modules add firebase-tools
