namespace :lemyr do
  desc "Checkout any members currently checked in"
  task :auto_checkout => :environment do
    UserStatus.get_currently_checked_in.each do |status|
      status.user.perform_checkout! "Auto Checkout"
    end

    if LocationSettings.first.freeday
      info = %{
        <strong>Free For All is still active</strong><br/>
        Currently, member check-ins are not deducting daypasses.
        To resolve this, change the Location Settings in the the admin dashboard.
      }

      AdminMailer.admin_info(info, "Free For All is active").deliver
    end
  end

  # rake lemyr:migrate_subscriptions[6,8]
  desc "Migrate members from one membership plan to another"
  task :migrate_subscriptions, [:old_plan, :new_plan] => :environment do | t, args |
    oldPlan = Membership.find(args.old_plan.to_i)
    newPlan = Membership.find(args.new_plan.to_i)

    if !oldPlan.nil? and !newPlan.nil?
      puts "Migrating from \"#{oldPlan.name}\" to \"#{newPlan.name}\""

      User.where(:membership_id => oldPlan).each do |u|
        begin
          u.membership = newPlan
          u.save!
        rescue => e
          puts "Problem migrating #{u.name}: #{e.to_s}"
        end
      end
    else
      puts "Aborting. Could not find plan ID:" + (oldPlan.nil? ? args.old_plan : args.new_plan)
    end
  end
end
