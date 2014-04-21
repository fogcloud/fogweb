class Defaults < ActiveRecord::Migration
  def up
    return unless Rails.env.development?

    Plan.create!(name: "Default", megs: "5120", price_usd: "5.00")

    uu = User.create!(
      email: "nat@ferrus.net", 
      admin: true,
      confirmed_at: Time.now,
      password: "derpcake",
      password_confirmation: "derpcake",
    )
    uu.save!

    uu = User.create!(
      email: "bob@example.com", 
      admin: false,
      confirmed_at: Time.now,
      password: "derpcake",
      password_confirmation: "derpcake",
    )
    uu.save!
  end

  def down
  end
end
