local Piece = require("piece")
local json = require("dkjson")
local Save = require("save")

local sounds = {
    move = love.audio.newSource("assets/move.wav", "static"),
    rotate = love.audio.newSource("assets/rotate.wav", "static"),
    lock = love.audio.newSource("assets/lock.wav", "static"),
    clear = love.audio.newSource("assets/clear.wav", "static")
}


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
    self.clearingLines = {}      
    self.clearAnimationTime = 0   
    self.clearAnimationDuration = 0.3 

    return self
end

function Board:checkLinesToClear()
    local lines = {}
    for y = 1, self.height do
        local full = true
        for x = 1, self.width do
            if self.grid[y][x] == 0 then
                full = false
                break
            end
        end
        if full then
            table.insert(lines, y)
        end
    end
    return lines
end


function Board:update(dt)
    self.timer = self.timer + dt

    if self.clearAnimationTime > 0 then
        self.clearAnimationTime = self.clearAnimationTime - dt
        if self.clearAnimationTime <= 0 then
            self:actuallyClearLines()
            self.piece = Piece.newRandom()
        end
        return
    end

    if self.timer >= self.delay then
        self:dropPiece()
        self.timer = 0
    end
end


function Board:movePiece(dx)
    if self.piece:move(dx, 0, self.grid) then
        sounds.move:play()
    end
end


function Board:dropPiece()
    if not self.piece:move(0, 1, self.grid) then
        self.piece:lock(self.grid)
        self.clearingLines = self:checkLinesToClear()
        if #self.clearingLines > 0 then
            self.clearAnimationTime = self.clearAnimationDuration
            sounds.clear:play()
        else
            self.piece = Piece.newRandom()
        end
        sounds.lock:play()
    end
end


function Board:actuallyClearLines()
    table.sort(self.clearingLines)
    for i = #self.clearingLines, 1, -1 do
        local y = self.clearingLines[i]
        table.remove(self.grid, y)
        table.insert(self.grid, 1, {})
        for x = 1, self.width do
            self.grid[1][x] = 0
        end
    end
    self.clearingLines = {}
end


function Board:rotatePiece()
    local rotated = self.piece:rotate(self.grid)
    if rotated then
        sounds.rotate:play()
    end
end


function Board:clearLines()
    local cleared = 0
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
            cleared = cleared + 1
        end
    end
    return cleared
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
        for x = 1, self.width do
            if self.grid[y][x] == 1 then
                local isClearing = false
                for _, ly in ipairs(self.clearingLines) do
                    if ly == y then
                        isClearing = true
                        break
                    end
                end
                if isClearing then
                    local alpha = 0.5 + 0.5 * math.sin(love.timer.getTime() * 20)
                    love.graphics.setColor(1, 1, 1, alpha)
                else
                    love.graphics.setColor(0.5, 0.5, 1)
                end
                love.graphics.rectangle("fill", (x - 1) * 30, (y - 1) * 30, 30, 30)
            end
        end
    end

    if self.piece then
        self.piece:draw()
    end
end



return Board
