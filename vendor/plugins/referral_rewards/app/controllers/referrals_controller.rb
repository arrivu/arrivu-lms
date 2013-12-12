class ReferralsController < ApplicationController

  before_filter :require_context
  add_crumb(proc { t('#crumbs.referrals', "Referrals")}) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_referrals_url }
  before_filter { |c| c.active_tab = "Referrals" }


   def create_reference
     @reward = Reward.find_by_metadata_and_metadata_type_and_status(@context.id.to_s, @context.class.name, Reward::STATUS_ACTIVE)
     if @reward
       @referral = @reward.referrals.build(pseudonym_id: @current_pseudonym.id,email_text: @reward.email_template_txt,email_subject: @reward.email_subject)
       create_social_references
       @referral.save!
     end
     js_env(COURSE_REFERRAL: @referral.to_json)
     js_env(COURSE_REWARD: @reward.to_json)
     js_env(COURSE_REFERENCE_FB: @reference_fb.to_json)
     js_env(COURSE_REFERENCE_TW: @reference_tw.to_json)
     js_env(COURSE_REFERENCE_LI: @reference_li.to_json)
     js_env(COURSE_REFERENCE_GO: @reference_go.to_json)
     js_env(COURSE_REFERENCE_GL: @reference_gl.to_json)
     js_env(DOMAIN_URL: @domain_url.to_json)
   end

  def update
    @email_references = []
    @reward = Reward.find_by_metadata_and_metadata_type_and_status(@context.id.to_s, @context.class.name, Reward::STATUS_ACTIVE)
    @referral = Referral.find(params[:id])
    @referral.email_subject = params[:email_subject]
    @referral.email_text = params[:email_text]
    referral_emails = params[:valid_emails]
    referral_emails.each do |email|
      @email_references << @referral.references.build(provider: email)
    end
    @referral.save!
    respond_to do |format|
        format.json {

              render(:json => @email_references)

        }
    end
    end


  def index
    create_reference
    get_all_references
  end

  def referree_register
    @reference = Reference.find_by_short_url_code(params[:short_url_code])
    if @reference
    else
    end
  end

  def update_referree

  end

  def update_referrer_coupon

  end

  def get_all_references
    @references =[]
    @referrals = @current_pseudonym.referrals
    @referrals.each do |referral|
      @references << referral.references
    end
  end

  def create_social_references
    domains = HostUrl.context_hosts(@domain_root_account)
    @domain_url =  "#{HostUrl.protocol}://#{domains.first}/rr/"
    @reference_fb = @referral.references.build(provider: ReferralProvider::FACEBOOK)
    @reference_tw = @referral.references.build(provider: ReferralProvider::TWITTER)
    @reference_li = @referral.references.build(provider: ReferralProvider::LINKEDIN)
    @reference_go = @referral.references.build( provider: ReferralProvider::GOOGLE)
    @reference_gl = @referral.references.build(provider: ReferralProvider::GLOBAL)

  end

  def split_csv_emails(referral_emails)
    emails = []
    referral_emails.split(/,\s*/).each do |email|
      unless email =~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
        @referral.errors.add(:references, "are invalid due to #{email}")
      end
      emails << email
    end
    emails
  end
end
