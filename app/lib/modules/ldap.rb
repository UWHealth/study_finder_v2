require 'net/ldap'

module Modules
  class Ldap
    def authenticate(x500, password)
      # Initialize our return hash with default values
      result = {
        ldap_user: nil,
        success: false,
        message: ''
      }

      # Initialize the LDAP connection
      ldap = Net::LDAP.new(
        host: ENV['host'] || 'localhost', # Default to localhost if no environment variable is set
        encryption: {
          method: (ENV['encryption'] || 'simple_tls').to_sym
        },
        encryption: nil,
        port: ENV['port'] ? ENV['port'].to_i : 636, # Convert port to an integer, default to 636
        auth: {
          method: :simple,
          username: "cn=#{x500},#{ENV['base']}",
          password: password.to_s
        },
        connect_timeout: 3 # Timeout in seconds
      )

      result[:ldap_user] = x500

      # Bind to the LDAP server
      if ldap.bind
        result[:success] = true
      else
        result[:message] = "User authentication with LDAP failed. Error: #{ldap.get_operation_result.message}"
      end

      result
    end
  end
end
