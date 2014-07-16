class Defaults < ActiveRecord::Migration
  def up
    return unless Rails.env.development?

    Plan.create!(name: "Default", megs: "5120", usd_per_month: "5.00")

    uu = User.create!(
      email: "admin@example.com", 
      admin: true,
      confirmed_at: Time.now,
      password: "derpcake",
      password_confirmation: "derpcake",
      auth_key: "48e7f03d0b3e92c4777ed5b8714378a5",
    )
    uu.save!
 
    uu = User.create!(
      email: "nat@ferrus.net", 
      admin: false,
      confirmed_at: Time.now,
      password: "derpcake",
      password_confirmation: "derpcake",
      auth_key: "b5a3eb90249d3fafaf140203d06b1d89",
    )
    uu.save!

    ss = Share.create!(
      user_id: uu.id,
      name: "b4d6db730b2c0b6aee8be1b33156b3d8dbb2ed291b3bf3dec571a26bb1879573",
      roots: "",
    )
 end

  def down
  end
end
