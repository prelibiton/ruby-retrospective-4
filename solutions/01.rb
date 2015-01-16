def get_element(first, second, index)
  return first if index <= 1
  return second if index == 2

  get_element(first, second, index - 1) + get_element(first, second, index - 2)
end

def series(name, index)
  return get_element(1, 1, index) if name == 'fibonacci'
  return get_element(2, 1, index) if name == 'lucas'

  get_element(1, 1, index) + get_element(2, 1, index)
end