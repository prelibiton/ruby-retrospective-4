class NumberSet
  include Enumerable

  def initialize(numbers_list = [])
    @numbers_list = numbers_list
  end

  def each(&block)
    @numbers_list.each &block
  end

  def <<(number)
    @numbers_list << number unless @numbers_list.include? number
  end

  def [](filter)
    NumberSet.new @numbers_list.select { |number| filter.call number }
  end

  def size
    @numbers_list.size
  end

  def empty?
    @numbers_list.empty?
  end

end

class Filter

  def initialize (&block)
    @block = block
  end

  def &(other)
    Filter.new { |x| @block.call x and other.call x }
  end

  def |(other)
    Filter.new { |x| @block.call x or other.call x }
  end

  def call(p)
    @block.call p
  end

end

class SignFilter < Filter

  def initialize(sign)
    case sign
      when :positive     then super() { |i| i > 0 }
      when :negative     then super() { |i| i < 0 }
      when :non_positive then super() { |i| i <= 0 }
      when :non_negative then super() { |i| i >= 0 }
    end
  end

end

class TypeFilter < Filter

  def initialize(type)
    case type
      when :integer then super() { |i| i.is_a? Integer}
      when :real    then super() { |i| i.is_a? Float or i.is_a? Rational }
      when :complex then super() { |i| i.is_a? Complex }
    end
  end

end