class TeachersController < ApplicationController


  def show
    @teacher_detail =  User.find(@teachers.user_id)
  end
end
