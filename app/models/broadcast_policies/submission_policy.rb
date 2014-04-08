module BroadcastPolicies
  class SubmissionPolicy
    attr_reader :submission

    def initialize(submission)
      @submission = submission
    end

    def should_dispatch_assignment_submitted_late?
      course.available? &&
      !submission.group_broadcast_submission &&
      just_submitted_late? &&
      submission.submitted? &&
      submission.has_submission? &&
      submission.late?
    end

    def should_dispatch_assignment_submitted?
      course.available? &&
      just_submitted? &&
      submission.submitted? &&
      submission.has_submission? &&
      # don't send a submitted message because we already sent an :assignment_submitted_late message
      !submission.late?
    end

    def should_dispatch_assignment_resubmitted?
      course.available? &&
      submission.submitted? &&
      is_a_resubmission? &&
      submission.has_submission? &&
      # don't send a resubmitted message because we already sent a :assignment_submitted_late message.
      !submission.late?
    end

    def should_dispatch_group_assignment_submitted_late?
      course.available? &&
      submission.group_broadcast_submission &&
      just_submitted_late? &&
      submission.submitted? &&
      submission.late?
    end

    def should_dispatch_submission_graded?
      broadcasting_grades? &&
      (submission.changed_state_to(:graded) || (grade_updated? && graded_recently?))
    end

    def should_dispatch_submission_grade_changed?
      broadcasting_grades? &&
      submission.graded_at &&
      !graded_recently? &&
      grade_updated?
    end

    private
    def broadcasting_grades?
      course.available? &&
      !assignment.muted? &&
      assignment.published? &&
      submission.quiz_submission.nil?
    end

    def assignment
      submission.assignment
    end

    def course
      assignment.context
    end

    def just_submitted?
      (submission.just_created && submission.submitted?) || submission.changed_state_to(:submitted)
    end

    def just_submitted_late?
      (just_submitted? || prior.try(:submitted_at) != submission.submitted_at)
    end

    def prior
      submission.prior_version
    end

    def is_a_resubmission?
      prior.submitted_at &&
      prior.submitted_at != submission.submitted_at
    end

    def grade_updated?
      submission.changed_in_state(:graded, :fields => [:score, :grade])
    end

    def graded_recently?
      submission.assignment_graded_in_the_last_hour?
    end

  end
end
