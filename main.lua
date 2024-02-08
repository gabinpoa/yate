---@diagnostic disable: duplicate-set-field
_G.love = require "love"
local keymaps = require "lua.keymaps"
local text = { "" }
local cursor = {
  line = 1,
  pos = 1,
}
local lineHeight
local padding = 10

function love.load()
  love.graphics.setNewFont("JetBrainsMono-Regular.ttf", 14)
  lineHeight = love.graphics.getFont():getHeight()
  love.keyboard.setKeyRepeat(true)
  text = { n = 4, "hey, this is the first line", "and this is the second", "this the third", "table" }

  cursor.line = text.n
  cursor.pos = text[text.n]:len()
  cursor.selStart = {
    line = nil,
    pos = nil
  }
end

function love.draw()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print(table.concat(text, "\n"), padding, padding)
  cursor.x = love.graphics.getFont():getWidth(text[cursor.line]:sub(1, cursor.pos)) + padding
  cursor.y = (cursor.line - 1) * lineHeight + padding
  love.graphics.line(cursor.x, cursor.y, cursor.x, cursor.y + lineHeight)
  if cursor.selStart.pos ~= nil then
    love.graphics.setColor(0, 0, 255, 0.4)
    love.graphics.rectangle("fill", love.graphics.getFont():getWidth(text[cursor.selStart.line]:sub(1, cursor.selStart.pos)), (cursor.selStart.line - 1) * lineHeight + padding, cursor.x - love.graphics.getFont():getWidth(text[cursor.selStart.line]:sub(1, cursor.selStart.pos)), lineHeight)
  end
end

function love.textinput(t)
  text[cursor.line] = text[cursor.line]:sub(1, cursor.pos) ..
  t .. text[cursor.line]:sub(cursor.pos + 1, text[cursor.line]:len())
  cursor.pos = cursor.pos + 1
end

function love.keypressed(key)
  if keymaps[key] ~= nil then
    keymaps[key](cursor, text)
  end
end