class InputsController < ApplicationController
  def index
  end
  
  def send_message 
    if params[:message].present?
      response = OpenaiService.new.handle_message(params[:message])
      Rails.logger.info("Response: #{response}")

      render turbo_stream: turbo_stream.append("response_area", partial: "inputs/response", locals: { response: response })

    else
      render json: { error: 'No question provided' }, status: :unprocessable_entity
    end
  end
end
