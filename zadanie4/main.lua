local Board = require("board")

local state = "menu" 
local board

love.graphics.setDefaultFilter("nearest", "nearest")

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

function love.touchpressed(id, x, y, dx, dy, pressure)
    handleInput(x, y)
end

function love.mousepressed(x, y, button)
    handleInput(x, y)
end

function handleInput(x, y)
    if state == "menu" then
        board = Board.new(10, 20)
        state = "playing"
        return
    end

    if state ~= "playing" then return end

    local screenWidth = love.graphics.getWidth()
    local screenHeight = love.graphics.getHeight()

    if y > screenHeight * 0.7 then
        board:dropPiece()
    elseif x < screenWidth * 0.3 then
        board:movePiece(-1)
    elseif x > screenWidth * 0.7 then
        board:movePiece(1)
    else
        board:rotatePiece()
    end
end

