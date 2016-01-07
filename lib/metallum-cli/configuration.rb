require 'yaml'
module MetallumCli
  class Configuration
    attr_accessor :lang

    CONFIG_FILE = "#{ENV['HOME']}/.metallumcli"

    def defaults
      self.lang ||= 'en'
    end

    def self.instance
      @instance ||= File.exists?(CONFIG_FILE) ? load_yml() : new.tap(&:defaults)
    end

    def self.load_yml
      YAML.load_file(CONFIG_FILE)
    end

    def self.save
      File.open(CONFIG_FILE, 'w+') { |f| f.write(instance.to_yaml) }
    end
  end
end
