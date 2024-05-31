class BoardsController < ApplicationController
  skip_before_action :require_login, only: [:index]
  before_action :set_board, only: [:edit, :update, :destroy]
  before_action :set_prefectures, only: [:new, :edit]

  def index
    if current_user
      @boards = Board.all.includes(:user, :images).order(created_at: :desc).page(params[:page])
      @visited_prefectures_count = current_user.visited_prefectures.count
      if @boards.present?
        @boards.each do |board|
          board.images.build
        end
      end
    else
      flash[:alert] = "You need to sign in or sign up before continuing."
      redirect_to login_path
    end
  end

  def show
    @board = Board.find(params[:id])
    @images = @board.images
  end

  def new
    @board = Board.new
    images = @board.images.build # 画像オブジェクトをビルド
    @prefectures = Prefecture.all
  end
  
  def create
    @board = current_user.boards.build(board_params)
    @board.images.each { |image| image.board_id = @board.id }
    if @board.save
      flash[:success] = I18n.t('flash_messages.created', item: Board.model_name.human)
      redirect_to boards_path
    else
      flash.now[:danger] = I18n.t('flash_messages.not_created', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      flash[:success] = I18n.t('flash_messages.updated', item: Board.model_name.human)
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('flash_messages.not_updated', item: Board.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy
    flash[:success] = I18n.t('flash_messages.deleted', item: Board.model_name.human)
    redirect_to boards_path
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :body, :prefecture_id, images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)
  end

  def set_prefectures
    @prefectures = Prefecture.all
  end
end
