require 'test_helper'

require 'tmpdir'
require 'pathname'

class TarballRoundtripTest < ActionDispatch::IntegrationTest
  test "roundtrip a tarball" do

    # First, register a user through the web site.

    visit '/'
    click_on 'Register New Account'

    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'password1'
    fill_in 'Password confirmation', with: 'password1'
    click_on "Sign up"

    joe = User.find_by_email('joe@example.com')
    joe.confirmed_at = Time.now
    joe.save!

    visit '/'
    click_on 'Sign In'

    fill_in 'Email', with: 'joe@example.com'
    fill_in 'Password', with: 'password1'
    click_on 'Sign in'

    assert page.has_content?("Dashboard")

    # Then, upload a tarball.
  
    visit '/blocks/upload_form'
    attach_file "Tarball", Rails.root.join('test/uploads/two_blocks.tar')
    click_on "Upload Tarball"

    hashes = [
      '8010fa2cd2eeadd514992596dc092d62f203befc187006af1ecf5b29ec74d992',
      '650ebd57b07ed838ab82ea0a2225559547e0dd8e694561d9b16c73c6047a254b',
    ]

    assert page.has_content?("uploaded")
    assert page.has_content?(hashes[0])
    assert page.has_content?(hashes[1])

    # Finally, download the tarball again.
  
    visit '/blocks/download_form'

    hashes  = hashes[0] + "\n"
    hashes << hashes[1] + "\n"

    fill_in "Blocks", with: hashes
    click_on "Download Tarball"

    Dir.tmpdir do |tmp|
      tar = Pathname.new("#{tmp}/xx.tar")
      tar.write(page.body)

      system(%Q{cd "#{tmp}" && tar xvf xx.tar})

      assert File.exist?("#{tmp}/#{hashes[0]}")
      assert File.exist?("#{tmp}/#{hashes[1]}")
    end
  end
end
