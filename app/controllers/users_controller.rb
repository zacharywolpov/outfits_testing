class UsersController < ApplicationController
  before_action :authorize, except: [:new, :create]

  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(session[:user_id])
    if @user.nil?
      redirect_to login_path
    end
  end

  def create
    @user = User.new(params.require(:user).permit(:name, :email, :password))
    if @user.save

      redirect_to root_path
    else
      render json: { error: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def delete_closet
    @user = User.find(session[:user_id])
    if @user.closet.attached?
      if @user.closet.purge.nil?
        Rails.logger.info("")
        redirect_to root_path
      end
    end
  end

  def delete_outfits_history
    @user = User.find(session[:user_id])
    if @user.outfits_history.attached?
      if @user.outfits_history.purge.nil?
        Rails.logger.info("")
        redirect_to root_path
      end
    end
  end

  def update
    @user = User.find(params[:id])

    if params[:user][:closet].present?
      if @user.update(closet: params[:user][:closet])
        Rails.logger.info("Closet uploaded successfully!")
      else
        Rails.logger.error(@user.errors.full_messages)
      end

    elsif params[:user][:outfits_history].present?
      if @user.update(outfits_history: params[:user][:outfits_history])
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
