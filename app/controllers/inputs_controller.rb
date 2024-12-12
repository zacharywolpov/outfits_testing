class InputsController < ApplicationController
  def index
    session[:user_id] = params[:id]
    @user = User.find(session[:user_id])
  end
  
  def send_message 
    user = User.find(session[:user_id])
    
    if params[:message].present?
      response = OpenaiService.new.handle_message(params[:message], process_xlsx(user.outfits_history), user.closet_embedding)
      render turbo_stream: turbo_stream.append("response_area", partial: "inputs/response", locals: { response: response })

    else
      render json: { error: 'No question provided' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error("User not found: #{e.message}")
    render json: { error: "User not found" }, status: :not_found
  end

  # def process_file
  #   uploaded_io = params[:user][:picture]
  #   File.open(Rails.root.join('public', 'uploads', uploaded_io.original_filename), 'w') do |file|
  #     file.write(uploaded_io.read)
  #   end
  # end

  def process_xlsx(file)
    # Temporarily download the xlsx file
    temp_file = Tempfile.new
    temp_file.binmode
    temp_file.write(file.download)
    temp_file.rewind
    
    xlsx = Roo::Spreadsheet.open(temp_file.path, extension: :xlsx)
    sheet = xlsx.sheet(0)
    data = sheet.each_row_streaming.map { |row| row.map(&:value) }.flatten.join(' ')

    data
  end
end
