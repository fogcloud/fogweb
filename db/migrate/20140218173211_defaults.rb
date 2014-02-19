class Defaults < ActiveRecord::Migration
  def up
    Plan.create!(name: "Default", megs: "5120", price_usd: "5.00")
    uu = User.create!(
      email: "nat@ferrus.net", 
      admin: true,
      confirmed_at: Time.now,
      password: "fakemcfake",
      password_confirmation: "fakemcfake",
    )
    uu.encrypted_password = "$2a$10$Sf1QzriFEHDX95oVopAfcOeSW81F6i4np.2Cpfqa1K.JN8eiKhBWu"
    uu.save!
  end

  def down
  end
end
