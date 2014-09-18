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
end

activate :webp do |webp|
  webp.conversion_options = {
    "images/*.jpg" => {lossy: true},
  }
  webp.ignore = /^((?!\.jpg$).)*$/i
end

# Requires installing image_optim extensions.
# Ref: https://github.com/toy/image_optim
# 1) `brew install advancecomp gifsicle jhead jpegoptim jpeg optipng pngcrush`
# 2) Download pngout from http://www.jonof.id.au/kenutils
# 3) `cp pngout /usr/local/bin/pngout`
# Also, must be placed outside :build to ensure it occurs prior to other
# extensions below that are also triggered after build.
activate :imageoptim

# Sync with AWS S3
activate :s3_sync do |s3_sync|
  s3_sync.bucket                     = 'leighmcculloch.com'
  s3_sync.region                     = 'us-east-1'
  s3_sync.delete                     = false
  s3_sync.after_build                = true
  s3_sync.prefer_gzip                = true
  s3_sync.path_style                 = true
  s3_sync.reduced_redundancy_storage = false
  s3_sync.acl                        = 'public-read'
  s3_sync.encryption                 = false
  s3_sync.version_bucket             = false
end

# Sync with Rackspace
activate :sync do |sync|
  sync.fog_provider = 'Rackspace'
  sync.fog_directory = 'leighmcculloch.com'
  sync.fog_region = 'DFW'
  sync.rackspace_username = ENV['RACKSPACE_USERNAME']
  sync.rackspace_api_key = ENV['RACKSPACE_API_KEY']
  sync.existing_remote_files = 'delete'
  sync.gzip_compression = true
  sync.after_build = true
end

# Sync with MaxCDN Push Zone
activate :deploy do |deploy|
  deploy.method   = :sftp
  deploy.host     = "ftp.#{ENV['MAXCDN_PUSH_USERNAME']}.#{ENV['MAXCDN_ALIAS']}.netdna-cdn.com"
  deploy.port     = 22
  deploy.path     = "/public_html"
  deploy.user     = "#{ENV['MAXCDN_PUSH_USERNAME']}.#{ENV['MAXCDN_ALIAS']}"
  deploy.password = ENV['MAXCDN_PUSH_PASSWORD']
end

activate :cdn do |cdn|
  # leighmcculloch.com
  cdn.cloudflare = {
    zone: 'leighmcculloch.com',
    base_urls: ['http://leighmcculloch.com']
  }

  # cloudfront.leighmcculloch.com
  cdn.cloudfront = {
    distribution_id: 'EK0GC71RZUHDM'
  }

  # fastly.leighmcculloch.com
  cdn.fastly = {
    base_urls: ['http://fastly.leighmcculloch.com']
  }

  # maxcdn.leighmcculloch.com
  cdn.maxcdn = {
    zone_id: '172766'
  }

  # rackspace.leighmcculloch.com
  cdn.rackspace = {
    region: 'DFW',
    container: 'leighmcculloch.com'
  }

  cdn.filter = /\.html$/
  cdn.after_build = true
end
