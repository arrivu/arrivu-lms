namespace :db do

  task add_account: :environment do


    if (ENV['CANVAS_LMS_ACCOUNT_NAME'] || "").empty?
      require 'highline/import'

      if !Rails.env.test?
        name = ask("Enter  Account name > ") { |q| q.echo = true }
        option = ask("You want to Disable Kaltura ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          kultura_flag = true
        else
          kultura_flag = false
        end
        option = ask("You want to Disable Big Blue Button ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          bbb_flag = true
        else
          bbb_flag = false
        end
        option = ask("You want to Disable Grade ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          grade_flag = true
        else
          grade_flag = false
        end
        option = ask("You want to Disable Outcomes ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          outcome_flag = true
        else
          outcome_flag = false
        end
        option = ask("You want to Disable course content import ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          course_import_flag = true
        else
          course_import_flag = false
        end
        option = ask("You want to Disable course content export ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          course_export_flag = true
        else
          course_export_flag = false
        end
        option = ask("You want to Enable Private Course licence ? (y/n) > ") { |q| q.echo = true }
        if option == "y"
          private_course_flag = true
        else
          private_course_flag = false
        end

        @account_domain_mapping = AccountDomainMapping.find_by_domain_name(name)
        unless @account_domain_mapping
          @account = Account.new
          @account.name = name
          @account.settings[:Sublime_kaltura_disable]= kultura_flag
          @account.settings[:Sublime_bbb_disable]= bbb_flag
          @account.settings[:Sublime_grade_disable]= grade_flag
          @account.settings[:Sublime_outcomes_disable]= outcome_flag
          @account.settings[:Sublime_course_import_disable]= course_import_flag
          @account.settings[:Sublime_course_export_disable]= course_export_flag
          @account.settings[:private_license_enable]= course_export_flag
          puts "Creating Account #{name}... "
          account_to_domain_mapping = @account.build_account_domain_mapping(domain_name: @account.name,workflow_state: 'active')
          @account.save!

          #now add the siteAdmin account admin to this account admin
          site_admin_ac_admin_user = Account.site_admin.account_users.first
          #@account.add_user(site_admin_ac_admin_user.user, 'SiteAdmin')
          #@account.save!
          #
          #puts "added the site-admin to the list of account admins"
        else
          puts "Account Already Exists"
        end
      end
    end

    def create_admin_user(email, password)
      begin
        pseudonym = @account.pseudonyms.active.custom_find_by_unique_id(email)
        puts "#{pseudonym}"
        user = pseudonym ? pseudonym.user : User.create!(:name => email,
                                                         :sortable_name => email)
        puts "#{user.name} user created"
        user.register! unless user.registered?

        unless pseudonym
          # don't pass the password in the create call, because that way is extra
          # picky. the admin should know what they're doing, and we'd rather not
          # fail here.
          # puts "#{email}"
          pseudonym = user.pseudonyms.create!(:unique_id => email,
                                              :password => "validpassword", :password_confirmation => "validpassword",
                                              :account => @account )
          user.communication_channels.create!(:path => email) { |cc| cc.workflow_state = 'active' }
        end
        # set the password later.
        pseudonym.password = pseudonym.password_confirmation = password
        unless pseudonym.save
          raise pseudonym.errors.first.join " " if pseudonym.errors.size > 0
          raise "unknown error saving password"
        end
        @account.add_user(user, 'AccountAdmin')
        user
      rescue Exception => e
        STDERR.puts "Problem creating administrative account, please try again:{#e.mesaage}\n#{e.backtrace} "
        nil
      end
    end

    user = nil
    if !(ENV['CANVAS_LMS_ADMIN_EMAIL'] || "").empty? && !(ENV['CANVAS_LMS_ADMIN_PASSWORD'] || "").empty?
      user = create_admin(ENV['CANVAS_LMS_ADMIN_EMAIL'], ENV['CANVAS_LMS_ADMIN_PASSWORD'])
    end

    unless user
      require 'highline/import'

      !Rails.env.test?

      while true do
        email = ask("What email address will the site administrator account use? > ") { |q| q.echo = true }
        email_confirm = ask("Please confirm > ") { |q| q.echo = true }
        #email = "beacon@beacon.com"
        #email_confirm = "beacon@beacon.com"
        break if email == email_confirm
      end

      while true do
        password = ask("What password will the site administrator use? > ") { |q| q.echo = "*" }
        password_confirm = ask("Please confirm > ") { |q| q.echo = "*" }
        #password = "123456789"
        #password_confirm = "123456789"
        break if password == password_confirm
      end

      create_admin_user(email, password)
      puts "Successfully created admin user with email: #{email}, password: #{password} for account: #{@account.name}"
    end
  end

  task remove_account: :environment do
    require 'highline/import'
    puts "This task will remove the account user from the root account"
    puts "------------------------------------------------------------"
    name = ask("Enter  Account name to remove > ") { |q| q.echo = true }
    account_domain_mapping = AccountDomainMapping.find_by_domain_name(name)
    @account = account_domain_mapping.account
    if @account == nil
      puts "The entered account is invalid"
    else
      puts "Removing..."
      site_admin_ac_admin_user = Account.site_admin.account_users.first
      AccountUser.where("account_id = ? and user_id = ?" ,@account.id ,site_admin_ac_admin_user.id).destroy_all
      UserAccountAssociation.where("account_id = ? and user_id = ?" ,@account.id ,site_admin_ac_admin_user.id).destroy_all
      puts "Account #{name} removed from root account "

    end

  end

  task update_account: :environment do
    require 'highline/import'
    puts "This task will merge the account user from the root account"
    puts "------------------------------------------------------------"
    name = ask("Enter  Account name to merge > ") { |q| q.echo = true }
    account_domain_mapping = AccountDomainMapping.find_by_domain_name(name)
    @account = account_domain_mapping.account
    if @account == nil
      puts "The entered account is invalid"
    else
      puts "Merging..."
      site_admin_ac_admin_user = Account.site_admin.account_users.first
      @account.add_user(site_admin_ac_admin_user.user, 'SiteAdmin')
      puts "Account #{name} merged to root account "

    end

  end
end
