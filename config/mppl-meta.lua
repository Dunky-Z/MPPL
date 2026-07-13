-- MPPL: chapter-level 指定哪一级 Markdown 标题作为章节；section-numbering 控制自动编号

local function meta_bool(val)
  if type(val) == "boolean" then
    return val
  end
  local s = pandoc.utils.stringify(val):lower()
  return not (s == "false" or s == "no" or s == "0" or s == "off")
end

local function remap_header(el, chapter_level)
  local new_level = el.level - chapter_level + 1
  if new_level < 1 then
    el.level = 1
    table.insert(el.classes, "unnumbered")
  elseif new_level > 6 then
    el.level = 6
  else
    el.level = new_level
  end
  return el
end

function Pandoc(doc)
  local chapter_level = 1
  if doc.meta["chapter-level"] ~= nil then
    chapter_level = tonumber(pandoc.utils.stringify(doc.meta["chapter-level"]))
    if chapter_level == nil or chapter_level < 1 or chapter_level > 6 then
      error("chapter-level 必须是 1 到 6 之间的整数")
    end
  end

  if doc.meta["section-numbering"] ~= nil then
    if not meta_bool(doc.meta["section-numbering"]) then
      doc.meta["disable-section-numbering"] = { pandoc.Str("true") }
    end
  end

  if chapter_level ~= 1 then
    doc.blocks = pandoc.walk_block(pandoc.Div(doc.blocks), {
      Header = function(el)
        return remap_header(el, chapter_level)
      end
    }).content
  end

  return doc
end
