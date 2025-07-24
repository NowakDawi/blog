# app/controllers/claude_controller.rb
class ClaudeController < ApplicationController
  def analyze
    uploaded_file = params[:file]
    message = params[:question]

    service = ClaudeService.new

    if defined?(uploaded_file) && uploaded_file.present?
      mime_type = uploaded_file.content_type

      begin
        case mime_type
        when /^image\//
          # Obsługa obrazów jako base64
          file_path = uploaded_file.tempfile.path
          response = service.chat_with_image(file_path, message)

        when "application/pdf", "application/msword", "application/vnd.openxmlformats-officedocument.wordprocessingml.document", "text/plain"
          # Obsługa dokumentów
          file_response = service.upload_file(uploaded_file)
          file_id = file_response["id"]
          response = service.chat_with_document(message, file_id)

        else
          render json: { error: "Nieobsługiwany typ pliku: #{mime_type}" }, status: :unsupported_media_type and return
        end
      end
    else
      response = service.chat(message)

    end
    respond_to do |format|
      format.html  # Handles standard HTML requests

      format.turbo_stream do
        render turbo_stream: turbo_stream.prepend(
          'response',
          partial: 'claude/show',
          locals: { response: response['content'][0]['text']}
        )
      end
  end
end
end
