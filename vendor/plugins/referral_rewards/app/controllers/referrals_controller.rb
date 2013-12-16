class ReferralsController < ApplicationController

  before_filter :require_context
  add_crumb(proc { t('#crumbs.referrals', "Referrals")}) { |c| c.send :named_context_url, c.instance_variable_get("@context"), :context_referrals_url }
  before_filter { |c| c.active_tab = "Referrals" }

  #def new
  #  @reward = Reward.find_by_metadata(@context.id.to_s)
  #  if @reward
  #    @referral = @reward.referrals.where(:pseudonym_id => @current_pseudonym.id)
  #
  #    if @referral.empty?
  #      @referral = @reward.referrals.build(pseudonym_id: @current_pseudonym.id,email_text: @reward.email_template_txt,email_subject: @reward.email_subject)
  #      create_references
  #      @referral.save!
  #    else
  #      flash[:notice] = t(:referral, "%{name} Course is already Refered", :name => @context.name)
  #      redirect_to course_path(@context)
  #    end
  #  else
  #  #flash[:info] = "There is no reward"
  #    flash[:notice] = t(:reward, "There is no Reward")
  #    redirect_to course_path(@context)
  #  end
  #end

  #def update
  #  @referral = Referral.find(params[:id])
  #  if @referral.update_attributes(params[:referral])
  #    #flash[:success] =t(:referral_update_success,"Successfully Updated Referrals.")
  #    redirect_to course_path
  #  end
  #end

   def create_reference
     @reward = Reward.find_by_metadata_and_metadata_type_and_status(@context.id.to_s, @context.class.name, Reward::STATUS_ACTIVE)

     if @reward
       @referral = @reward.referrals.build(pseudonym_id: @current_pseudonym.id,email_text: @reward.email_template_txt,email_subject: @reward.email_subject)
       create_social_references
       @referral.save!
     end
     js_env(COURSE_REFERRAL: @referral.map(&:attributes).to_json)
   end

  def create_email_referrals
    @reward = Reward.find_by_metadata_and_metadata_type_and_status(@context.id.to_s, @context.class.name, Reward::STATUS_ACTIVE)
    @referral = Referral.find(params[:referral][:referral_id])
    @referral.email_subject = params[:referral][:email_subject]
    @referral.email_text = params[:referral][:email_text]
    referral_emails = params[:referral][:referral_emails]
    emails =  split_csv_emails(referral_emails)
    emails.each do |email|
      reference = @referral.references.build(provider: email)
    end
      if @referral.errors.any?
        render course_referrals_path
      else
        redirect_to course_referrals_path
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
