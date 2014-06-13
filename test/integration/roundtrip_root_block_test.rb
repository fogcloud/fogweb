require 'test_helper'

require 'tmpdir'
require 'pathname'
require 'digest/sha2'
require 'json'

class RoundtripRootBlockTest < ActionDispatch::IntegrationTest
  test "roundtrip a root block" do
    @user = users(:user)
    @share = shares(:one)

    block_hash = 'de2f256064a0af797747c2b97505dc0b9f3df0de4f489eac731c23ae9ca9cc31'
    block_path = Rails.root.join('test', 'uploads', 'blocks', block_hash)

    post "/shares/#{@share.name}/put/#{block_hash}", {
      "format" => "json",
      "auth" => @user.auth_key,
      "upload" =>  fixture_file_upload(block_path, 'application/octet-stream'),
    }
    assert_response :success

    put "/shares/#{@share.name}", {
      "format" => "json",
      "auth" => @user.auth_key,
      "share" => {
        "root" => block_hash
      },
    }
    assert_response :success

    get "/shares/#{@share.name}", {
      "format" => "json",
      "auth" => @user.auth_key,
    }
    assert_response :success

    resp = JSON.parse(response.body)
    assert_equal resp["root"], block_hash

    get "/shares/#{@share.name}/get/#{block_hash}", {
      "format" => "json",
      "auth" => @user.auth_key,
    }
    assert_response :success

    resp_hash = Digest::SHA256.hexdigest(response.body)
    assert_equal resp_hash, block_hash

    get "/shares/#{@share.name}", { 
      "format" => "json",
      "auth" => @user.auth_key,
    }
    assert_response :success

    resp = JSON.parse(response.body)
    assert_equal resp["block_count"], 1
    assert resp["blocks"].include?(block_hash)

    post "/shares/#{@share.name}/remove", {
      "format" => "json",
      "auth" => @user.auth_key,
      "blocks" => [block_hash],
    }
    assert_response :success
  end
end
