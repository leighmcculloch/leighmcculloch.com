HUGO?=go run -tags extended github.com/gohugoio/hugo@v0.115.2

dev:
	$(HUGO) -s source server --port 9000 &
	wrangler pages dev --proxy 9000
	killall hugo

clean:
	rm -fr source/public

build: clean
	$(HUGO) -s source

deploy: build
	wrangler pages deploy --project-name leighmcculloch ./source/public
