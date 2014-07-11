module CoursePricingsHelper
  def nooverlap?(course_pricings,start_date,end_date)
    course_pricings.each do |course_price|
      start_date1=Date.parse(course_price.start_at.to_s)
      end_date1=Date.parse(course_price.end_at.to_s)
      start_date=Date.parse(start_date.to_s)
      end_date=Date.parse(end_date.to_s)
      if start_date1 == start_date && end_date1 == end_date
        return unless((start_date1..end_date1).to_a & (start_date..end_date).to_a).empty?
      end
    end
  end
end