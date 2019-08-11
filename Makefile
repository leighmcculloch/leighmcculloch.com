dev:
	hugo -s source server --bind 0.0.0.0 --port 8000

deploy: build push

clean:
	rm -fr source/public

build: clean
	hugo -s source

push:
	firebase login --no-localhost
	firebase deploy
