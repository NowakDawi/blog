# app/services/claude_file_uploader.rb
require 'faraday'
require 'faraday/multipart'
require 'json'

class ClaudeFileUploader
  API_URL = 'https://api.anthropic.com/v1/files'.freeze
   API_VERSION   = '2023-06-01'.freeze
 BETA_HEADER   = 'files-api-2025-04-14'.freeze

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
      file: Faraday::UploadIO.new(
       file_param.path,
        file_param.content_type,
        file_param.original_filename
      )
    }.merge(metadata.transform_keys(&:to_s))

    response = @conn.post do |req|
      req.headers['x-api-key']        = @api_key
      req.headers['anthropic-version']= API_VERSION
      req.headers['anthropic-beta']   = BETA_HEADER
      req.body = payload
    end


        unless response.success?
   raise "Upload failed (#{response.status}): #{response.body}"
    end

        JSON.parse(response.body)

  end
end
