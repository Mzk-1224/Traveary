class BoardsController < ApplicationController
  skip_before_action :require_login, only: %i[index]

  def index
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
