#
# Copyright (C) 2012 Instructure, Inc.
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

require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

describe 'DataFixup::ReintroduceDeletedEntriesToUnreadCount' do
  it "should mark existing deleted entries as read" do
    course_with_teacher(:active_user => true, :active_course => true)
    @student1 = student_in_course(:active_all => true).user
    @student2 = student_in_course(:active_all => true).user

    @topic = @course.discussion_topics.create!(:title => "hi", :message => "there", :user => @teacher)
    @entry1 = @topic.discussion_entries.create!(:message => "it's me", :user => @teacher)
    @entry2 = @topic.discussion_entries.create!(:message => "it's me again", :user => @teacher)
    @entry3 = @topic.discussion_entries.create!(:message => "one more", :user => @teacher)

    @topic2 = @course.discussion_topics.create!(:title => "hi again", :message => "blah", :user => @teacher)
    @entry2_1 = @topic2.discussion_entries.create!(:message => "yo", :user => @teacher)
    @entry2_1.change_read_state("read", @student1)

    @entry1.change_read_state("read", @student1)
    @entry2.change_read_state("read", @student2)
    @entry2.destroy

    # run the previous migration, which deletes read status for deleted messages
    DataFixup::ExcludeDeletedEntriesFromUnreadCount.run
    @topic.unread_count(@student2).should == 2
    DiscussionEntryParticipant.find_by_user_id_and_discussion_entry_id(@student2.id, @entry2.id).should be_nil

    # now the new migration, which marks existing deleted entries as read for all
    DataFixup::ReintroduceDeletedEntriesToUnreadCount.run
    @topic.unread_count(@student2).should == 2
    DiscussionEntryParticipant.find_by_user_id_and_discussion_entry_id(@student2.id, @entry2.id).should be_present
    @topic.unread_count(@teacher).should == 0
    @topic2.unread_count(@teacher).should == 0
    @topic.unread_count(@student1).should == 1
    @topic2.unread_count(@student1).should == 0
  end
end
