require 'spec_helper'

describe 'Admin' do
  context "on admin homepage" do
    before do
      Post.create(:title => "Cat", :content => "lorem ipsum")
      Post.create(:title => "Dog", :content => "blah blah")

      page.driver.browser.authorize('geek', 'jock')
      visit admin_posts_url
    end

    it "can see a list of recent posts" do
      page.should have_content "Cat"
      page.should have_content "Dog"
    end

    it "can edit a post by clicking the edit link next to a post" do
      post = Post.last
      page.find('tr', :text => post.title).click_link('Edit')
      current_url.should eq edit_admin_post_url(post)
    end

    it "can delete a post by clicking the delete link next to a post" do
      post = Post.last
      expect { page.find('tr', :text => post.title).click_link('Delete') }.to change { Post.all.count }.by(-1)
    end
  end

  context "on admin new post page" do
    it "can create a new post and view it" do
      visit new_admin_post_url
      expect {
        fill_in 'post_title',   with: "Hello world!"
        fill_in 'post_content', with: "Lorem ipsum dolor sit amet, consectetuer adipiscing elit, sed diam nonummy nibh euismod tincidunt ut laoreet dolore magna aliquam erat volutpat."
        page.check('post_is_published')
        click_button "Save"
      }.to change(Post, :count).by(1)

      page.should have_content "Published: true"
      page.should have_content "Post was successfully saved."
    end
  end

  context "editing post" do
    it "can mark an existing post as unpublished" do
      post = Post.create(:title => "CatDog", :content => "moar content", :is_published => true)
      visit edit_admin_post_url(post)
      uncheck('post_is_published')
      click_button('Save')
      page.should have_content "Published: false"
    end
  end

  context "on post show page" do

    before do
      @post = Post.create(:title => "Test", :content => "testing testing")
      visit admin_post_url(@post)
    end

    it "can visit a post show page by clicking the title" do
      click_link(@post.title)
      current_url.should eq post_url(@post)
    end

    it "can see an edit link that takes you to the edit post path" do
      find_link('Edit post')[:href].should eq edit_admin_post_url(@post)
    end

    it "can go to the admin homepage by clicking the Admin welcome page link" do
      find_link('Admin welcome page')[:href].should eq admin_posts_url
    end

  end
end
