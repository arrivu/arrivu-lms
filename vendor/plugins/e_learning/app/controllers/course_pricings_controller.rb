class CoursePricingsController < ApplicationController
  before_filter :require_context
  include CoursePricingsHelper
 def create
  @coursepricing=CoursePricing.new(course_id:params['course_id'],start_at:params['start_date'],end_at:params['end_date'],price:params['course_price'])
  @coursepricing.account_id=Course.find_by_account_id(@context.account_id).id
  course_ids=CoursePricing.where("course_id=?",@coursepricing.course_id)
  respond_to do |format|
  if(@coursepricing.start_at).nil?
    format.json{render :json =>  "Specify Start Date", :status =>:error}
  elsif (@coursepricing.end_at).nil?
    format.json{render :json =>  "Specify End Date", :status =>:error}
  elsif (@coursepricing.price).nil?
    format.json{render :json =>  "Specify Price", :status =>:error}
  elsif nooverlap?(course_ids,@coursepricing.start_at,@coursepricing.end_at)
    if(@coursepricing.start_at>=Date.today)
      if(@coursepricing.end_at>=@coursepricing.start_at)
        if @coursepricing.save
          format.json { render :json => @coursepricing.to_json}
        else
          format.json{render :json =>  "Price not saved successfully", :status =>:error}
        end
      else
        format.json { render :json => "End date should be greater than Start date", :status => :error }
      end
    else
      format.json { render :json => "Start Date should be greater than of equal current date.", :status => :error }
    end
  else
    format.json { render :json => "Price Details already defined for the date range", :status => :error }
  end
  end
 end

 def edit
    @course_pricings = CoursePricing.find(params[:id])
 end

 def update
   @course_pricings = CoursePricing.find(params[:id])
   course_ids=CoursePricing.where("course_id=?",@course_pricings.course_id)
   respond_to do |format|
     if(params['start_date']) == ""
         format.json { render :json => "Specify Start date", :status => :error  }
       elsif (params['end_date']) == ""
         format.json { render :json => "Specify End date", :status => :error }
       elsif (params['course_price']) == ""
         format.json { render :json => "Specify Price", :status => :error }
       elsif params['start_date'] == @course_pricings.start_at.to_s && params['end_date'] == @course_pricings.end_at.to_s
         @course_pricings.update_attributes(course_id:params['course_id'],price:params['course_price'])
         format.json { render :json => @course_pricings.to_json}
       elsif nooverlap?(course_ids,@course_pricings.start_at,@course_pricings.end_at)
         if(@course_pricings.start_at>=Date.today)
           if(@course_pricings.end_at>=@course_pricings.start_at)
             if @course_pricings.update_attributes(course_id:params['course_id'],start_at:params['start_at'],end_at:params['end_at'],price:params['course_price'])
               format.json { render :json => @course_pricings.to_json}
             else
               format.json { render :json => "Price not saved successfully", :status => :error }
             end
           else
             format.json { render :json => "End date should be greater than Start date", :status => :error }
           end
         else
           format.json { render :json => "Start Date should be greater than of equal current date.", :status => :error }
         end
       else
         format.json { render :json => "Price Details already defined for the date range", :status => :error }
       end
     end
    end

 def index
  respond_to do |format|
  @course_pricings = @context.course_pricings
      format.json {render :json => @course_pricings.map(&:attributes).to_json}
    end
 end

  def destroy
    @delete_pricing =CoursePricing.find(params[:id])
    respond_to do |format|
      if @delete_pricing.destroy
        format.json { render :json => @delete_pricing }
      else
        format.json { render :json => @delete_pricing.errors.to_json, :status => :bad_request }
      end
    end
  end

end