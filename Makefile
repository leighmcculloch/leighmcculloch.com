dev:
	hugo -s source server

clean:
	rm -fr source/public

build: clean
	hugo -s source

deploy: build
	wrangler pages deploy --project-name leighmcculloch ./source/public
