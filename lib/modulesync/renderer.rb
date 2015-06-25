require 'erb'
require 'find'

module ModuleSync
  module Renderer

    class ForgeModuleFile
      def initialize(configs= {}, puppet_module)
        @configs = configs
        @puppet_module = puppet_module
      end
    end

    def self.build(from_erb_template)
      erb_obj = ERB.new(File.read(from_erb_template), nil, '-')
      erb_obj.filename = from_erb_template.chomp('.erb')
      erb_obj.def_method(ForgeModuleFile, 'render()')
      erb_obj
    end

    def self.remove(file)
      if File.exists?(file)
        File.delete(file)
      end
    end

    def self.render(template, configs = {}, puppet_module)
      ForgeModuleFile.new(configs, puppet_module).render()
    end

    def self.sync(template, to_file)
      path = to_file.rpartition('/').first
      if(! path.empty?)
        FileUtils.mkdir_p(path)
      end
      File.open(to_file, 'w') do |file|
        file.write(template)
      end
    end

  end
end
