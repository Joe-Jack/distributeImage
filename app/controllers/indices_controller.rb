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
    @indices = Index.includes(:pictures).all
  end

  # GET /indices/1
  # GET /indices/1.json
  def show
  end
  
  # GET /indices/download
  def downloads
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
    zipline(s3all, "all.zip")
  end
  
  def download
    @index = params['id']
    myBacket = 'ueyamamasashi-bucket1'
    bucket = Aws::S3::Client.new(
             :region => 'ap-northeast-1',
              :access_key_id => '',
              :secret_access_key => ''
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
   
    zipline(s3lists, "name_no#{@index}.zip")
      return
      
    
  end
  
  # GET /indices/new
  def new
    @index = Index.new
  end

  # GET /indices/1/edit
  def edit
  end

  # POST /indices
  # POST /indices.json
  def create
    @index = Index.new(index_params)

    respond_to do |format|
      if @index.save
        format.html { redirect_to @index, notice: 'Index was successfully created.' }
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
        format.html { redirect_to @index, notice: 'Index was successfully updated.' }
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
    @index.destroy
    respond_to do |format|
      format.html { redirect_to indices_url, notice: 'Index was successfully destroyed.' }
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
      params.require(:index).permit(:name, :num, :pictures_count)
    end
    
    def s3lists
      @index = params[:id]
      myBacket = 'ueyamamasashi-bucket1'
      bucket = Aws::S3::Client.new(
             :region => 'ap-northeast-1',
              :access_key_id => '',
              :secret_access_key => ''
             )
      lists = []
      bucket.list_objects(:bucket => myBacket, :prefix => "name_no#{@index}").contents.each do |b|
        lists.push(b)
      end
      lists.lazy.map do |list|
        logger.debug "get file from s3 : #{list}"
        s3_object = bucket.get_object(bucket: myBacket, key: list.key)
        [s3_object.body, list.key+".png"]
      end
    end
    
    def s3all
      myBacket = 'ueyamamasashi-bucket1'
      bucket = Aws::S3::Client.new(
             :region => 'ap-northeast-1',
              :access_key_id => '',
              :secret_access_key => ''
             )
      lists = []
      bucket.list_objects(:bucket => myBacket, :prefix => "name_no").contents.each do |b|
        lists.push(b)
      end
      lists.lazy.map do |list|
        logger.debug "get file from s3 : #{list}"
        s3_object = bucket.get_object(bucket: myBacket, key: list.key)
        [s3_object.body, list.key+".png"]
      end
    end
end
