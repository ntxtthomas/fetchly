if Rails.env.development? && defined?(Rails::Console)
  require 'hirb'
  Hirb.enable
end