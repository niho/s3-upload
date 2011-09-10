$LOAD_PATH.unshift 'lib'
require 's3-upload/version'

Gem::Specification.new do |s|
  s.name        = 's3-upload'
  s.version     = S3Upload::Version
  s.summary     = 'S3-Upload is a simple helper for creating a signed S3 upload policy'
  s.description = 'S3-Upload is a simple helper for creating a signed S3 upload policy, useful
  for allowing untrusted 3rd parties to upload to your bucket. Through, for
  example, a HTML form.'

  s.author      = 'Niklas Holmgren'
  s.email       = 'niklas@sutajio.se'
  s.homepage    = 'http://github.com/sutajio/s3-upload/'

  s.require_path  = 'lib'

  s.files             = %w( README.md Rakefile LICENSE CHANGELOG )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("test/**/*")
  s.files            += Dir.glob("tasks/**/*")

  s.extra_rdoc_files  = [ "LICENSE", "README.md" ]
  s.rdoc_options      = ["--charset=UTF-8"]

  s.add_dependency('json', '> 1.0.0')
  s.add_dependency('ruby-hmac',  '~> 0.4.0')
end