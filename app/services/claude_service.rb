# app/services/claude_service.rb
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
        { role: "user", content: message }
      ],
      service_tier: "auto"
    }

    self.class.post('/messages', headers: @headers, body: body.to_json)
  end

    def upload_file(file)
    # file to ActionDispatch::Http::UploadedFile z Rails (params[:file])
    response = self.class.post(
      '/files',
      headers: @headers,
      body: {
        file: file.tempfile,         # fizyczny plik
        filename: file.original_filename
      },
      multipart: true
    )
    response.parsed_response
  end
end
