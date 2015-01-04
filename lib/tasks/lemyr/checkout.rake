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
end
