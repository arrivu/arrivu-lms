class AuthenticationController < ApplicationController

  def create
    auth = request.env["omniauth.auth"]
    # Try to find authentication first
    authentication = OmniauthAuthentication.find_by_provider_and_uid(auth['provider'], auth['uid'])
    if authentication
      if authentication.user.workflow_state == "active"
      reset_session_for_login
      @pseudonym_session = @domain_root_account.pseudonym_sessions.new(authentication.user)
      @pseudonym = @domain_root_account.pseudonyms.custom_find_by_unique_id(authentication.user.email)
      @pseudonym_session=@domain_root_account.pseudonym_sessions.create!(@pseudonym, false)
      successful_login(@pseudonym_session)
      else
        flash[:notice] = "Your account not yet processed,please contact admin"
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
      @omniauth_authentication= OmniauthAuthentication.create!(:provider=>auth['provider'] ,
                                                              :token=>auth[:credentials][:token],
                                                              :uid=>auth['uid'], :user_id=>@user.id)
    end
  end

  def successful_login(pseudonym)
    @current_pseudonym = pseudonym
    flash[:notice] = "You are now logged in"
    redirect_to root_url
  end
  def un_successful_login
    flash[:info] = "Account is queued for verification,Once it completed the admin will contact you ."
    redirect_to root_url
  end



end
