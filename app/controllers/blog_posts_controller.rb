require 'net/http'
require 'uri'
require 'json'

class BlogPostsController < ApplicationController
  def index
    @blogPost = BlogPost.all
    
    uri = URI.parse("https://api.openai.com/v1/chat/completions")

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(uri.request_uri)
    request["Authorization"] = "Bearer #{ENV['OPENAI_API_KEY']}"
    request["Content-Type"] = "application/json"

    request.body = {
      model: "gpt-4",
      messages: [
        { role: "user", content: "Cześć, co u Ciebie?" }
      ]
    }.to_json

    response = http.request(request)

    puts JSON.pretty_generate(JSON.parse(response.body))

  end
end
