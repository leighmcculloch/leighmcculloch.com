dev:
	hugo -s source server --bind 0.0.0.0 --port 9000

clean:
	rm -fr source/public

build: clean
	hugo -s source

deploy: build
	fly deploy --strategy bluegreen
