module HomePagesHelper

  def check_e_learning
    unless (@account ||= @domain_root_account).feature_enabled?(:e_learning)
      redirect_to dashboard_redirect_path
    end
  end

end
