class PicturesController < ApplicationController
  require 'aws-sdk'
  require 'tempfile'
  require 'mysql2.rb'
  require 'mysql2'
  
  
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
    @data = params[:content]
    @user = params[:user_id]
    @parkname = params[:parkname]
    @playground = params[:playground]
    # binding.pry
    @time = Time.now.strftime("%Y-%m-%d_%H:%M:%S")
    gon.index_id = @index
    gon.user_id = @user
    
    respond_to do |format|
      format.js
      format.html
    end
    
  end

  # GET /pictures/1/edit
  def edit
  end

  # POST /pictures
  # POST /pictures.json
  def create
    @parkname = params[:parkname]
    @playground = params[:playground]
    @picture = Picture.new(picture_params)
    # @picture.pic = params['picture']['pic']
    # @index_id = params['index_id']
    # @picture_id = params['id']
    @user = params[:user_id]
    # @users = Index.find_by(@user)
    # @index = params[:index_id]
    # 日本語の場合、画像でエラーが出る20181009
    # @indexname = @picture.index.name
    # if @users.parkname.blank? == false && @user.playground.blank? == false
    # binding.pry
    if @picture.save
      return redirect_to :controller => 'indices', :action => 'index', :user_id => @user, notice: '保存しました' 
    else
      render :index
    end
    # @picture.save
    # redirect_to "https://6c75a153c08941c4ae69951ba6ec7f32.vfs.cloud9.us-east-2.amazonaws.com/users/47/indices/"
    # redirect_to _path(@user), notice: "wahaha"
    # render :action => "new"
    
    # respond_to do |format|
    #   if @picture.save
    #     format.html { redirect_to user_indices_path(@user), notice: 'Picture was successfully created.' }
    #     format.json { render :show, status: :created, location: @picture }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @picture.errors, status: :unprocessable_entity }
    #   end
    # end
    
    
    # データベースpicを要らない文字列を除外してデコード
    # image_data = Base64.decode64(@picture.pic['data:image/png;base64,'.length .. -1])
    # ダウンロード
    # if Dir::exist?("#{Rails.root}/public/downloads/name_no#{@picture.index_id}")
    #   File.open("#{Rails.root}/public/downloads/name_no#{@picture.index_id}/#{@indexname}_#{@picture.id}.png", 'wb') do |f|
    #     f.write(image_data)
        
    #   end
       
      # これが効くかどうか？20181026
    # else
    #   Dir::mkdir("#{Rails.root}/public/downloads/name_no#{@picture.index_id}")
    #   File.open("#{Rails.root}/public/downloads/name_no#{@picture.index_id}/#{@indexname}_#{@picture.id}.png", 'wb') do |f|
    #     f.write(image_data)
        
    #   end
      
    # end
    
  end

  def canvasurl
    # aws.configが効かないcredentialsでエラー
    # Aws.config.update({
    #   region: 'ap-northeast-1',
    #   credentials: Aws::Credentials.new()
    # })
    @user = params[:user_id]
    @index = params[:index_id]
    @canvasurl = params[:content]
    @time = Time.now.strftime("%Y-%m-%d:%H:%M:%S")
    # binding.pry
    # ajaxで渡されたデータを要らない文字列を除外してデコード
    image_data = Base64.decode64(@canvasurl['data:image/png;base64,'.length .. -1])
    p image_data.slice(1..10)
    # ダウンロード
    if Dir::exist?("#{Rails.root}/app/downloads/user#{@user}")
      File.open("#{Rails.root}/app/downloads/user#{@user}/user#{@user}_namenum#{@index}_#{@time}.png", 'wb') do |f|
        f.write(image_data)
      end
    else
      Dir::mkdir("#{Rails.root}/app/downloads/user#{@user}")
        File.open("#{Rails.root}/app/downloads/user#{@user}/user#{@user}_namenum#{@index}_#{@time}.png", 'wb') do |f|
        f.write(image_data)
      end
    end
    s3 = Aws::S3::Resource.new(
      :region => 'ap-northeast-1',
      :access_key_id => Rails.application.secrets.aws_access_key_id,
      :secret_access_key => Rails.application.secrets.aws_secret_key
      )
    myBacket = 'distributeimage'
    myKey = "user#{@user}_namenum#{@index}_#{@time}"
    obj = s3.bucket(myBacket).object(myKey)
    unless obj.exists?
      obj.upload_file("#{Rails.root}/app/downloads/user#{@user}/user#{@user}_namenum#{@index}_#{@time}.png")
    # else
    #   s3.buckets.create(myKey)
    #   obj.upload_file("#{Rails.root}/downloads/name_no#{@index}/#{@index}_#{@time}.png")
    end
    File.unlink("#{Rails.root}/app/downloads/user#{@user}/user#{@user}_namenum#{@index}_#{@time}.png")
    Dir.rmdir("#{Rails.root}/app/downloads/user#{@user}")
    render nothing: true
  end
  
  def imagecopy
    @user = params[:user_id]
    @index = params[:index_id]
    @origin_id = params[:origin_id]
    @image_number = params[:image_number]
    @time = Time.now.strftime("%Y-%m-%d_%H:%M:%S")
    s3 = Aws::S3::Client.new(
      :region => 'ap-northeast-1',
      :access_key_id => Rails.application.secrets.aws_access_key_id,
      :secret_access_key => Rails.application.secrets.aws_secret_key
      )
    myBacket = 'distributeimage'
    
    lists = s3.list_objects(:bucket => myBacket, :prefix => "user#{@user}_namenum#{@origin_id}").contents.to_a.reverse
    list = lists[@image_number.to_i].key
    s3.copy_object(
      copy_source: "/"+myBacket+"/"+list,
      bucket: myBacket,
      key: "user#{@user}_namenum#{@index}_#{@time}"
      )
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
  
  # drag&dropで元indexからindex先へmysql内でコピペ
  def dropnew
    @content = params[:content]
    @index = params[:index_id]
    @user = params[:user_id]
    # binding.pry
    # @picture = Picture.new
    # droppedToMysql(@content, @index)
    @time = Time.now.strftime("%Y-%m-%d %H:%M:%S")
    # mysqlを最新版にしてprepare statementが効いた
    client = Mysql2::Client.new(:host => Rails.application.secrets.mysql2_host, 
                                :username => 'b91ec100ce5738', 
                                :database => 'heroku_62e005e56ca517c', 
                                :socket => "/var/lib/mysql/mysql.sock",
                                :password => Rails.application.secrets.mysql2_password
                                )
    statement = client.prepare('INSERT INTO pictures (pic, index_id, created_at, updated_at) VALUES(?,?,?,?)')
    statement.execute(@content, @index, @time, @time)
    render nothing: true
  end
  
  def uploadtoaws
    @time = Time.now.strftime("%Y-%m-%d_%H:%M:%S")
    @content = params[:content]
    @user_id = params[:user_id]
    @index_id = params[:index_id]
    
    s3 = Aws::S3::Client.new(
      :region => 'ap-northeast-1',
      :access_key_id => Rails.application.secrets.aws_access_key_id,
      :secret_access_key => Rails.application.secrets.aws_secret_key
      )
    myBacket = 'distributeimage'
    s3.put_object(
        :bucket => myBacket,
        :key    => 'user' + @user_id + '_namenum' + @index_id + '_' + @time + ".png",
        :content_type => 'image/png',
        :body => @content
        )
  render nothing: true
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
