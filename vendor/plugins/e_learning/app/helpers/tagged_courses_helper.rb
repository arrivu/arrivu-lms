module TaggedCoursesHelper

  def price_course(course)
    @course_pricing = CoursePricing.where('course_id = ? AND DATE(?) BETWEEN start_at AND end_at', course.id, Date.today).first
    unless @course_pricing.nil?
      course_price = @course_pricing.price
    else
      course_price = ""
    end
  end


end
