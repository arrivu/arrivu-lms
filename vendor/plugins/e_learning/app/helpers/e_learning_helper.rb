module ELearningHelper

  def check_e_learning
    unless (@account ||= @domain_root_account).feature_enabled?(:e_learning)
      redirect_to dashboard_redirect_path
    end
  end

  def check_private_e_learning
    if  (@account ||= @domain_root_account).feature_enabled?(:private_e_learning)
      require_user
    end
  end

  def set_e_learning
    @e_learning = true
  end
end
