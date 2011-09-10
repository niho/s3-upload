S3-Upload
=========

S3-Upload is a simple helper for creating a signed S3 upload policy, useful
for allowing untrusted 3rd parties to upload to your bucket. Through, for
example, a HTML form.

Setup
-----

    $ gem install s3-upload

    require 's3-upload'
    S3Upload.access_key_id = ...
    S3Upload.secret_access_key = ...
    S3Upload.bucket = 'my-upload-bucket'
    S3Upload.default_key_prefix = 'uploads/'

Example usage
-------------

    upload = S3Upload.new(
      :key_prefix => Time.now.to_s,
      :expiration_date => 1.year.from_now # Default is 1 hour
    )
    render :json => upload

Author
------

Created by Niklas Holmgren (niklas@sutajio.se) and released under
the MIT license.
