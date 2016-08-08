defmodule Phabeo do

  def render(template, rule_extractor \\ &rules_from_inner_style/1) do
    parsed_template = Floki.parse(template)
    rules = rule_extractor.(parsed_template)
    complete_template = search_by_rules(parsed_template, rules)
    Floki.raw_html complete_template
  end

  defp rules_from_inner_style(parsed_template) do
    style = Floki.find(parsed_template, "style")

    {_,_,value} = style |> List.first

    clear_css_string = List.first(value)
    |> String.replace(~r/\r?\n|\r/, "")
    |> String.replace(~r/\s+/, " ")

    Regex.scan(~r/([^\{]*){([^\}]*)}/, clear_css_string, capture: :all_but_first)
  end

  defp update_attr({el, attr, body}, new_attr) do
    {el, attr ++ [new_attr], body }
  end

  defp list_it(list, old, style_value) do
    case list do
      {el, attr, body} ->
        if Mix.env == :dev, do: IO.inspect body
        [head | tail] = body
        head = if [head] == old, do: update_attr(head, {"style", style_value}), else: head
        [{el, attr, [head | list_it(tail, old, style_value)]}]
      [el] -> list_it(el, old, style_value)
      [] -> []
    end
  end

  defp search_by_rules(template, rules) do
    Enum.reduce rules, template, fn(rule,acc)->
      [selector, value] = rule
      should_inlined = Floki.find(template, selector)
      list_it(acc, should_inlined, value)
    end
  end

end
