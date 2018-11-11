class IndicesController < ApplicationController
  require 'rubyzip.rb'
  require 'aws-sdk'
  require 'open-uri'
  require 'zipline'
  
  include ActionController::Streaming
  include Zipline
  before_action :set_index, only: [:show, :edit, :update, :destroy]

  # GET /indices
  # GET /indices.json
  def index
    @user = params[:user_id]
    @indices = Index.includes(:pictures).all
    # binding.pry
  end

  # GET /indices/1
  # GET /indices/1.json
  def show
    @user = params[:user_id]
  end
  
  # GET /indices/download
  def downloads
    @user = params[:user_id]
    @user_account = User.find(@user)
    @email = @user_account.email
    # binding.pry
    # downloadsのサブディレクトリだけを取り出し
  #   Dir.glob("#{Rails.root}/public/downloads/**").each{ |name|
		# if FileTest.directory?(name)
			
  #   end
  #   }
    # directory_to_zip = "#{Rails.root}/public/downloads"
    # output_file = "#{Rails.root}/lib/downloads.zip"
    # zip_file_generator = ZipFileGenerator.new(directory_to_zip, output_file)
    # # binding.pry
    # zip_file_generator.write
    # send_file(output_file, filename: 'image.zip', disposition: 'attachment', stream: true)
    zipline(s3all, "user#{@user}_#{@email}.zip")
  end
  
  def download
    @index = params['id']
    @user = params['user_id']
    # binding.pry
    myBacket = 'ueyamamasashi-bucket1'
    bucket = Aws::S3::Client.new(
             :region => 'ap-northeast-1',
             :access_key_id => Rails.application.secrets.aws_access_key_id,
             :secret_access_key => Rails.application.secrets.aws_secret_key
             )
    # get_objectメソッドはlist_objectsのobjectに効かない(object.get_object x)
    # bucket.list_objects(:bucket => myBacket, :prefix => "name_no#{@index}",:max_keys => 10).contents.each do |object|
    # data = object.get_object()
    # bucket.list_objects(:prefix => "name_no#{@index}",:max_keys => 10).each do |object|
      
    # data = Net::HTTP.get(URI.parse(object.public_url))
    # data = open(URI.encode(object.public_url))
    # name = %r(/^name_no#{@index}/)
      # data = bucket.get_object(:bucket => myBacket, :key => object.key)
    
    # puts data.key
    # send_data(data.body.read, filename: "name_no#{@index}.png", disposition: 'attachment', stream: true)
    # end
    # directory_to_zip = "#{Rails.root}/public/downloads/name_no#{@index}"
    # output_file = "#{Rails.root}/public/zips/name_no#{@index}.zip"
    # zip_file_generator = ZipFileGenerator.new(directory_to_zip, output_file)
    # zip_file_generator.write
    # if Dir.exist?(directory_to_zip)
    #   send_file(output_file, filename: "name_no#{@index}.zip", disposition: 'attachment', stream: true)
    # else
   
    zipline(s3lists, "user#{@user}_namenum#{@index}.zip")
      return
      
    
  end
  
  # GET /indices/new
  def new
    @index = Index.new
    @user = params[:user_id]
  end

  # GET /indices/1/edit
  def edit
    @user = params[:user_id]
    @index_id = params[:id]
  end

  # POST /indices
  # POST /indices.json
  def create
    @index = Index.new(index_params)
    # @index.save
    respond_to do |format|
      
      if @index.save
        format.html { redirect_to controller: :indices, action: :index, notice: 'Index was successfully created.' }
        format.json { render :show, status: :created, location: @index }
      else
        format.html { render :new }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /indices/1
  # PATCH/PUT /indices/1.json
  def update
    respond_to do |format|
      if @index.update(index_params)
        format.html { redirect_to controller: :indices, action: :index, notice: 'Index was successfully updated.' }
        format.json { render :show, status: :ok, location: @index }
      else
        format.html { render :edit }
        format.json { render json: @index.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /indices/1
  # DELETE /indices/1.json
  def destroy
    @user = params[:user_id]
    @id = params[:id]
    # binding.pry
    @index.destroy
    respond_to do |format|
      format.html { redirect_to user_indices_path(@user), notice: 'Index was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_index
      @index = Index.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def index_params
      params.require(:index).permit(:name, :num, :pictures_count, :user_id)
    end
    
    def s3lists
      # @user = params[:user_id]
      # @index = params[:id]
      # binding.pry
      myBacket = 'ueyamamasashi-bucket1'
      bucket = Aws::S3::Client.new(
             :region => 'ap-northeast-1',
             :access_key_id => Rails.application.secrets.aws_access_key_id,
             :secret_access_key => Rails.application.secrets.aws_secret_key
             )
      lists = []
      bucket.list_objects(:bucket => myBacket, :prefix => "user#{@user}_namenum#{@index}").contents.each do |b|
        lists.push(b)
      end
      lists.lazy.map do |list|
        logger.debug "get file from s3 : #{list}"
        s3_object = bucket.get_object(bucket: myBacket, key: list.key)
        [s3_object.body, list.key+".png"]
      end
    end
    
    def s3all
      # @user = params[:user_id]
      # binding.pry
      myBacket = 'ueyamamasashi-bucket1'
      bucket = Aws::S3::Client.new(
             :region => 'ap-northeast-1',
             :access_key_id => Rails.application.secrets.aws_access_key_id,
             :secret_access_key => Rails.application.secrets.aws_secret_key
             )
      lists = []
      bucket.list_objects(:bucket => myBacket, :prefix => "user#{@user}").contents.each do |b|
        lists.push(b)
      end
      lists.lazy.map do |list|
        logger.debug "get file from s3 : #{list}"
        s3_object = bucket.get_object(bucket: myBacket, key: list.key)
        [s3_object.body, list.key+".png"]
      end
    end
end
