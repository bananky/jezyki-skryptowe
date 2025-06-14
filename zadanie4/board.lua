local Piece = require("piece")
local json = require("dkjson")
local Save = require("save")


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

function Board:saveGame()
    local data = {
        grid = self.grid,
        piece = {
            shape = self.piece.shape,
            x = self.piece.x,
            y = self.piece.y
        }
    }
    Save.save(data)
end

function Board:loadGame()
    local data = Save.load()
    if data and data.grid and data.piece then
        self.grid = data.grid
        self.piece = Piece.fromSave(data.piece.shape, data.piece.x, data.piece.y)
    end
end

function Board:draw()
    for y = 1, self.height do
        if self.grid[y] then
            for x = 1, self.width do
                if self.grid[y][x] == 1 then
                    love.graphics.rectangle("fill", (x-1)*30, (y-1)*30, 30, 30)
                end
            end
        end
    end
    if self.piece then
        self.piece:draw()
    end
end


return Board
