default_membership = Membership.find_or_create_by(name: 'Day Pass Only')

if LocationSettings.count < 1
    LocationSettings.create(name: 'Coworking', freeday: false,
        daypass_price: 20.00, daypass_price3: 50.00, daypass_price5: 70.00, daypass_discount: 50,
        sender_email:"info@lemyr.co", notification_email:"staff@lemyr.co",
        membership_plans_url:"http://lemyr.co", membership_id: default_membership.id)
end

['Just Hanging Out', 'Working but Available', 'Super Busy', 'Do Not Disturb'].each do |label|
  CheckinStatus.find_or_create_by(label: label)
end

AdminUser.create(email: 'admin@lemyr.co', password: 'whynotthebeach.com')
