if LocationSettings.count < 1
    LocationSettings.create(name: 'Lemyr Cowork', freeday: false,
        daypass_price: 20.00, daypass_price3: 50.00, daypass_price5: 70.00, daypass_discount: 50,
        sender_email:"info@lemyr.co", notification_email:"staff@lemyr.co",
        membership_plans_url:"http://lemyr.co")
end

{'Day Pass Only' => '', 'Supporter' => '', 'Full Time' => '1', 'Nights & Weekends' => '2'}.each do |name, stripeid|
  Membership.find_or_create_by_name_and_stripe_id(name, stripeid)
end

['Just Hanging Out', 'Working but Available', 'Super Busy', 'Do Not Disturb'].each do |label|
  CheckinStatus.find_or_create_by_label(label)
end

AdminUser.create(email: 'admin@lemyr.co', password: 'whynotthebeach.com')
