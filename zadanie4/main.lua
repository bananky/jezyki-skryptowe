local Board = require("board")

function love.load()
    love.window.setTitle("Tetris")
    love.window.setMode(300, 600)
    board = Board.new(10, 20)
end

function love.update(dt)
    board:update(dt)
end

function love.draw()
    board:draw()
end

function love.keypressed(key)
    if key == "left" then
        board:movePiece(-1)
    elseif key == "right" then
        board:movePiece(1)
    elseif key == "down" then
        board:dropPiece()
    elseif key == "up" then
        board:rotatePiece()
    end
end
