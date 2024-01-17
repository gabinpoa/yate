---@diagnostic disable: duplicate-set-field
_G.love = require "love"
local keymaps = require "lua.keymaps"
local  text = {""}
local cursor = {
    line = 1,
    pos = 1,
}
local lineHeight

function love.load()
  lineHeight = love.graphics.getFont():getHeight()
  love.keyboard.setKeyRepeat(true)
  text = { n = 4, "hey, this is the first line", "and this is the second", "this the third","table"}
  cursor.line = text.n
  cursor.pos = text[text.n]:len()
end

function love.update(dt)
end

function love.draw()
  love.graphics.print(table.concat(text, "\n"), 10, 10)
  cursor.x = 10 + love.graphics.getFont():getWidth(text[cursor.line]:sub(1, cursor.pos))
  cursor.y = 10 + (cursor.line - 1) * lineHeight
  love.graphics.line(cursor.x, cursor.y, cursor.x, cursor.y + lineHeight)
end

function love.textinput(t)
  text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) .. t .. text[cursor.line]:sub(cursor.pos+1, text[cursor.line]:len())
  cursor.pos = cursor.pos + 1
end

function love.keypressed(key)
  if keymaps[key] ~= nil then
    keymaps[key](cursor, text)
  end
end