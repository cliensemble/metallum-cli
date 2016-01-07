require 'metallum-cli/app'
require 'metallum-cli/version'
require 'metallum-cli/configuration'

module MetallumCli
  def self.config
    MetallumCli::Configuration.instance
  end
end