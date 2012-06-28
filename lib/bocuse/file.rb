module Bocuse
  
  # Represents a bocuse File.
  #
  # This is usually a file that contains one of the
  # following directives:
  #  * node
  #  * template
  #
  # It is used to generate a config hash from the given files.
  #
  class File
    
    def configuration
      @configuration ||= Configuration.new
    end
    
    # Returns a config hash.
    #
    # Call to_h on the returned configuration to
    # get the config hash.
    #
    # Will return nil if there is no configuration
    # to speak of inside the file. Use "node" or
    # "template" to define a configuration.
    #
    def load filename
      ::File.open filename, 'r' do |file|
        self.instance_eval file.read, file.path
      end
      configuration
    end
    
    # Include the given template name.
    #
    # Note: This could be pushed to the configuration.
    #
    def include_template identifier
      template = Templates.get identifier.to_sym
      p [:template, template]
      configuration.merge! template
    end
    
    # The files read by #load will trigger these methods.
    #
    # TODO Do something with the name.
    #
    def node name = nil
      yield configuration
      configuration
    end
    alias template node
    
    # Cook adds to the toplevel recipes of this file's configuration.
    #
    def cook recipe
      configuration.recipes << recipe
    end
    
    
  end
  
end