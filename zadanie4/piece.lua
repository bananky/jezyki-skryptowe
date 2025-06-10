local Piece = {}
Piece.__index = Piece

local shapes = {
    { {1,1,1,1} }, -- I
    { {1,1}, {1,1} }, -- O
    { {0,1,0}, {1,1,1} }, -- T
    { {1,1,0}, {0,1,1} } -- Z
}

function Piece.newRandom()
    local self = setmetatable({}, Piece)
    self.shape = shapes[math.random(#shapes)]
    self.x = 4
    self.y = 1
    return self
end

function Piece:move(dx, dy, grid)
    self.x = self.x + dx
    self.y = self.y + dy
    if self:collides(grid) then
        self.x = self.x - dx
        self.y = self.y - dy
        return false
    end
    return true
end

function Piece:rotate(grid)
    local new = {}
    for y = 1, #self.shape[1] do
        new[y] = {}
        for x = 1, #self.shape do
            new[y][x] = self.shape[#self.shape - x + 1][y]
        end
    end
    local old = self.shape
    self.shape = new
    if self:collides(grid) then
        self.shape = old
    end
end

function Piece:collides(grid)
    for y = 1, #self.shape do
        for x = 1, #self.shape[y] do
            if self.shape[y][x] == 1 then
                local gx = self.x + x - 1
                local gy = self.y + y - 1
                if gx < 1 or gx > #grid[1] or gy > #grid or (gy > 0 and grid[gy][gx] == 1) then
                    return true
                end
            end
        end
    end
    return false
end

function Piece:lock(grid)
    for y = 1, #self.shape do
        for x = 1, #self.shape[y] do
            if self.shape[y][x] == 1 then
                local gx = self.x + x - 1
                local gy = self.y + y - 1
                if gy >= 1 then
                    grid[gy][gx] = 1
                end
            end
        end
    end
end

function Piece:draw()
    for y = 1, #self.shape do
        for x = 1, #self.shape[y] do
            if self.shape[y][x] == 1 then
                love.graphics.rectangle("fill", (self.x + x - 2)*30, (self.y + y - 2)*30, 30, 30)
            end
        end
    end
end

return Piece
