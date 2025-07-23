# app/services/claude_file_uploader.rb
require 'faraday'
require 'faraday/multipart'

class ClaudeFileUploader
  API_URL = 'https://api.anthropic.com/v1/files'.freeze

  def initialize(api_key: ENV.fetch('ANTHROPIC_API_KEY'))
    @conn = Faraday.new(url: API_URL) do |f|
      f.request :multipart              # <-- middleware multipart
      f.request :url_encoded            # <–– potrzebne, by Faraday nie domyślnie wszystko url‑encode’ował
      f.adapter Faraday.default_adapter
    end
    @api_key = api_key
  end

  def upload(file_param, metadata: {})
    payload = { 
      file: Faraday::Multipart::FilePart.new(
        file_param.path, 
        file_param.content_type, 
        file_param.original_filename
      )
    }
    payload.merge!(metadata.transform_keys(&:to_s))

    response = @conn.post do |req|
      req.headers['Authorization'] = "Bearer #{@api_key}"
      req.body = payload
    end
    # puts response.inspect
    # raise "Upload failed (#{response.status}): #{response.body}" unless response.success?
    return @api_key
  end
end
