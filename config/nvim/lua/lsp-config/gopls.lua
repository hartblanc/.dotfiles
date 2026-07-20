return {
  settings = {
    gopls = {
      directoryFilters = { '-plz-out' },
      linksInHover = false,
      usePlaceholders = false,
      semanticTokens = true,
      codelenses = {
        gc_details = true,
      },
    },
  },
}
