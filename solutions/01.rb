def get_element(first, second, index)
  return first if index <= 1
  return second if index == 2

  get_element(first, second, index - 1) + get_element(first, second, index - 2)
end

def series(name, index)
  case name
    when  'fibonacci' then get_element(1, 1, index)
    when  'lucas'     then get_element(2, 1, index)
    else get_element(1, 1, index) + get_element(2, 1, index)
  end
end