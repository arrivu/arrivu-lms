module Elearning
  module AccountControllerExtensions

    def subscribe
      if authorized_action(@account, @current_user, [:manage_account_settings, :manage_storage_quotas])
        @account.settings[:no_students] = params[:no_students]
        @account.settings[:no_teachers] = params[:no_teachers]
        @account.settings[:no_admins] = params[:no_admins]
        @account.settings[:no_courses] = params[:no_courses]
        @account.default_storage_quota_mb = params[:storage]
        @account.settings[:unlimited] = false unless params[:unlimited] == 'true'
        if @account.save!
          render :json => @account.to_json
        else
          render :json => @account.errors ,:status => :bad_request
        end
      end
    end

  end
end