compass_config do |config|
  config.output_style = :compact
end

configure :development do
  activate :livereload
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :directory_indexes

configure :build do
  activate :minify_html
  activate :minify_css
  activate :minify_javascript
  activate :gzip
  activate :asset_hash, :ignore => [/^images\//]
  activate :relative_assets

  # Requires installing image_optim extensions.
  # Ref: https://github.com/toy/image_optim
  # 1) `brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush`
  # 2) Download pngout from http://www.jonof.id.au/kenutils
  # 3) `cp pngout /usr/local/bin/pngout`
  activate :imageoptim
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :git
end
