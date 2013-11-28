class ReferralsController < ApplicationController

  before_filter :require_context
  add_crumb(proc { t('#crumbs.referrals', "Referrals")}) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_offers_url }
  before_filter { |c| c.active_tab = "Referrals" }

  def new
    @referral = Referral.new
  end

  def create
    @referral = Referral.new(params[:referral])
    @referral.user_id = @current_user.id
    @referral.create_referrees

    @referral.short_url =  Googl::Shorten.new
    if @referral.save!
      redirect_to course_path
    end
  end

  #def shorten(url=nil)
  #  raise ArgumentError.new("URL to shorten is required") if url.nil? || url.strip.empty?
  #  Googl::Shorten.new(url)
  #end
  #
  #def edit
  #  @referral = Referral.find(params[:id])
  #end
  #
  #
  #def update
  #  @referral = Referral.find(params[:id])
  #  @referral.user_id=@context.id
  #
  #  if @referral.update_attributes(params[:referral])
  #    #flash[:success] ="Successfully Updated Category."
  #    redirect_to account_offers_path
  #  end
  #
  #end
  #
  #def show
  #  @referral = Referral.find(params[:id])
  #end
  #def destroy
  #  @referral = Referral.find(params[:id])
  #  @referral.destroy
  #  #flash[:success] = "Successfully Destroyed Category."
  #  redirect_to course_path
  #end
  #
  def index
    #@referrals = Referral.new
    @referrals = Referral.all
  end

  def my_rewards
  end

end
