class PostsController < ApplicationController
  def index
    @posts = Post.all
    respond_to do |format|
      # @test = { "status" => "success", "items" => { "one" => "Singular sensation", "two" => "Beady little eyes", "three" => "Little birds pitch by my doorstep" } }
      # @test = '[{"alert_message":"","compass_point_name":"Inbound","latitude":"14.633355","longitude":"-90.570323","now":"2012-04-06T15:19:08Z","rating":"5","rating_description":"Stopped","report_date":"2012-04-06T10:15:00-05:00","report_date_beg":"2012-04-06T15:11:38Z","report_date_end":"2012-04-06T15:26:38Z","report_date_str":"2012-04-06 15:15:00","source":"h","tch_rep_date":"2012-04-06T15:15:00Z","traffic_camera_id":1,"traffic_camera_name":"Calzada Roosevelt @ 39 Avenida","traffic_rating_id":5,"url":"www.sensr.com/cam1a.com"},{"alert_message":"","compass_point_name":"Outbound","latitude":"14.622039","longitude":"-90.549488","now":"2012-04-06T15:19:08Z","rating":"2","rating_description":"Good","report_date":"2012-04-06T10:15:00-05:00","report_date_beg":"2012-04-06T15:11:38Z","report_date_end":"2012-04-06T15:26:38Z","report_date_str":"2012-04-06 15:15:00","source":"h","tch_rep_date":"2012-04-06T15:15:00Z","traffic_camera_id":2,"traffic_camera_name":"Calzada Roosevelt @ 19 Avenida","traffic_rating_id":2,"url":"www.sensr.com/cam1b.com"}]'
      # format.json { render :text =>  @test, :callback => params[:callback] }
      # format.json { render :json =>  @posts }.to_json
      format.json { render :json =>  @posts, :callback => params[:callback] }.to_json
      # format.json { render :json => { :posts => @posts }}.to_json
      format.html
    end
  end
# {"posts":[{"body":"This is the first post here, Daddy-O!","created_at":"2012-04-05T17:08:12Z","id":1,"title":"First Post","updated_at":"2012-04-05T17:08:12Z"},{"body":"This is the 2nd post, Baby!@@","created_at":"2012-04-05T17:24:32Z","id":2,"title":"Second Post","updated_at":"2012-04-05T17:24:32Z"}]}
  def show
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def post_record
    respond_to do |format|
      format.json {
        @post = Post.new(params[:post])
        if @post.save
          render :json => { :status => "Successfully created post." }
          # render :json => { :status => "Successfully created post.", :callback => params[:callback] }
        else
          render :json => { :error => "There was an error in saving..." }    
        end            
      }
    end
  end
  
  # curl -X POST -v -d 'post={ "title" : "AJAX post submission", "body" : "This is the body of the AJAX form message"}' http://localhost:3000/posts/create.json
  def create
    respond_to do |format|
      format.html {
        @post = Post.new(params[:post])
        if @post.save
          redirect_to @post, :notice => "Successfully created post."
        else
          render :action => 'new'
        end
      }
      format.json {
        @post = Post.new(params[:post])
        if @post.save
          render :json => { :status => "Successfully created post." }
          # render :json => { :status => "Successfully created post.", :callback => params[:callback] }
        else
          render :json => { :error => "There was an error in saving..." }    
        end            
      }
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(params[:post])
      redirect_to @post, :notice  => "Successfully updated post."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to posts_url, :notice => "Successfully destroyed post."
  end
end
