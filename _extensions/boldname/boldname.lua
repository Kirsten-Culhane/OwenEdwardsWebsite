-- I've stolen this from https://www.neilwright.uk/posts/quarto-bibliography-format-name
-- I don't know how to write lua. Please do not take this as a positive example!
local highlight_author_filter = {
  Para = function(el)
    for k,_ in ipairs(el.content) do
      -- Get "Wilson Black, Joshua"
          if el.content[k].t == "Str" and el.content[k].text == "Wilson"
          and el.content[k+1].t == "Space"
          and el.content[k+2].t == "Str" and el.content[k+2].text == "Black," 
          and el.content[k+3].t == "Space"
          and el.content[k+4].t == "Str" and el.content[k+4].text:find("^Joshua") then
              local _,e = el.content[k+4].text:find("^Joshua")
              local rest = el.content[k+4].text:sub(e+1) 
              el.content[k] = pandoc.Strong { pandoc.Str("Wilson") }
              el.content[k+1] = pandoc.Space()
              el.content[k+2] = pandoc.Strong { pandoc.Str("Black,") }
              el.content[k+3] = pandoc.Space()
              el.content[k+4] = pandoc.Strong { pandoc.Str("Joshua" .. rest)}
        -- Get "Joshua Wilson Black"
          elseif el.content[k].t == "Str" and el.content[k].text == "Joshua"
          and el.content[k+1].t == "Space"
          and el.content[k+2].t == "Str" and el.content[k+2].text == "Wilson" 
          and el.content[k+3].t == "Space"
          and el.content[k+4].t == "Str" and el.content[k+4].text:find("^Black") then
              local _,e = el.content[k+4].text:find("^Black")
              local rest = el.content[k+4].text:sub(e+1) 
              el.content[k] = pandoc.Strong { pandoc.Str("Joshua") }
              el.content[k+1] = pandoc.Space()
              el.content[k+2] = pandoc.Strong { pandoc.Str("Wilson") }
              el.content[k+3] = pandoc.Space()
              el.content[k+4] = pandoc.Strong { pandoc.Str("Black" .. rest)}
        -- Get "Black, Joshua David"
          elseif el.content[k].t == "Str" and el.content[k].text == "Black,"
          and el.content[k+1].t == "Space"
          and el.content[k+2].t == "Str" and el.content[k+2].text == "Joshua" 
          and el.content[k+3].t == "Space"
          and el.content[k+4].t == "Str" and el.content[k+4].text:find("^David") then
              local _,e = el.content[k+4].text:find("^David")
              local rest = el.content[k+4].text:sub(e+1) 
              el.content[k] = pandoc.Strong { pandoc.Str("Black, Joshua David") }
              el.content[k+1] = pandoc.Str(rest)
              table.remove(el.content, k+2)
              table.remove(el.content, k+3)
        -- Get "Joshua Black"
          elseif el.content[k].t == "Str" and el.content[k].text == "Joshua"
          and el.content[k+1].t == "Space"
          and el.content[k+2].t == "Str" and el.content[k+2].text:find("^Black") then
              local _,e = el.content[k+2].text:find("^Black")
              local rest = el.content[k+2].text:sub(e+1) 
              el.content[k] = pandoc.Strong { pandoc.Str("Joshua Black") }
              el.content[k+1] = pandoc.Str(rest)
              table.remove(el.content, k+2)
        -- Get "Black, Joshua"
          elseif el.content[k].t == "Str" and el.content[k].text == "Black,"
          and el.content[k+1].t == "Space"
          and el.content[k+2].t == "Str" and el.content[k+2].text:find("^Joshua") then
              local _,e = el.content[k+2].text:find("^Joshua")
              local rest = el.content[k+2].text:sub(e+1) 
              el.content[k] = pandoc.Strong { pandoc.Str("Black, Joshua") }
              el.content[k+1] = pandoc.Str(rest)
              table.remove(el.content, k+2)
          end
    end
    return el
  end
}

function Div (div)
  if div.identifier:find("^ref-") then
    return pandoc.walk_block(div, highlight_author_filter) 
  end
  return nil
end
