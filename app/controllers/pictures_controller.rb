class PicturesController < ApplicationController
  require 'aws-sdk'
  require 'tempfile'
 
  
  before_action :set_picture, only: [:show, :edit, :update, :destroy]
  # GET /pictures
  # GET /pictures.json
  def index
    @picture = Picture.new
    
  end

  
 

  # GET /pictures/new
  def new
    @picture = Picture.new
    @index = params[:index_id]
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @picture = Picture.new(picture_params)
    @picture.pic = params['picture']['pic']
    @picture.index_id = params['index_id']
    @picture.id = params['id']
    # 日本語の場合、画像でエラーが出る20181009
    @indexname = @picture.index.name
    
    
    @picture.save
    #   redirect_to indices_path, notice: '保存しました'
    # else
    #   render :index
    # end
    # respond_to do |format|
    #   if @picture.save!
        
    #     format.html { redirect_to @picture, notice: 'Picture was successfully created.' }
    #     format.json { render :show, status: :created, location: @picture }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @picture.errors, status: :unprocessable_entity }
    #   end
    # end
    
    
    # データベースpicを要らない文字列を除外してデコード
    image_data = Base64.decode64(@picture.pic['data:image/png;base64,'.length .. -1])
    # ダウンロード
    if Dir::exist?("#{Rails.root}/public/downloads/name_no#{@picture.index_id}")
      File.open("#{Rails.root}/public/downloads/name_no#{@picture.index_id}/#{@indexname}_#{@picture.id}.png", 'wb') do |f|
        f.write(image_data)
        
      end
       
      # これが効くかどうか？20181026
    else
      Dir::mkdir("#{Rails.root}/public/downloads/name_no#{@picture.index_id}")
      File.open("#{Rails.root}/public/downloads/name_no#{@picture.index_id}/#{@indexname}_#{@picture.id}.png", 'wb') do |f|
        f.write(image_data)
        
      end
      
    end
    
  end

  def canvasurl
    # aws.configが効かないcredentialsでエラー
    # Aws.config.update({
    #   region: 'ap-northeast-1',
    #   credentials: Aws::Credentials.new()
    # })
    @index = params[:index_id]
    @canvasurl = params[:content]
    @time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    # binding.pry
    # ajaxで渡されたデータを要らない文字列を除外してデコード
    image_data = Base64.decode64(@canvasurl['data:image/png;base64,'.length .. -1])
    # ダウンロード
    if Dir::exist?("#{Rails.root}/tmp/downloads/name_no#{@index}")
      File.open("#{Rails.root}/tmp/downloads/name_no#{@index}/#{@index}_#{@time}.png", 'wb') do |f|
        f.write(image_data)
      end
    else
      Dir::mkdir("#{Rails.root}/tmp/downloads/name_no#{@index}")
      File.open("#{Rails.root}/tmp/downloads/name_no#{@index}/#{@index}_#{@time}.png", 'wb') do |f|
        f.write(image_data)
      end
    end
    s3 = Aws::S3::Resource.new(
      :region => 'ap-northeast-1',
      :access_key_id => Rails.application.secrets.aws_access_key_id,
      :secret_access_key => Rails.application.secrets.aws_secret_key
      )
    myBacket = 'ueyamamasashi-bucket1'
    myKey = "name_no#{@index}_#{@time}"
    obj = s3.bucket(myBacket).object(myKey)
    unless obj.exists?
      obj.upload_file("#{Rails.root}/tmp/downloads/name_no#{@index}/#{@index}_#{@time}.png")
    # else
    #   s3.buckets.create(myKey)
    #   obj.upload_file("#{Rails.root}/tmp/downloads/name_no#{@index}/#{@index}_#{@time}.png")
    end
    File.unlink("#{Rails.root}/tmp/downloads/name_no#{@index}/#{@index}_#{@time}.png")
    Dir.rmdir("#{Rails.root}/tmp/downloads/name_no#{@index}")
    render nothing: true
  end
  
  
  # PATCH/PUT /pictures/1
  # PATCH/PUT /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to @picture, notice: 'Picture was successfully updated.' }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1
  # DELETE /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_url, notice: 'Picture was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_picture
      @picture = Picture.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def picture_params
      params.require(:picture).permit(:pic, :index_id)
    end
end
