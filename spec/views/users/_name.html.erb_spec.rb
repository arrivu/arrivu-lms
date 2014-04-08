#
# Copyright (C) 2011 Instructure, Inc.
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

require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../views_helper')

describe "/users/name" do
  it "should allow deletes for unmanagaged pseudonyms with correct privileges" do
    account_admin_user :account => Account.default
    course_with_student :account => Account.default
    view_context(Account.default, @admin)
    assigns[:user] = @student
    assigns[:enrollments] = []
    render :partial => "users/name"
    response.body.should =~ /Delete from #{Account.default.name}/
  end

  it "should allow deletes for managaged pseudonyms with correct privileges" do
    account_admin_user :account => Account.default
    course_with_student :account => Account.default
    managed_pseudonym(@student, :account => account_model)
    view_context(Account.default, @admin)
    assigns[:user] = @student
    assigns[:enrollments] = []
    render :partial => "users/name"
    response.body.should =~ /Delete from #{Account.default.name}/
  end

  it "should not allow deletes for managed pseudonyms without correct privileges" do
    @admin = user :account => Account.default
    course_with_student :account => Account.default
    managed_pseudonym(@student, :account => account_model)
    view_context(Account.default, @admin)
    assigns[:user] = @student
    assigns[:enrollments] = []
    render :partial => "users/name"
    response.body.should_not =~ /Delete from #{Account.default.name}/
  end

  it "should not allow deletes for unmanaged pseudonyms without correct privileges" do
    @admin = user :account => Account.default
    course_with_student :account => Account.default
    view_context(Account.default, @admin)
    assigns[:user] = @student
    assigns[:enrollments] = []
    render :partial => "users/name"
    response.body.should_not =~ /Delete from #{Account.default.name}/
  end
end
