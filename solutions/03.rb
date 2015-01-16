module RBFS

  class File

    def initialize(object = nil)
      @object = object
    end

    def data_type
      case @object
        when String then :string
        when Fixnum,Float then :number
        when Symbol then :symbol
        when NilClass then :nil
        else :boolean
      end
    end

    def data= (other)
      @object = other
      @object.to_s
    end

    def data
      @object.to_s
    end

    def serialize
      "#{data_type}:#{data}"
    end

    def self.parse(string_data)
      RBFS::File.new(
        case string_data.split(":").first
          when 'nil' then nil
          when 'string' then string_data.split(":").drop(1).join(" ").to_s
          when 'number' then eval(string_data.split(":").drop(1).join(" "))
          when 'symbol' then string_data.split(":").drop(1).join(" ").to_sym
          when string_data.split(":").drop(1).join(" ").to_s == 'true' then true
          else false
        end)
    end

  end

  class My_Hash
    def initialize
      @hash = Hash.new{ |hash, key| hash[key] = Hash.new }
    end

  end

  class Directory < My_Hash

    def files
      @hash['file']
    end

    def directories
      @hash['directories']
    end

    def [](name)
      if directories.has_key?(name)
        directories[name]
      elsif files.has_key?(name)
        files[name]
      else
        nil
      end
    end

    def add_file(name,file)
      unless name.include? ":"
        files[name] = file
      end
    end

    def add_directory(name,directory = RBFS::Directory.new)
      unless name.include? ":"
        directories[name] = directory
      end
    end

    def serialize
      "#{files.count}:#{serialize_files.join}#{directories.count}:#{serialize_dir.join}"
    end
    alias_method :s, :serialize

    def serialize_files
      k = files.keys
      v = files.values

      files.each_with_index.map{ |x,i| "#{k[i]}:#{v[i].serialize.size}:#{v[i].serialize}"}
    end

    def serialize_dir
      k = directories.keys
      v = directories.values

      directories.each_with_index.map{ |x,i| "#{k[i]}:#{v[i].serialize.size}:#{v[i].s}"}
    end

  end


end