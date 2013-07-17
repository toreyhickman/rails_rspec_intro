require 'spec_helper'

describe 'User' do
  context "on homepage" do
    before do
      @post = Post.create(:title => "New post", :content => "Awesome content")
      visit root_path
    end

    it "sees a list of recent posts titles" do
      page.should have_content(@post.title)
    end

    it "can not see bodies of the recent posts" do
      page.should_not have_content(@post.content)
    end

    it "can click on titles of recent posts and should be on the post show page" do
      click_link(@post.title)
      current_url.should eq post_url(@post)
    end

    it "can not see the edit link" do
      page.should_not have_css('a[href="' + edit_admin_post_url(@post) + '"]')
    end

    it "can not see the delete link" do
      page.should_not have_css('a[href="' + admin_post_url(@post) + '"][data-method="delete"]')
    end
  end

  context "post show page" do

    before do
      @post = Post.create(:title => "New post", :content => "Awesome content")
      visit post_url(@post)
    end

    it "sees title and body of the post" do
      page.should have_content(@post.title)
      page.should have_content(@post.content)
    end

    it "can not see the edit link" do
      page.should_not have_css('a[href="' + edit_admin_post_url(@post) + '"]')      # given a user and post(s)
    end

    it "can not see the published flag" do
      page.should_not have_content("Published:")
    end

    it "can not see the Admin homepage link" do
      page.should_not have_css('a[href="' + admin_posts_url + '"]')
    end
  end
end
