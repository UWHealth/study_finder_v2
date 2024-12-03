require 'net/ldap'

module Modules
  class Ldap
    def authenticate(x500, password)
      # initialize our return hash with some defaults
      _return = Hash.new
      _return[:ldap_user] = nil
      _return[:success] = false
      _return[:message] = ''

      ldap_user = Net::LDAP.new(
        host: ENV['host'],
        encryption: (ENV['encryption'] || 'simple_tls').to_sym,
        port: ENV['port'],
        auth: {
          method: :simple,
          username: "#{x500}@uwhis.hosp.wisc.edu",
          password: password.to_s
        },
        connect_timeout: 3 # Timeout in seconds
      )

      _return[:ldap_user] = x500

      if ldap_user.bind
        _return[:success] = true
      else
        _return[:message] = 'User authentication with LDAP failed.'
      end

      _return
    end
  end
end