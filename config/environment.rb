# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Flowghost::Application.initialize!

# enable OAuth 1 support for LTI
OAUTH_10_SUPPORT = true
