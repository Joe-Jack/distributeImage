class IndicesController < ApplicationController
  require 'rubyzip.rb'
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
    directory_to_zip = "#{Rails.root}/public/downloads"
    output_file = "#{Rails.root}/lib/downloads.zip"
    zip_file_generator = ZipFileGenerator.new(directory_to_zip, output_file)
    # binding.pry
    zip_file_generator.write
    send_file(output_file, filename: 'image.zip', disposition: 'attachment', stream: true)
    
  end
  
  def download
    # binding.pry
    @index = params['id']
    # @picture = 
    # @indexname = @picture.index.name
    directory_to_zip = "#{Rails.root}/public/downloads/name_no#{@index}"
    output_file = "#{Rails.root}/public/zips/name_no#{@index}.zip"
    zip_file_generator = ZipFileGenerator.new(directory_to_zip, output_file)
    zip_file_generator.write
    if Dir.exist?(directory_to_zip)
      send_file(output_file, filename: "name_no#{@index}.zip", disposition: 'attachment', stream: true)
    else
      return
      
    end
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
end
