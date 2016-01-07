module MetallumCli
  class Iniparse
    def initialize(string)
      @string = string
      @stack = {}
    end

    def parse
      @string.split("\n").each do |line|
        case line
        when /^\[/ then new_group(line)
        when /(.*)=(.*)/ then add_key_value($1, $2)
        else raise NotImplementedError.new(line)
        end
      end
      @stack
    end

    def self.parse(string)
      new(string).parse
    end

    private

    def new_group(group)
      @current_item = {}
      @stack[group] = @current_item
    end

    def add_key_value(key, value)
      if value.to_s[/^\d+$/]
        value = value.to_i
      end
      @current_item[key] = value
    end
  end
end
