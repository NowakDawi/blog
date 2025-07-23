# app/controllers/ai_controller.rb
class ClaudeController < ApplicationController
  def index
    @response = nil
  end

  def create
    uploaded_io  = params.require(:file)
    context_text = params[:question] || ""

    # zapisz plik tymczasowo
    temp_path = Rails.root.join("tmp", uploaded_io.original_filename)
    File.open(temp_path, "wb") { |f| f.write(uploaded_io.read) }

    @response = ClaudeService
               .new(file_path: temp_path.to_s, context_text: context_text)
               .call

    File.delete(temp_path) if File.exist?(temp_path)

    @claude_response = response
    
    Rails.logger.info "Claude zwrócił: #{@response.inspect}"


    respond_to do |format|
    format.html  # dla klasycznego żądania
    format.turbo_stream do
    render turbo_stream: turbo_stream.prepend(
      'response',
      partial: 'claude/show',
      locals: { response: @response }
    )
      end
    end
  end
end