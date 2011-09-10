require File.expand_path('test/test_helper')

class S3UploadTest < Test::Unit::TestCase

  def setup
    S3Upload.access_key_id = '...'
    S3Upload.secret_access_key = '...'
    S3Upload.bucket = 'my-upload-bucket'
    S3Upload.default_key_prefix = 'uploads/'
  end

  def test_can_create_an_upload
    upload = S3Upload.new(
      :key_prefix => 'test/',
      :expiration_date => Time.now + 60
    )
    assert_equal 'http://my-upload-bucket.s3.amazonaws.com/', upload.as_json[:url]
    assert_equal 'file', upload.as_json[:file_param]
    assert_equal '...', upload.as_json[:params][:AWSAccessKeyId]
    assert_match /^test\//, upload.as_json[:params][:key]
    assert_equal '201', upload.as_json[:params][:success_action_status]
    assert upload.as_json[:params][:policy]
    assert upload.as_json[:params][:signature]
  end

end