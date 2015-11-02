defmodule Phabeo do

  defp list_it(list) do
    list 
    |> Tuple.to_list 
    |> Enum.each(fn(item)-> 
      IO.puts "element"
      if is_list(item) or is_tuple(item) do
        list_it item
      else
        item 
      end
    end)
  end

  def render(template) do
    style = template
    |> Floki.parse
    |> Floki.find("style") 
   
    {_,_,value} = style |> List.first
    
    clear_css_string = List.first(value)  
    |> String.replace(~r/\r?\n|\r/, "")
    |> String.replace(~r/\s+/, " ")
    
    rules = Regex.scan(~r/([^\{]*){([^\}]*)}/, clear_css_string, capture: :all_but_first)
    
    template_list = Floki.parse(template) |> list_it 

    #IO.inspect template_list

    Enum.each(rules, fn(rule) ->
      [selector, value] = rule 
      value = Floki.find(template, selector) 
      #IO.inspect value
    end)

  end
  

end
