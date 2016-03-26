require 'net/http'
require 'yaml'
require 'tumblr_client'

class OwlAPI
  attr_reader :client
  BLOGS = [
    'daily-owls.tumblr.com',
    'owlsonmymind.tumblr.com',
    'cloudyowl.tumblr.com',
    'featheroftheowl.tumblr.com',
    'owl-daily.tumblr.com'
  ].freeze

  def initialize(config: YAML.load(File.read('tumblr.yml')))
    @client = Tumblr::Client.new(config)
  end

  def get_raw_owl
    uri = URI(photos.pop)
    Net::HTTP.get(uri)
  end

  private
  def photos
    # If we're out of photos, fetch more
    if !@photos&.any?
      @photos = client.posts(blog, type: "photo")['posts'].flat_map do |post|
        post['photos'].flat_map do |photo|
          photo.dig('original_size', 'url')
        end
      end.shuffle
    end
  end

  def blog
    BLOGS.sample
  end
end
