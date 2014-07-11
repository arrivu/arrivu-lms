class CoursePricingsController < ApplicationController
  before_filter :require_context
  include CoursePricingsHelper
 def create
  @coursepricing=CoursePricing.new(course_id:params['course_id'],start_at:params['start_date'],end_at:params['end_date'],price:params['course_price'])
  @coursepricing.account_id=Course.find_by_account_id(@context.account_id).id
  course_pricings=CoursePricing.where("course_id=?",@coursepricing.course_id)
  respond_to do |format|
  if(@coursepricing.start_at).nil?
    format.json{render :json =>  "Specify Start Date", :status =>:error}
  elsif (@coursepricing.end_at).nil?
    format.json{render :json =>  "Specify End Date", :status =>:error}
  elsif (@coursepricing.price).nil?
    format.json{render :json =>  "Specify Price", :status =>:error}
  elsif nooverlap?(course_pricings,@coursepricing.start_at.to_date(),@coursepricing.end_at.to_date())
    if(@coursepricing.start_at.to_date() >= Date.today)
      if(@coursepricing.end_at.to_date() >= @coursepricing.start_at.to_date())
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
   course_pricings = CoursePricing.where("course_id=?",@course_pricings.course_id)
   updated_start_date = params['start_date'].to_date()+1.day
   updated_end_date = params['end_date'].to_date()+1.day
   respond_to do |format|
     if(params['start_date']) == ""
         format.json { render :json => "Specify Start date", :status => :error  }
       elsif (params['end_date']) == ""
         format.json { render :json => "Specify End date", :status => :error }
       elsif (params['course_price']) == ""
         format.json { render :json => "Specify Price", :status => :error }
       elsif @course_pricings.price != params['course_price'] && @course_pricings.start_at.to_date() == updated_start_date && @course_pricings.end_at.to_date() == updated_end_date
         @course_pricings.update_attributes(course_id:params['course_id'],start_at:params['start_date'],end_at:params['end_date'],price:params['course_price'])
         format.json { render :json => @course_pricings.to_json}
       elsif nooverlap?(course_pricings,updated_start_date,updated_end_date)
         if(params['start_date'].to_date() >= Date.today)
           if(params['end_date'].to_date() >= params['start_date'].to_date())
             if @course_pricings.update_attributes(course_id:params['course_id'],start_at:params['start_date'],end_at:params['end_date'],price:params['course_price'])
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
     @course_price = []
      #format.json {render :json => @course_pricings.map(&:attributes).to_json}
      @course_pricings.each do |course_price|
        @course_pricing_json =   api_json(course_price, @current_user, session, API_USER_JSON_OPTS).tap do |json|
         json[:price_id] = course_price.id
         json[:course_id] = course_price.course_id
         json[:price]     = course_price.price
         json[:start_at]  = course_price.start_at.to_date()
         json[:end_at] =  course_price.end_at.to_date()
        end
        @course_price << @course_pricing_json
      end
     format.json {render :json => @course_price}
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