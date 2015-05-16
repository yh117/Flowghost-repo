require 'spec_helper'

describe "Static pages" do

  describe "Home page" do

    it "should have the content 'Welcome to FlowGhost'" do
      visit '/home/index'
      expect(page).to have_content('Welcome to FlowGhost')
    end
  end

    describe "About page" do

    it "should have the content 'About'" do
      visit '/home/about'
      expect(page).to have_content('About')
    end
  end
end