class RewardsController < ApplicationController

  before_filter :require_context
  add_crumb(proc { t('#crumbs.rewards', "Rewards")}) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_rewards_url }
  before_filter { |c| c.active_tab = "Rewards" }

  def new
    @reward = Reward.new
  end

  def create

    @reward = Reward.new(params[:reward])
    @reward.account_id=@domain_root_account.id
    @reward.pseudonym_id = Pseudonym.find(@reward.account_id).id


    if @reward.save!
      redirect_to account_rewards_path
    end
  end

  def edit
    @reward = Reward.find(params[:id])
  end


  def update
    @reward = Reward.find(params[:id])
    @reward.account_id=@domain_root_account.id

    if @reward.update_attributes(params[:reward])
      #flash[:success] ="Successfully Updated Category."
      redirect_to account_rewards_path
    end

  end

  def show
    @reward = Reward.find(params[:id])
  end
  def destroy
    @reward = Reward.find(params[:id])
    @reward.destroy
    #flash[:success] = "Successfully Destroyed Category."
    redirect_to account_rewards_path
  end

  def index
    @rewards = Reward.all
  end
end

