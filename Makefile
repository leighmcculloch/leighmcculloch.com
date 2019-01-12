dev:
	hugo -s source server --baseURL=https://$(NGROK).ngrok.io --appendPort=false

ngrok:
	ngrok http 1313

deploy: build push

clean:
	rm -fr source/public

build: clean
	hugo -s source

push:
	firebase login --no-localhost
	firebase deploy
