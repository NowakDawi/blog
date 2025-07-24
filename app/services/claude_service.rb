# app/services/claude_service.rb
require 'httmultiparty'
require 'base64'
require 'mime/types'


class ClaudeService
  include HTTParty
  base_uri 'https://api.anthropic.com/v1'

  def initialize
    @headers = {
      "x-api-key" => ENV["ANTHROPIC_API_KEY"],
      "anthropic-version" => "2023-06-01",
      "anthropic-beta" => "files-api-2025-04-14" # wymagane dla API plików
    }
  end

  def chat(message)
    body = {
      model: "claude-opus-4-20250514",
      max_tokens: 1024,
      messages: [
        { role: "user", content: [
          { type: "text",     text: message },
        ],
      }
      ],
      service_tier: "auto"
    }

    self.class.post('/messages', headers: @headers, body: body.to_json)
  end

  def chat_with_document(message, file_id)
    body = {
      model: "claude-opus-4-20250514",
      max_tokens: 1024,
      messages: [
        { role: "user", content: [
          { type: "text",     text: message },
          { type: "document", source: { type: "file", file_id: file_id } }
        ],
      }
      ],
      service_tier: "auto"
    }

    self.class.post('/messages', headers: @headers, body: body.to_json)
  end

  def upload_file(file)
    options = {
      headers: @headers,
      body: {
        file: file
      }
    }

    response = self.class.post('/files', options)
    JSON.parse(response.body)
  end

  def chat_with_image(image_path, question)
    base64_image = Base64.strict_encode64(File.binread(image_path))
    mime_type = MIME::Types.type_for(image_path).first.to_s

    body = {
    model: "claude-sonnet-4-20250514",
    max_tokens: 1024,
    messages: [
      {
        role: "user",
        content: [
          {
            type: "image",
            source: {
              type: "base64",
              media_type: mime_type,
              data: base64_image
            }
          },
          {
            type: "text",
            text: question
          }
        ]
      }
      ]
    }

    self.class.post('/messages', headers: @headers, body: body.to_json)
  end
end
