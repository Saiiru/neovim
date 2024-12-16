return {
  "chrisgrieser/nvim-various-textobjs",
  opts = {
    keymaps = {
      -- Desativa keymaps padrões, permitindo configurações personalizadas
      useDefaults = false,
    },
  },
  vscode = true, -- Indica que o plugin possui integração com o VSCode
  -- stylua: ignore
  keys = {
    -- Markdown Links
    { "im", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("inner") end, desc = "Markdown Link (Inner)" },
    { "am", ft = { "markdown", "toml" }, mode = { "o", "x" }, function() require("various-textobjs").mdlink("outer") end, desc = "Markdown Link (Outer)" },

    -- Markdown Code Block
    { "iC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("inner") end, desc = "Markdown Code Block (Inner)" },
    { "aC", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdFencedCodeBlock("outer") end, desc = "Markdown Code Block (Outer)" },

    -- Markdown Emphasis (Bold/Italic)
    { "ie", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("inner") end, desc = "Markdown Emphasis (Inner)" },
    { "ae", ft = { "markdown" }, mode = { "o", "x" }, function() require("various-textobjs").mdEmphasis("outer") end, desc = "Markdown Emphasis (Outer)" },

    -- Python Triple Quotes
    { "iy", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("inner") end, desc = "Python Triple Quotes (Inner)" },
    { "ay", ft = { "python" }, mode = { "o", "x" }, function() require("various-textobjs").pyTripleQuotes("outer") end, desc = "Python Triple Quotes (Outer)" },

    -- CSS Selectors
    { "iC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("inner") end, desc = "CSS Selector (Inner)" },
    { "aC", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssSelector("outer") end, desc = "CSS Selector (Outer)" },

    -- CSS Colors
    { "i#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("inner") end, desc = "CSS Color (Inner)" },
    { "a#", ft = { "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").cssColor("outer") end, desc = "CSS Color (Outer)" },

    -- Shell Pipes
    { "iP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("inner") end, desc = "Shell Pipe (Inner)" },
    { "aP", ft = { "sh" }, mode = { "o", "x" }, function() require("various-textobjs").shellPipe("outer") end, desc = "Shell Pipe (Outer)" },

    -- HTML Attributes
    { "iH", ft = { "html", "xml", "css", "scss", "less" }, mode = { "o", "x" }, function() require("various-textobjs").htmlAttribute("inner") end, desc = "HTML Attribute (Inner)" },

    -- Values and Keys in JSON/Other Formats
    { "iv", mode = { "o", "x" }, function() require("various-textobjs").value("inner") end, desc = "Value (Inner)" },
    { "av", mode = { "o", "x" }, function() require("various-textobjs").value("outer") end, desc = "Value (Outer)" },
    { "ik", mode = { "o", "x" }, function() require("various-textobjs").key("inner") end, desc = "Key (Inner)" },
    { "ak", mode = { "o", "x" }, function() require("various-textobjs").key("outer") end, desc = "Key (Outer)" },

    -- Link (URL)
    { "L", mode = { "o", "x" }, function() require("various-textobjs").url() end, desc = "URL Link" },

    -- Numbers (Inner/Outer)
    { "iN", mode = { "o", "x" }, function() require("various-textobjs").number("inner") end, desc = "Number (Inner)" },
    { "aN", mode = { "o", "x" }, function() require("various-textobjs").number("outer") end, desc = "Number (Outer)" },
  },
}
