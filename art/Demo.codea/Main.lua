function menu()
  parameter.clear()
  parameter.action("Text (short)",switchToTextShort)
  parameter.action("Text (full)",switchToTextFull)
end

function setup()
  menu()
end

function draw()
  background(40, 40, 50)
end
