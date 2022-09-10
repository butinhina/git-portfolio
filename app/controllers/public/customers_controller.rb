class Public::CustomersController < ApplicationController
 before_action :check_guest, only: [:update, :withdraw]
  def show
    @customer = Customer.find(params[:id])
    @post_videos = @customer.post_videos.published.page(params[:page]).reverse_order # 投稿したものだけ表示

    if params[:tag_ids].present?
      @post_videos = []
      params[:tag_ids].each do |key, value|
        @post_videos += Tag.find_by(name: key).post_videos if value == "1"
        # @post_videosの中から、current_customerのものだけ表示したい
        # ここは回りくどい処理だが、上記の処理だと他の方法が見つからなかったため下記のような処理になっている
        @post_videos.each do |post_video|
          if post_video.customer_id != current_customer.id
          @post_videos.delete(post_video)
          end
        end
      end
      @post_videos.uniq!
    end
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to public_customer_path(current_customer.id), notice: "会員情報を更新しました。"
    else
      render :edit
    end
  end

  def unsubscribe
  end

  def withdraw
    @customer = current_customer
    @customer.update(is_active: false)
    reset_session
    redirect_to root_path
  end

  def check_guest
    if current_customer == Customer.guest
      redirect_to root_path, alert: 'ゲストユーザーの更新・削除はできません。'
    end
  end

  private
  def customer_params
    params.require(:customer).permit(:last_name, :first_name, :last_name_kana, :first_name_kana, :email, :nickname, :height, :birth_dat, :holding_ball, :history, :forte_club, :message, :profile_image)
  end
end
