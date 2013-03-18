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

	it "should accept valid email addresses" do
		correct_mails = %w[user@domain.com user.user@domain.fr.ua test_user@am.ru]
		correct_mails.each do |mail| 
			user = User.new(@attr.merge(:email => mail))
			user.should be_valid
		end
	end

	it "should not accept invalid email addresses" do
		bad_mails = %w[user @domain.com user@domain user@]
		bad_mails.each do |mail|
			user = User.new(@attr.merge(:email => mail))
			user.should_not be_valid
		end
	end

	it "should reject duplicate email addresses" do
		User.create!(@attr)
		duplicated_address = User.new(@attr)
		duplicated_address.should_not be_valid
	end

	it "should reject duplicate email addresses in any cases" do
		User.create!(@attr)
		upper_case_address = @attr[:email].upcase
		duplicated_address = User.new(@attr.merge(:email => upper_case_address))
		duplicated_address.should_not be_valid
	end


end
