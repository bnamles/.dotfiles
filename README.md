# Setup after cloning

```shell
chmod +x setup.sh
chmod +x stow.sh
./setup.sh
```

# Update
```shell
brew bundle dump --file=~/.dotfiles/Brewfile.mac.work --force
```

Check differences and then commit.

# Todo
- [] Install automatically fzf-git
- [] Install automatically lazyvim
- [] Copy bat themes to correct folders or create and grab them directly from source (github) and set the theme correctly afterwards
- [] Support linux systems
- [] Automate brew updates - https://github.com/theoomoregbee/dotfiles/tree/master/hooks
- [] Use `bundle dump --describe` for better readability
- [] Consider https://respawn.io/posts/dotfiles-brew-bundle-and-mackup
- [] Update stew.sh to make removal optional, instead allow backup and restore from backup. Notify user of removal and make it opt-in
- [] Automatically create folder ~/.repos/clones/ and git clone https://github.com/junegunn/fzf-git.sh.git to
- [] Source ~/.zshrc file at the end of the process
- [] Install rust automatically via the shell (not via brew) 
- [] Track vscode global settings
- [] Add different .gitignore files depending on environment (work/private)
