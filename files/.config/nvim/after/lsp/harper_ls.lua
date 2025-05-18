vim.lsp.config("harper_ls", {
  settings = {
    -- See the `configuration` key-pairs over here:
    --
    -- ```bash
    -- curl https://raw.githubusercontent.com/Automattic/harper/refs/heads/master/packages/vscode-plugin/package.json | jq .contributes.configuration
    -- curl https://surl.hackandbash.com/asdasdas | jq .contributes.configuration
    -- ```
    ["harper-ls"] = {
      linters = {
        -- This rule looks for run-on sentences, which can make your work harder to grok.
        LongSentences = false,
        -- The opening word of a sentence should almost always be capitalized.
        SentenceCapitalization = false,
        -- This rule looks for phrasal verbs written as compound nouns.
        PhrasalVerbAsCompoundNoun = false,
        -- Ensures `to-do` is correctly hyphenated.
        ToDoHyphen = false,
      },
    },
  },
})
