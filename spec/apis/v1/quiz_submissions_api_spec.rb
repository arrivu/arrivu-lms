#
# Copyright (C) 2013 Instructure, Inc.
#
# This file is part of Canvas.
#
# Canvas is free software: you can redistribute it and/or modify it under
# the terms of the GNU Affero General Public License as published by the Free
# Software Foundation, version 3 of the License.
#
# Canvas is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Affero General Public License for more
# details.
#
# You should have received a copy of the GNU Affero General Public License along
# with this program. If not, see <http://www.gnu.org/licenses/>.
#

require File.expand_path(File.dirname(__FILE__) + '/../api_spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../file_uploads_spec_helper')

describe QuizSubmissionsApiController, :type => :integration do

  context "quiz submissions file uploads" do
    before do
      course_with_student_logged_in :active_all => true
      @quiz = Quiz.create!(:title => 'quiz', :context => @course)
      @quiz.did_edit!
      @quiz.offer!

      s = @quiz.generate_submission(@student)
    end

    it_should_behave_like "file uploads api"

    def preflight(preflight_params)
      api_call :post,
        "/api/v1/courses/#{@course.id}/quizzes/#{@quiz.id}/quiz_submissions/self/files",
        {:controller => "quiz_submissions_api", :action => "create_file", :format => "json", :course_id => @course.to_param, :quiz_id => @quiz.to_param},
        preflight_params
    end

    def has_query_exemption?
      false
    end
  end

end
