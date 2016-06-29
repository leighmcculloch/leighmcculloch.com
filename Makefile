export CLOUDFLARE_ZONE = c4d2f285d1dd72ac0083f9fe16dc0925

run:
	bundle exec middleman

clean:
	rm -fR build

build:
	bundle exec middleman build

deploy: clean build
	git branch -D gh-pages 2>/dev/null | true
	git branch -D gh-pages-draft 2>/dev/null | true
	git checkout -b gh-pages-draft && \
		git add -f build && \
		git commit -m "Deploy to gh-pages" && \
		git subtree split --prefix build -b gh-pages && \
		git push --force origin gh-pages:gh-pages && \
		git checkout -

cdn:
	curl -X DELETE "https://api.cloudflare.com/client/v4/zones/$(CLOUDFLARE_ZONE)/purge_cache" \
		-H "X-Auth-Email: $(CLOUDFLARE_EMAIL)" \
		-H "X-Auth-Key: $(CLOUDFLARE_CLIENT_API_KEY)" \
		-H "Content-Type: application/json" \
		--data '{"purge_everything":true}'
