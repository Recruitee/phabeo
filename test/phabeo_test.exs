defmodule PhabeoTest do
  use ExUnit.Case
  doctest Phabeo
 
  
  test "render style tag to inlined css" do

    html =
      """
        <html>
        <style>
          .example {color: red;}
        </style>
        <body>
          <div class="example"></div>
        </body>
        </html>
      """
      
    checkable_attribute =
      Phabeo.render(html)
      |> Floki.find(".example")
      |> Floki.attribute("style")

    assert checkable_attribute === ["color: red;"]

  end

  



end
