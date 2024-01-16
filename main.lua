---@diagnostic disable: duplicate-set-field
_G.love = require "love"
local  text = {""}
local cursor = {
    line = 1,
    pos = 1
  }

function love.load()
  text = { n = 4, "hey, this is the first line", "and this is the second", "this the third","table"}
  cursor.line = text.n
  cursor.pos = text[text.n]:len()
end

function love.update(dt)
end

function love.draw()
  love.graphics.print(table.concat(text, "\n"))
end

function love.textinput(t)
  text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) .. t .. text[cursor.line]:sub(cursor.pos+1, text[cursor.line]:len())
  cursor.pos = cursor.pos + 1
end

function love.keypressed(key)
end