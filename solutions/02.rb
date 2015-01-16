class NumberSet
  include Enumerable

  def initialize(numbers_list = [])
    @numbers_list = numbers_list
  end

  def each
    @numbers_list.each { |member| yield member }
  end

  def << (number)
    @numbers_list.push(number) unless @numbers_list.include?(number)
  end

  def [](filter)
    new_list = NumberSet.new(filter[@numbers_list])
  end

  def size
    @numbers_list.length
  end

  def empty?
    @numbers_list.empty?
  end

end

class SignFilter

  def initialize(sign)
    @sign = sign
  end

  def [](array)
    return array.find_all{ |v| v > 0 } if @sign == :positive
    return array.find_all{ |v| v <= 0} if @sign == :non_positive
    return array.find_all{ |v| v < 0} if @sign == :negative
    array.find_all{ |v| v >= 0} if @sign == :non_negative
  end

end

class TypeFilter

  def initialize(type)
    @type = type
  end

  def [](array)
    return array.find_all{ |i| i.is_a? Integer } if @type == :integer
    return array.find_all{ |i| i.is_a? Complex } if @type == :complex
    array.find_all{ |i| i.is_a? Float or i.is_a? Rational } if @type == :real
  end

end

class Filter

  def initialize (&block)
    @block = block
  end

  def [](array)
    array.find_all{ |e| @block.call(e) }
  end

end