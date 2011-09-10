require 'base64'
require 'hmac-sha1'
require 'json'

require 's3-upload/version'

class S3Upload

  class<<self
    attr_accessor :access_key_id
    attr_accessor :secret_access_key
    attr_accessor :bucket
    attr_accessor :default_key_prefix
  end

  def initialize(options = {})
    @options = options
    @options[:AWSAccessKeyId] ||= self.class.access_key_id
    @options[:AWSSecretAccessKey] ||= self.class.secret_access_key
    @options[:bucket] ||= self.class.bucket
    @options[:key_prefix] ||= self.class.default_key_prefix
    @options[:expiration_date] ||= Time.now + 60*60
    @options[:success_action_status] = '201'
  end

  def url
    "http://#{@options[:bucket]}.s3.amazonaws.com/"
  end

  def file_param
    'file'
  end

  def policy
    conditions = []
    conditions << { :bucket => @options[:bucket].to_s }
    conditions << ['starts-with', '$key', @options[:key_prefix].to_s]
    conditions << { :success_action_redirect => @options[:success_action_redirect].to_s } if @options[:success_action_redirect]
    conditions << { :success_action_status => @options[:success_action_status].to_s } if @options[:success_action_status]
    conditions << ['starts-with', '$Filename', '']
    if @options[:meta_fields]
      @options[:meta_fields].sort.each do |meta_field|
        conditions << ['starts-with', "$#{meta_field}", '']
      end
    end
    Base64.encode64(
    "{ 
       'expiration': '#{self.class.expiration_date(@options[:expiration_date])}',
       'conditions': #{conditions.to_json}
     }").gsub(/\n|\r/, '')
  end

  def signature
    Base64.encode64(HMAC::SHA1.digest(@options[:AWSSecretAccessKey],policy)).strip
  end

  def params
    { :success_action_status => @options[:success_action_status],
      :AWSAccessKeyId => @options[:AWSAccessKeyId],
      :key => "#{@options[:key_prefix]}${filename}",
      :policy => self.policy,
      :signature => self.signature }
  end

  def as_json(options = {})
    { :url => self.url,
      :file_param => self.file_param,
      :params => self.params }
  end

private

  def self.expiration_date(seconds_from_now)
    seconds_from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
  end

end