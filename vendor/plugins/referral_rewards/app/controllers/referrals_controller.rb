class ReferralsController < ApplicationController
  before_filter :require_user, :except => [:referree_register,:update_referree]
  before_filter :require_context, :except => [:referree_register,:update_referree]

   def create_reference
     @reward = Reward.find_by_metadata_and_metadata_type_and_status(@context.id.to_s, @context.class.name, Reward::STATUS_ACTIVE)

     if @reward
       @referral = @reward.referrals.build(pseudonym_id: @current_pseudonym.id,email_text: @reward.email_template_txt,email_subject: @reward.email_subject)
       create_social_references
       @referral.save!
     else
       @reward = Reward.find_by_metadata_and_metadata_type_and_status(@domain_root_account.id.to_s, @domain_root_account.class.name, Reward::STATUS_ACTIVE)
       if @reward
         @referral = @reward.referrals.build(pseudonym_id: @current_pseudonym.id,email_subject: @reward.email_subject,email_text: @reward.email_template_txt )
         create_social_references
         @referral.save!
        end
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
    add_crumb("Referrals", named_context_url(@context, :context_referrals_url))
    @active_tab = "Referrals"
    create_reference
    get_all_references
  end

  def referree_register
    @reference = Reference.find_by_short_url_code(params[:short_url_code])
    if @reference
      @referral = @reference.referral
      @reward = @referral.reward
    else
      #The entered short url code is junk so find for account level reward
      #Once account level reward is there we have to look for the referral,referrence
      @reward = Reward.find_by_metadata_and_metadata_type_and_status(@domain_root_account.id.to_s,
                                                                @domain_root_account.class.name, Reward::STATUS_ACTIVE)
      if @reward
        @referral = Referral.find_or_create_by_reward_id_and_pseudonym_id(reward_id: @reward.id,
                                                            pseudonym_id: Account.site_admin.pseudonyms.active.first)
        @reference = Reference.find_or_create_by_referral_id_and_short_url_code_and_provider(referral_id: @referral.id,
                                                                                short_url_code: params[:short_url_code],
                                                                                provider: Reference::SELF)
      end
    end
  end


  def update_referree
    @referree = Referree.create(name: params[:referree][:name],email: params[:referree][:email])
    respond_to do |format|
    if @referree.save!
    @reference = Reference.find(params[:referree][:reference_id])
    @coupon = Coupon.create!(name: "Self Registered",
                              description: "User entered junk url code and registered",
                              how_many: 1,
                              expiration: 1.years.from_now,
                              category_one: "Self",
                              amount_one: 0,
                              percentage_one:0,
                              amount_two:0,
                              percentage_two:0,
                              alpha_mask: alpha_mask,
                              alpha_code: Coupon.generate_alpha_code(alpha_mask),
                              metadata: @reference.id)

    else
      format.html { redirect_to referree_registration_url(@referree) }
      end
    end
end

  def update_referrer_coupon

  end

  def get_all_references
    @references =[]
    @referrals = @current_pseudonym.referrals
    @referrals.each do |referral|
      referral.references.not_in_social.each do |reference|
      @references << reference
        end
    end
    js_env(MY_REFERENCES: @references.to_json)
  end

  def create_social_references
    domains = HostUrl.context_hosts(@domain_root_account)
    @domain_url =  "#{HostUrl.protocol}://#{domains.first}/rr/"
    @reference_fb = @referral.references.build(provider: Reference::FACEBOOK)
    @reference_tw = @referral.references.build(provider: Reference::TWITTER)
    @reference_li = @referral.references.build(provider: Reference::LINKEDIN)
    @reference_go = @referral.references.build( provider: Reference::GOOGLE)
    @reference_gl = @referral.references.build(provider: Reference::GLOBAL)

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
