require 'httparty'
require 'base64'

class OpenaiChatService
  include HTTParty
  base_uri "https://api.openai.com/v1"

  def initialize(question, uploaded_file)
    @question = question
    @uploaded_file = uploaded_file
  end

  def call
    messages = []

    if @uploaded_file.present?
      mime_type = @uploaded_file.content_type
      image_data = Base64.strict_encode64(@uploaded_file.read)

      messages << {
        role: "user",
        content: [
          {
            type: "text",
            text: @question
          },
          {
            type: "image_url",
            image_url: {
              url: "data:#{mime_type};base64,#{image_data}"
            }
          }
        ]
      }
    else
      messages << {
        role: "user",
        content: @question
      }
    end

    response = self.class.post(
      "/chat/completions",
      headers: {
        "Authorization" => "Bearer #{ENV['OPENAI_API_KEY']}",
        "Content-Type" => "application/json"
      },
      body: {
        model: "gpt-4o-mini",
        messages: messages,
        max_tokens: 1000
      }.to_json
    )

    if response.success?
      response.parsed_response["choices"][0]["message"]["content"]
    else
      "Błąd: #{response.code} - #{response.parsed_response["error"]["message"] rescue 'Nieznany błąd'}"
    end
  end
end
