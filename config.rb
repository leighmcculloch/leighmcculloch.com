compass_config do |config|
  config.output_style = :compact
end

set :css_dir, 'stylesheets'

set :js_dir, 'javascripts'

set :images_dir, 'images'

activate :directory_indexes

configure :build do
  activate :minify_html
  activate :minify_css
  activate :minify_javascript
  activate :asset_hash, :ignore => [/\.(jpg|png)$/]
  activate :relative_assets
end
