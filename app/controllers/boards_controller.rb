class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[index]
  before_action :set_board, only: %i[edit update destroy]

  def index
    @boards = Board.all.includes(:user, :images).order(created_at: :desc).page(params[:page])
  end

  def show
    @board = Board.find(params[:id])
    @images = @board.images
  end

  def new
    @board = Board.new
    @board.images.build
  end


  def create
    @board = current_user.boards.build(board_params)
    if @board.save
      flash[:success] = I18n.t('flash_messages.created', item: Board.model_name.human)
      redirect_to boards_path
    else
      unless @board.images.present?
        @board.images.build
        render :new
      else
        flash.now[:danger] = I18n.t('flash_messages.not_created', item: Board.model_name.human)
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit; end

  def update

    board = Board.find(params[:id])
    if board.title != params[:board][:title]

      board.update!(board_params)

    else
      post.save!

      params[:board][:image].each do |image|
        board.image.create(image: image, board_id: board.id)
      end
    end

    redirect_to root_path
  end

  def destroy
    @board.destroy!
    flash[:success] = I18n.t('.flash_messages.deleted', item: Board.model_name.human)
    redirect_to boards_path, status: :see_other
  end

  private

  def set_board
    @board = current_user.boards.find(params[:id])
  end

  def board_params
    params.require(:board).permit(:title, :body, images_attributes: [:image, :_destroy, :id]).merge(user_id: current_user.id)
  end
end