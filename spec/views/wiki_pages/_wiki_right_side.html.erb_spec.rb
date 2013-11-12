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

describe "/wiki_pages/_wiki_right_side" do
  it "should render" do
    group_with_user
    view_context
    page = @group.wiki.wiki_pages.create(:title => "a page",:wiki_type =>"#{WikiPage::WIKI_TYPE_PAGES}")
    assigns[:wiki] = @group.wiki
    assigns[:page] = page
    assigns[:wiki_type] = WikiPage::WIKI_TYPE_PAGES
    assigns[:page].save!
    assigns[:context] = @group
    render :partial => "wiki_pages/wiki_right_side"
    response.should_not be_nil
    response.body.should match("Edit this #{WikiPage::WIKI_TYPE_PAGES}")
    response.body.should match("Delete this #{WikiPage::WIKI_TYPE_PAGES}")
    response.body.should match("Create a #{WikiPage::WIKI_TYPE_PAGES}")
  end
end

