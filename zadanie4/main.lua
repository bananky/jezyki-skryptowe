local Board = require("board")

local state = "menu" 
local board

function love.load()
    love.window.setTitle("Tetris")
    love.window.setMode(300, 600)
end

function love.update(dt)
    if state == "playing" then
        board:update(dt)
    end
end

function love.draw()
    if state == "menu" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Press ENTER to Start", 0, 250, 300, "center")
    elseif state == "playing" then
        board:draw()
    end
end

function love.keypressed(key)
    if state == "menu" and key == "return" then
        board = Board.new(10, 20)
        state = "playing"
    elseif state == "playing" then
        if key == "s" then
            board:saveGame()
        elseif key == "l" then
            board:loadGame()
        elseif key == "left" then
            board:movePiece(-1)
        elseif key == "right" then
            board:movePiece(1)
        elseif key == "down" then
            board:dropPiece()
        elseif key == "up" then
            board:rotatePiece()
        end
    end
end
