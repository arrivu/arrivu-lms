require File.expand_path(File.dirname(__FILE__) + '/common')

describe "Navigating to wiki pages" do
  it_should_behave_like "in-process server selenium tests"

  describe "Navigation" do
    before do
      account_model
      @account.settings[:enable_draft] = true
      @account.save!
      course_with_teacher_logged_in :account => @account
    end

    it "navigates to the wiki pages edit page from the show page" do
      wikiPage = @course.wiki.wiki_pages.create!(:title => "Foo",:wiki_type => 'wiki')
      edit_url = course_edit_named_page_url(@course, wikiPage.wiki_type,wikiPage.url)
      @front = @course.wiki.front_page
      @front.set_as_front_page!
      get course_named_page_path(@course, wikiPage.wiki_type,wikiPage.url)

      #get course_named_page_path(@course,:course_id => @course.id,:type => 'wiki',:wiki_page_id => wikiPage.id)

      f(".edit-wiki").click

      keep_trying_until { driver.current_url.should == edit_url }
    end
  end

  describe "Permissions" do
    before do
      course_with_teacher
    end

    it "displays public content to unregistered users" do
      Canvas::Plugin.register(:kaltura, nil, :settings => {'partner_id' => 1, 'subpartner_id' => 2, 'kaltura_sis' => '1'})

      @course.is_public = true
      @course.save!

      title = "foo"
      wikiPage = @course.wiki.wiki_pages.create!(:title => title, :body => "bar",:wiki_type => 'wiki')

      get "/courses/#{@course.id}/wiki/#{title}"
      f('#wiki_body').should_not be_nil
    end
  end
end
