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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/messages_helper')

describe 'enrollment_notification.email' do
  it "should render" do
    course_with_student(:active_all => true)
    @object = @enrollment
    @enrollment.context.should_not be_nil
    generate_message(:enrollment_notification, :email, @object)
  end

  it "should render for creation_pending student" do
    course_with_student(:active_course => true, :active_enrollment => true)
    @student.communication_channels.create!(:path => 'jacob@instructure.com')
    @object = @enrollment
    @enrollment.context.should_not be_nil
    generate_message(:enrollment_notification, :email, @object)
  end
end
