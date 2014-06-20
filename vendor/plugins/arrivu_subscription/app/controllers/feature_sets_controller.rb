class FeatureSetsController < ApplicationController
  before_filter :check_admin_user
  def index
    @feature_set = FeatureSet.new
    @feature_sets = FeatureSet.all
  end

  def create
    @feature_set = FeatureSet.new(params[:feature_set])
    if @feature_set.save
      flash[:notice] = "Successfully created FeatureSet."
      redirect_to feature_sets_path
    else
      @feature_sets = FeatureSet.all
      render :action => 'index'
    end
  end

  def edit
    @feature_set = FeatureSet.find(params[:id])
  end

  def update
    @feature_set = FeatureSet.find(params[:id])
    if @feature_set.update_attributes(params[:feature_set])
      flash[:notice] = "Successfully updated FeatureSet."
      redirect_to feature_sets_path
    else
      render :action => 'edit'
    end
  end

  def destroy
    @feature_set = FeatureSet.find(params[:id])
    @feature_set.destroy
    flash[:notice] = "Successfully destroyed FeatureSet."
    redirect_to feature_sets_path
  end

end
