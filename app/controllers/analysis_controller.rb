# app/controllers/analysis_controller.rb
class AnalysisController < ApplicationController
  # POST /upload_and_analyze
  def create
    uploaded = params.require(:file)  # formularz multipart: <input type="file" name="file">
    # możesz podać purpose lub inne metadane dla Claude
    @result = ClaudeFileUploader.new.upload(uploaded, metadata: { purpose: 'analysis' })

    # wynik zawiera np. `id`, `filename`, `size_bytes`, `purpose`, `status` itd.
    # render html: result
  # rescue => e
  #   render json: { error: e.message }, status: :unprocessable_entity
  
  end
end
