require 'spec_helper'

describe User do
	
	before(:each) do
		@attr = { 
			:name => "Petya Kakashkin", 
			:email => "kakashko@millisoft.com", 
			:password => "mysecurepass111",
			:password_confirmation => "mysecurepass111"
		 }
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

	describe "password validations" do

		it "should require a password" do
			user = User.new(@attr.merge(:password => "", :password_confirmation => ""))
			user.should_not be_valid
		end

		it "should require a matching password confirmation" do
			user = User.new(@attr.merge(:password_confirmation => "invalid"))
			user.should_not be_valid
		end

		it "should reject short passwords" do
			user = User.new(@attr.merge(:password => "11", :password_confirmation => "11"))
			user.should_not be_valid
		end

		it "should reject long passwords" do
			long_pass = "a" * 51
			user = User.new(@attr.merge(:password => long_pass, :password_confirmation => long_pass))
			user.should_not be_valid
		end

	end

	describe "password encryption" do

		before(:each) do
			@user = User.create!(@attr)
		end

		it "should have an encrypted password attribute" do
			@user.should respond_to(:encrypted_password)
		end

		it "should set the encrypted password" do
			@user.encrypted_password.should_not be_blank
		end

		it "should be true if the passwords match" do
			@user.has_password?(@attr[:password]).should be_true
		end

		it "should be false if the passwords don't match" do
			@user.has_password?("invalid").should be_false
		end

		it "should return nil on email/password mismatch" do
			wrong_password_user = User.authenticate(@attr[:email], "password")
			wrong_password_user.should be_nil
		end

		it "should return nil for an email address with no user" do
			nonexistent_user = User.authenticate("bad@domen.ru", @attr[:password])
			nonexistent_user.should be_nil
		end

		it "should return the user on email/password match" do
			mathcing_user = User.authenticate(@attr[:email], @attr[:password])
			mathcing_user.should == @user
		end

	end

end
