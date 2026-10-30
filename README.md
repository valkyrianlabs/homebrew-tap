# Valkyrian Labs Tap

Homebrew formulae from Valkyrian Labs: the forti tools for FortiGate (`forti-cli`, `forti-mcp`,
`forti-hole`, `forti-pihole` and the `forti-api` C++ SDK), `pmdocs` and `vl-release`.

## Install

Name each formula in full. That is the whole install: no `brew tap`, no `brew trust`.

```sh
brew install valkyrianlabs/tap/<formula>
```

For example, the forti CLI with its MCP server, or forti-hole with the CLI that configures its
device profile:

```sh
brew install valkyrianlabs/tap/forti-cli valkyrianlabs/tap/forti-mcp
brew install valkyrianlabs/tap/forti-cli valkyrianlabs/tap/forti-hole
```

Homebrew trusts the formulae named in full on the command line and remembers that, so later
`brew upgrade` runs need nothing more. It does not trust the rest of the tap, so a short name
(`brew tap valkyrianlabs/tap`, then `brew install forti-cli`) is refused until you trust the tap
yourself. Every formula here depends on homebrew/core formulae only, never on another formula from
this tap, which is what lets the one command work.

In a `brew bundle` `Brewfile`, use the full name and mark the formula trusted, as
`brew bundle dump` writes it:

```ruby
brew "valkyrianlabs/tap/<formula>", trusted: true
```

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
