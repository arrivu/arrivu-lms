class AuthenticationController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    provider = set_provider(auth)
    pseudonyms=@domain_root_account.pseudonyms.active.custom_find_by_unique_id(auth[:info][:email])
    unless pseudonyms.nil?
    @user= pseudonyms.user
    @authentication=OmniauthAuthentication.find_by_user_id(@user.id)
    end
    # Try to find authentication first
      if !!@authentication
        if @authentication.provider == provider
          if @authentication.user.workflow_state == "active"
            reset_session_for_login
            @pseudonym_session = @domain_root_account.pseudonym_sessions.new(@authentication.user)
            @pseudonym = @domain_root_account.pseudonyms.custom_find_by_unique_id(@authentication.user.email)
            @pseudonym_session=@domain_root_account.pseudonym_sessions.create!(@pseudonym, false)
            successful_login(@pseudonym_session)
          else
            activation_pending
          end
        else
          flash[:error] = " Sorry,You have already registred with #{@authentication.provider} account."
          redirect_to root_url
        end
      else
      password=(0...10).map{ ('a'..'z').to_a[rand(26)] }.join
      @user = User.create!(:name => auth[:info][:name],
                           :sortable_name => auth[:info][:name],
                           :avatar_image_url=>auth[:info][:image],
                           :avatar_image_source=>auth['provider'],
                           :avatar_image_updated_at => Time.now)
      @user.workflow_state = 'inactive'
      @pseudonym = @user.pseudonyms.create!(:unique_id => auth[:info][:email],
                                            :account => @domain_root_account)
      @user.communication_channels.create!(:path => auth[:info][:email]) { |cc| cc.workflow_state = 'active' }
      @user.save!
      @pseudonym.save!
      provider = set_provider(auth)
      @omniauth_authentication= OmniauthAuthentication.create!(:provider => provider,
                                                              :token => auth[:credentials][:token],
                                                              :uid => auth['uid'], :user_id=>@user.id)
      un_successful_login
    end
 end

  def successful_login(pseudonym)
    @current_pseudonym = pseudonym
    flash[:notice] = "You are now logged in"
    redirect_to root_url
  end

  def un_successful_login
    reset_session_for_login
    @current_pseudonym=nil
    flash[:error] = "Account is queued for verification,Once it completed the admin will contact you ."
    redirect_to root_url
  end

  def activation_pending
    flash[:error] = "Your account is not yet processed,Once it completed you will get a activation mail ."
    redirect_to root_url
  end

  def auth_failure
    flash[:error] = params[:message]
    redirect_to root_url
  end

 def set_provider(auth)
   if auth['provider'] == "google_oauth2"
     provider = "Google"
   else
     provider = auth['provider']
   end
 end

end
