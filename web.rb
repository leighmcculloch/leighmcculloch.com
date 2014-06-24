Bundler.require :default

class Web < Sinatra::Application
  set :root, File.dirname(__FILE__)
  set :public_folder, "#{File.dirname(__FILE__)}/leighmcculloch.com"

  register Sinatra::AssetPack

  assets {
    serve "/js",     from: "leighmcculloch.com/js"
    serve "/css",    from: "leighmcculloch.com/css"
    serve "/images", from: "leighmcculloch.com/images"

    js :web, "/js/all.min.js", [
      "/js/**/*.js"
    ]

    css :web, "/css/all.min.css", [
      "/css/**/*.css"
    ]

    js_compression  :jsmin
    css_compression :simple

    prebuild true
  }
  
  get "/" do
    redirect "/index.html"
  end
  
  run! if app_file == $0
end
