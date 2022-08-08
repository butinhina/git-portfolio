class Public::PostVideosController < ApplicationController
before_action :authenticate_customer!, except: [:index, :show]
  def new
    @post_video = PostVideo.new
  end

  def create
    @post_video = PostVideo.new(post_video_params)
    @post_video.customer_id = current_customer.id
    @post_video.save
    redirect_to public_customers_acount_path, notice: "投稿に成功できました"
  end

  def index
    @post_videos = PostVideo.page(params[:page])
  end

  def show
    @post_video = PostVideo.find(params[:id])
    @customer = @post_video.customer
  end

  def edit
    @post_video = PostVideo.find(params[:id])
  end

  def update
    @post_video = PostVideo.find(params[:id])
    @post_video.update(post_video_params)
    redirect_to public_post_video_path, notice: "投稿を更新しました"
  end

  def destroy
    @post_video = PostVideo.find(params[:id])
    @post_video.destroy
    redirect_to public_post_videos_path
  end





  private

  def post_video_params
    params.require(:post_video).permit(:customer_id, :report, :video)
  end


end
