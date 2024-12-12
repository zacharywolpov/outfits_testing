class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def create
    @user = User.new(user_params(:name))

    if @user.save
      render json: { message: "User created successfully", user: @user }, status: :created
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:closet].present?
      if @user.update(user_params(:closet))
        Rails.logger.info("Closet uploaded successfully!")
      else
        Rails.logger.error(@user.errors.full_messages)
      end

    elsif params[:user][:outfits_history].present?
      if @user.update(user_params(:outfits_history))
        Rails.logger.info("Outfits history uploaded successfully!") 
      else
        Rails.logger.error(@user.errors.full_messages)
      end

    else
      render json: { error: "No file provided" }, status: :bad_request
    end
  end


  private

  def user_params(attribute)
    params.require(:user).permit(attribute)
  end

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

  # Currently ONLY for an excel file
  # def process_and_embed(file)
  #   # Temporarily download the xlsx file
  #   temp_file = Tempfile.new
  #   temp_file.binmode
  #   temp_file.write(file.download)
  #   temp_file.rewind
    
  #   xlsx = Roo::Spreadsheet.open(temp_file.path, extension: :xlsx)
  #   sheet = xlsx.sheet(0)
  #   data = sheet.each_row_streaming.map { |row| row.map(&:value) }.flatten.join(' ')


  #   puts "DATA TYPE BELOW"
  #   puts data.class

  #   # Embedding process
  #   client = OpenaiService.new
  #   embedding = client.generate_embeddings(data)
    
  #   embedding
  # end
end
