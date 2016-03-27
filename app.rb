require 'sinatra'
require 'mini_magick'
require_relative 'lib/owl_api'

get '/pixel-owl' do
  owl_api = Thread[:owl_api] ||= OwlAPI.new
  img = MiniMagick::Image.read(owl_api.get_raw_owl)
  content_type(img.mime_type)
  img.scale("10%").scale("1000%").to_blob
end
