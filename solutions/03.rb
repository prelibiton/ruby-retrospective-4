module RBFS
  class File
    attr_accessor :data

    def initialize(data = nil)
      @data = data
    end

    def data_type
      case @data
        when String       then :string
        when Fixnum,Float then :number
        when Symbol       then :symbol
        when NilClass     then :nil
        else :boolean
      end
    end

    def data=(other)
      @data = other
      @data.to_s
    end

    def data
      @data.to_s
    end

    def serialize
      "#{data_type}:#{data}"
    end

    def self.parse(string_data)
      splitted = string_data.split(":",2)
      File.new case splitted.first
        when 'nil'     then
        when 'string'  then splitted.last
        when 'number'  then splitted.last.to_f
        when 'symbol'  then splitted.last.to_sym
        when 'boolean' then splitted.last == 'true'
      end
    end

  end

  class MyHash
    def initialize
      @hash = Hash.new{ |hash, key| hash[key] = Hash.new }
    end

  end

  class Directory < MyHash

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

