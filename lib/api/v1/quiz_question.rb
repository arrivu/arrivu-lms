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

module Api::V1::QuizQuestion
  include Api::V1::Json

  API_ALLOWED_QUESTION_OUTPUT_FIELDS = {
    :only => %w(
      id
      quiz_id
      position
      regrade_option
      assessment_question_id
      quiz_group_id
    )
  }

  API_ALLOWED_QUESTION_DATA_OUTPUT_FIELDS = %w(
    question_name
    question_type
    question_text
    points_possible
    correct_comments
    incorrect_comments
    neutral_comments
    answers
    variables
    formulas
    matches
    matching_answer_incorrect_matches
  )

  def questions_json(questions, user, session, context = nil, includes = [], censored = false)
    questions.map do |question|
      question_json(question, user, session, context, includes, censored)
    end
  end

  def question_json(question, user, session, context = nil, includes = [], censored = false)
    hsh = api_json(question, user, session, API_ALLOWED_QUESTION_OUTPUT_FIELDS) do |json, q|
      API_ALLOWED_QUESTION_DATA_OUTPUT_FIELDS.each do |field|
        json.send("#{field}=", q.question_data[field])
      end
    end

    if includes.include?(:assessment_question)
      hsh[:assessment_question] = api_json(question.assessment_question, user, session)

      censor(hsh[:assessment_question][:question_data]) if censored
    end

    # Remove the answer weights if we're censoring the data for student access;
    # the answer weights denote the correct answer !!!!!
    censor(hsh) if censored

    hsh
  end

  private

  # Delete sensitive question data that students shouldn't get to see.
  #
  # @param [Object] question_data
  #   The question data record to censor. This would either be the serialized
  #   quiz_question or the question_data field in a serialized assessment
  #   question.
  def censor(question_data)
    question_data[:answers].each do |record|
      record.delete(:weight)
    end
  end

end
