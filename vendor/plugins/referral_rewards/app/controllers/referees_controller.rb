class RefereesController < ApplicationController

  def referee_register
     @reference = Reference.find_by_short_url_code(params[:short_url_code])
     if @reference

     else

     end

  end

  def referee_registration_complete

  end

end