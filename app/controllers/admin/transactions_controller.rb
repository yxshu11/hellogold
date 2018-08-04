class Admin::TransactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!
  before_action :find_country, only: [:show, :approve, :reject]

  def index
    @transactions = Transaction.all
  end

  def show
  end

  def approve
  end

  def reject
  end

  private

  def authenticate_admin!
    unless current_user.is_admin?
      flash[:alert] = "Not authorized"
      redirect_to root_path
    end
  end

  def find_country
    @transaction = Transaction.find(params[:id])
  end
end
