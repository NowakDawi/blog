# app/services/claude_service.rb
require 'anthropic'

class ClaudeService
  def initialize
    @client = Anthropic::Client.new(api_key: ENV.fetch("ANTHROPIC_API_KEY"))
  end

  # file_content: String – zawartość pliku (tekst, JSON itp.)
  def analyze_content(file_content)
    @client.completions.create(
      model: "claude-2",               # lub inny dostępny model
      prompt: file_content,            # treść do analizy
      max_tokens_to_sample: 1000,
      temperature: 0.0
    ).completion
  end
end
