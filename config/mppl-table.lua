-- MPPL table layout: content-aware column widths + breakable long tokens
-- Compatible with Pandoc 2.5 Table AST: caption, aligns, widths, headers, rows

local MIN_COL = 0.06
local MAX_COL = 0.45
local TARGET_SUM = 0.98
local BREAK_LEN = 12

-- RawInline must use doubled backslash so Lua does not treat \a as bell
local ALLOWBREAK = pandoc.RawInline("latex", "\\allowbreak{}")

local meta_weights = nil

local function plain_len(blocks)
  return #(pandoc.utils.stringify(blocks) or "")
end

local function has_code_or_ident(blocks)
  local found = false
  pandoc.walk_block(pandoc.Div(blocks), {
    Code = function()
      found = true
    end,
    Str = function(s)
      if s.text:find("_") or s.text:find("%u%l+%u") then
        found = true
      end
    end
  })
  return found
end

local function cell_score(blocks)
  local text = pandoc.utils.stringify(blocks) or ""
  local len = #text
  if len == 0 then
    return 1
  end
  local score = len
  if has_code_or_ident(blocks) then
    score = score * 1.35
  end
  local longest = 0
  for token in text:gmatch("%S+") do
    if #token > longest then
      longest = #token
    end
  end
  if longest > BREAK_LEN then
    score = score + longest * 0.5
  end
  return score
end

local function estimate_widths(headers, rows, ncols)
  local scores = {}
  for i = 1, ncols do
    scores[i] = 1
  end

  if headers then
    for i = 1, math.min(ncols, #headers) do
      local s = cell_score(headers[i])
      if s > scores[i] then
        scores[i] = s
      end
    end
  end

  for _, row in ipairs(rows or {}) do
    for i = 1, math.min(ncols, #row) do
      local s = cell_score(row[i])
      if s > scores[i] then
        scores[i] = s
      end
    end
  end

  if meta_weights and #meta_weights >= ncols then
    for i = 1, ncols do
      local w = tonumber(meta_weights[i]) or scores[i]
      scores[i] = math.max(w, 0.01)
    end
  end

  local sum = 0
  for i = 1, ncols do
    sum = sum + scores[i]
  end
  if sum <= 0 then
    sum = ncols
    for i = 1, ncols do
      scores[i] = 1
    end
  end

  local widths = {}
  for i = 1, ncols do
    local w = scores[i] / sum * TARGET_SUM
    if w < MIN_COL then
      w = MIN_COL
    end
    if w > MAX_COL then
      w = MAX_COL
    end
    widths[i] = w
  end

  local function width_sum(ws)
    local s = 0
    for i = 1, #ws do
      s = s + ws[i]
    end
    return s
  end

  local guard = 0
  while width_sum(widths) > TARGET_SUM + 0.001 and guard < 20 do
    guard = guard + 1
    local excess = width_sum(widths) - TARGET_SUM
    local flex = 0
    for i = 1, ncols do
      if widths[i] > MIN_COL + 0.001 then
        flex = flex + (widths[i] - MIN_COL)
      end
    end
    if flex <= 0 then
      break
    end
    for i = 1, ncols do
      if widths[i] > MIN_COL + 0.001 then
        local share = (widths[i] - MIN_COL) / flex
        widths[i] = math.max(MIN_COL, widths[i] - excess * share)
      end
    end
  end

  local cur = width_sum(widths)
  if cur > 0 and cur < TARGET_SUM - 0.001 then
    local scale = TARGET_SUM / cur
    for i = 1, ncols do
      widths[i] = math.min(MAX_COL, widths[i] * scale)
    end
    cur = width_sum(widths)
    if cur > 0 and cur < TARGET_SUM - 0.001 then
      widths[ncols] = widths[ncols] + (TARGET_SUM - cur)
    end
  end

  return widths
end

-- Split a long unbreakable token into Str / \allowbreak pieces
local function breakable_inlines_from_text(text, as_code, code_attr)
  if #text <= BREAK_LEN or text:find("%s") then
    if as_code then
      return { pandoc.Code(text, code_attr) }
    end
    return { pandoc.Str(text) }
  end

  local out = {}
  local buf = {}
  local function flush()
    if #buf == 0 then
      return
    end
    local piece = table.concat(buf)
    buf = {}
    if as_code then
      table.insert(out, pandoc.Code(piece, code_attr))
    else
      table.insert(out, pandoc.Str(piece))
    end
  end

  local i = 1
  local n = #text
  while i <= n do
    local c = text:sub(i, i)
    table.insert(buf, c)
    local break_here = false
    if c == "_" or c == "-" or c == "." or c == "/" then
      break_here = true
    elseif i >= 2 and i < n then
      -- camelCase: break before uppercase only after 2+ lowercase letters
      -- (avoid splitting mPPR / hPPR into m + PPR)
      local prev = text:sub(i - 1, i - 1)
      local b = text:sub(i + 1, i + 1)
      if prev:match("%l") and c:match("%l") and b:match("%u") then
        break_here = true
      end
    end
    if break_here and i < n then
      flush()
      table.insert(out, ALLOWBREAK)
    end
    i = i + 1
  end
  flush()
  return out
end

local function rewrite_inlines(inlines)
  local out = {}
  for _, inl in ipairs(inlines) do
    if inl.t == "Str" then
      local parts = breakable_inlines_from_text(inl.text, false)
      for _, p in ipairs(parts) do
        table.insert(out, p)
      end
    elseif inl.t == "Code" then
      local parts = breakable_inlines_from_text(inl.text, true, inl.attr)
      for _, p in ipairs(parts) do
        table.insert(out, p)
      end
    elseif inl.t == "Emph" or inl.t == "Strong" or inl.t == "Underline"
        or inl.t == "Strikeout" or inl.t == "Subscript" or inl.t == "Superscript"
        or inl.t == "SmallCaps" then
      inl.content = rewrite_inlines(inl.content)
      table.insert(out, inl)
    elseif inl.t == "Link" or inl.t == "Span" then
      inl.content = rewrite_inlines(inl.content)
      table.insert(out, inl)
    else
      table.insert(out, inl)
    end
  end
  return out
end

local function rewrite_blocks(blocks)
  local out = {}
  for _, bl in ipairs(blocks) do
    if bl.t == "Plain" or bl.t == "Para" then
      bl.content = rewrite_inlines(bl.content)
      table.insert(out, bl)
    else
      -- Nested: walk one level of Div etc.
      local walked = pandoc.walk_block(bl, {
        Plain = function(p)
          p.content = rewrite_inlines(p.content)
          return p
        end,
        Para = function(p)
          p.content = rewrite_inlines(p.content)
          return p
        end
      })
      table.insert(out, walked)
    end
  end
  return out
end

local function table_is_crowded(ncols, headers, rows)
  if ncols >= 5 then
    return true
  end
  local total_chars = 0
  local sample = 0
  if headers then
    for i = 1, #headers do
      total_chars = total_chars + plain_len(headers[i])
      sample = sample + 1
    end
  end
  for _, row in ipairs(rows or {}) do
    for i = 1, #row do
      total_chars = total_chars + plain_len(row[i])
      sample = sample + 1
    end
  end
  if ncols >= 4 and sample > 0 and (total_chars / sample) > 28 then
    return true
  end
  return false
end

local function parse_weights(meta)
  if meta == nil or meta["table-col-weights"] == nil then
    return nil
  end
  local raw = meta["table-col-weights"]
  local weights = {}
  if type(raw) == "table" then
    for _, item in ipairs(raw) do
      local n = tonumber(pandoc.utils.stringify(item))
      if n then
        table.insert(weights, n)
      end
    end
  else
    local s = pandoc.utils.stringify(raw)
    for num in s:gmatch("[0-9.]+") do
      table.insert(weights, tonumber(num))
    end
  end
  if #weights == 0 then
    return nil
  end
  return weights
end

function Pandoc(doc)
  meta_weights = parse_weights(doc.meta)

  local function process_table(el)
    local ncols = #(el.aligns or {})
    if ncols == 0 and el.headers then
      ncols = #el.headers
    end
    if ncols == 0 then
      return el
    end

    if el.headers then
      for i = 1, #el.headers do
        el.headers[i] = rewrite_blocks(el.headers[i])
      end
    end
    if el.rows then
      for r = 1, #el.rows do
        for c = 1, #el.rows[r] do
          el.rows[r][c] = rewrite_blocks(el.rows[r][c])
        end
      end
    end

    el.widths = estimate_widths(el.headers, el.rows, ncols)

    if table_is_crowded(ncols, el.headers, el.rows) then
      return {
        pandoc.RawBlock("latex", "\\begingroup\\footnotesize"),
        el,
        pandoc.RawBlock("latex", "\\endgroup")
      }
    end
    return el
  end

  doc.blocks = pandoc.walk_block(pandoc.Div(doc.blocks), {
    Table = process_table
  }).content

  return doc
end
