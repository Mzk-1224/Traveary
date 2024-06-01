class BoardsController < ApplicationController
  before_action :require_login, except: [:show, :index]
  before_action :set_board, only: [:edit, :update, :destroy]
  before_action :set_prefectures, only: [:new, :edit]

  def index
      @boards = Board.all.includes(:user).order(created_at: :desc).page(params[:page]).per(9)
      @visited_prefectures_count = current_user&.visited_prefectures&.count
  end

  def show
    @board = Board.find(params[:id])
  end

  def new
    @board = Board.new
    @prefectures = Prefecture.all
  end

  def create
    @board = current_user.boards.build(board_params)
    @prefectures = Prefecture.all
    if @board.save
      flash[:notice] = I18n.t('flash_message.created', item: Board.model_name.human)
      redirect_to boards_path
    else
      flash.now[:danger] = I18n.t('flash_message.not_created', item: Board.model_name.human)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @board.update(board_params)
      flash[:notice] = I18n.t('flash_message.updated', item: Board.model_name.human)
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('flash_message.not_updated', item: Board.model_name.human)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @board.destroy
    flash[:notice] = I18n.t('flash_message.deleted', item: Board.model_name.human)
    redirect_to boards_path
  end

  private

  def require_login
    unless logged_in?
      flash[:notice] = "ログインしてください"
      redirect_to login_path
    end
  end

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :body, :prefecture_id, :board_image, :board_image_cache)
  end

  def set_prefectures
    @prefectures = Prefecture.all
  end
end
