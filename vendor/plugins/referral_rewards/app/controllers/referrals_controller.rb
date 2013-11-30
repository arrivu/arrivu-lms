class ReferralsController < ApplicationController

  before_filter :require_context
  add_crumb(proc { t('#crumbs.referrals', "Referrals")}) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_referrals_url }
  before_filter { |c| c.active_tab = "Referrals" }


  def new
    @referral = Referral.new
  end

  def create

    @referral = Referral.new(params[:referral])

    if @context.is_a?(Course)

      @referral.reward_id = Reward.find(params[:course_id]).id
      @referral.pseudonym_id = Reward.find(@referral.reward_id).pseudonym_id
      @referral.email_subject = Reward.find(@referral.reward_id).email_subject
      @referral.email_text = Reward.find(@referral.reward_id).email_template_txt
      #@referral.create_referrees
      @referral.short_url_code =  url_generate
      if @referral.save!
        redirect_to course_referrals_path
      end
      elsif @context.is_a?(Account)
        @domain_root_account
    end
  end

  def url_generate
    referral_url = Googl.shorten("http://localhost:3000/courses/#{@context.id}")
  end
 #def fb(provid,src = params[:src])
 #      provid = referral_url
 #end


  def edit
    @referral = Referral.find(params[:id])
  end


  def update
    @referral = Referral.find(params[:id])
    @referral.user_id=@context.id

    if @referral.update_attributes(params[:referral])
      #flash[:success] ="Successfully Updated Category."
      redirect_to account_rewards_path
    end

  end

  def show
    @referral = Referral.find(params[:id])
  end
  def destroy
    @referral = Referral.find(params[:id])
    @referral.destroy
    #flash[:success] = "Successfully Destroyed Category."
    redirect_to course_path
  end

  def index
    @referrals = Referral.all
    #@referral = Referral.new(params[:referral])
    #@referral.reward_id = Reward.find(params[:course_id]).id
    #@referral.pseudonym_id = Reward.find(@referral.reward_id).pseudonym_id
    #@referral.email_subject = Reward.find(@referral.reward_id).email_subject
    #@referral.email_text = Reward.find(@referral.reward_id).email_template_txt
  end


  def my_rewards
  end

end
