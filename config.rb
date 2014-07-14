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

activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'leighmcculloch.com'
  s3_sync.region                     = 'us-east-1'
  s3_sync.delete                     = true
  s3_sync.after_build                = true
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
  s3_sync.version_bucket             = false
end

activate :cdn do |cdn|
  cdn.cloudflare = {
    zone: 'leighmcculloch.com',
    base_urls: [ 'http://leighmcculloch.com' ]
  }
  cdn.filter = /\.html$/
  cdn.after_build = true
end
