def generic_series(first, second, index)
  return first  if index == 1
  return second if index == 2

  generic_series(first, second, index - 1) +
  generic_series(first, second, index - 2)
end

def series(name, index)
  case name
    when  'fibonacci' then generic_series(1, 1, index)
    when  'lucas'     then generic_series(2, 1, index)
    else generic_series(1, 1, index) + generic_series(2, 1, index)
  end
end