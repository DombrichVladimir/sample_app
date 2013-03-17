require 'spec_helper'

describe User do
	before(:each) do
		@attr = { :name => "Petya Kakashkin", :email => "kakashko@millisoft.com" }
	end

	it "should create a new instance given valid attributes" do
		User.create!(@attr)
	end

	it "should require a name" do
		no_name_user = User.new(@attr.merge(:name => ""))
		no_name_user.should_not be_valid
	end

	it "should require an email" do
		no_email_user = User.new(@attr.merge(:email => ""))
		no_email_user.should_not be_valid
	end

	it "should reject names that are too long" do
		bad_name = "a" * 51
		too_long_name_user = User.new(@attr.merge(:name => bad_name))
		too_long_name_user.should_not be_valid
	end
end
