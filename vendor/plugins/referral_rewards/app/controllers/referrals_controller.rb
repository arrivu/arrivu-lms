class ReferralsController < ApplicationController

  before_filter :require_context
  add_crumb(proc { t('#crumbs.referrals', "Referrals")}) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_referrals_url }
  before_filter { |c| c.active_tab = "Referrals" }

  def new
    @reward = Reward.find_by_metadata(@context.id.to_s)
    if @reward
      @referral = @reward.referral.find_by_pseudonym_id(@current_pseudonym.id)
      if @referral.nil?
        @referral = @reward.build_referral(pseudonym_id: @current_pseudonym.id,email_text: @reward.email_template_txt,

                                           email_subject: @reward.email_subject)

        @references1 = @referral.build_reference(short_url_code: SecureRandom.uuid,provider: "facebook")
        @references2 = @referral.build_reference(short_url_code: SecureRandom.uuid,provider: "twitter")
        @references3 = @referral.build_reference(short_url_code: SecureRandom.uuid,provider: "linkedin")
        @references4 = @referral.build_reference(short_url_code: SecureRandom.uuid,provider: "google")
        @references5 = @referral.build_reference(short_url_code: SecureRandom.uuid,provider: "global")
        @referral.save!
      else


      end
    else
      flash[:info] = "There is no reward"
      redirect_to course_reward_path(@context)
    end
  end

  def create
    @referral = Referral.find(params[:referral])
    params [:referral][:email_subject]
    params [:referral][:emails]
    params [:referral][:email_text]
    @references1 = @referral.build_reference(short_url_code: SecureRandom.uuid,provider: @email)
  end

  #def url_generate
  #  referral_url = Googl.shorten("http://localhost:3000/accounts/#{@domain_root_account.id}").short_url
  #end

  def index
    @reward = Reward.find_by_metadata(@context.id.to_s)
    if @reward
      @referral = @reward.referral.find_by_pseudonym_id(@current_pseudonym.id)
    end
    @references = @referral.references
  end




end
