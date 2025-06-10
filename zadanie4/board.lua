local Piece = require("piece")

local Board = {}
Board.__index = Board

function Board.new(width, height)
    local self = setmetatable({}, Board)
    self.width = width
    self.height = height
    self.grid = {}
    for y = 1, height do
        self.grid[y] = {}
        for x = 1, width do
            self.grid[y][x] = 0
        end
    end
    self.piece = Piece.newRandom()
    self.timer = 0
    self.delay = 0.5
    return self
end

function Board:update(dt)
    self.timer = self.timer + dt
    if self.timer >= self.delay then
        self:dropPiece()
        self.timer = 0
    end
end

function Board:movePiece(dx)
    self.piece:move(dx, 0, self.grid)
end

function Board:dropPiece()
    if not self.piece:move(0, 1, self.grid) then
        self.piece:lock(self.grid)
        self:clearLines()
        self.piece = Piece.newRandom()
    end
end

function Board:rotatePiece()
    self.piece:rotate(self.grid)
end

function Board:clearLines()
    for y = self.height, 1, -1 do
        local full = true
        for x = 1, self.width do
            if self.grid[y][x] == 0 then
                full = false
                break
            end
        end
        if full then
            table.remove(self.grid, y)
            table.insert(self.grid, 1, {})
            for x = 1, self.width do
                self.grid[1][x] = 0
            end
        end
    end
end

function Board:draw()
    for y = 1, self.height do
        for x = 1, self.width do
            if self.grid[y][x] == 1 then
                love.graphics.rectangle("fill", (x-1)*30, (y-1)*30, 30, 30)
            end
        end
    end
    self.piece:draw()
end

return Board
