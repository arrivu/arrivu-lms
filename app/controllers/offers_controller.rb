class OffersController < ApplicationController

  def new
    @offer = Offer.new
  end

  def create
    @offer = Offer.new(params[:offer])
    if @offer.save
      flash[:notice] = t('Created Sucessfully')
      redirect_to accounts_path
    end
  end



  def edit
  end

  def show
  end

  def index
    @offer = Offer.new
  end

end
