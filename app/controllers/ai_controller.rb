# app/controllers/ai_controller.rb
class AiController < ApplicationController
  def chat
    service = ClaudeService.new
    response = service.chat(params[:question])

    respond_to do |format|
      format.html  # przy zwykłym żądaniu
      format.turbo_stream.prepend(
        'response',
        partial: 'chat/show',
        locals: {response: @response}
      )          # do obsługi Turbo (jeśli masz widok `create.turbo_stream.erb`)
    end
  end
end
