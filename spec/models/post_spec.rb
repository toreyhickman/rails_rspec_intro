require 'spec_helper'

describe Post do

  let(:post) { Post.create(title: "man from the boondocks", content: "lorem") }

  describe "#initialize" do
    it "title should be automatically titleized before save" do
      post.title.should eq "man from the boondocks".titleize
    end

    it "post should be unpublished by default" do
      post.is_published.should eq false
    end

    # a slug is an automaticaly generated url-friendly
    # version of the title
    it "slug should be automatically generated" do
      post = Post.new
      post.title   = "New post!"
      post.content = "A great story"
      post.slug.should be_nil
      post.save

      post.slug.should eq "new-post"
    end
  end
end
