# app/controllers/claude_controller.rb
class ClaudeController < ApplicationController
  def chat
    service = ClaudeService.new
    @response = service.chat(params[:question])

    respond_to do |format|
      format.html  # Handles standard HTML requests

      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          'response',
          partial: 'claude/show',
          locals: { response: @response.parsed_response["content"][0]["text"]}
        )
      end
    end
  end
def upload
    service = ClaudeService.new
    result = service.upload_file(params[:file])
    
    respond_to do |format|
      format.html  # Handles standard HTML requests

      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          'response',
          partial: 'claude/show',
          locals: { response: @response}
        )
      end
    end
  end


end
