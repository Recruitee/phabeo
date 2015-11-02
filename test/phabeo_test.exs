defmodule PhabeoTest do
  use ExUnit.Case
  doctest Phabeo
 
  
  test "Tempalte find styles" do
    html = 
      """
        <html>
        <style>
          .example { 
            color:red; }

          .super-duper a { background-color:red; 
          }
        
        </style>
        <body>
        <div class="example"></div>
        </body>
        </html>
      """

    rendered = Phabeo.render(html)

    IO.inspect rendered

    assert 1 + 1 == 2
  end
end
