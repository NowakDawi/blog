class ChatController < ApplicationController
  def index
    @response = nil
  end

  def create
    file_content = params[:file]
    question = params[:question]
    @response = OpenaiChatService.new(question, file_content).call

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
