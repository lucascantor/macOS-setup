# macOS Setup

1. Copy private SSH and GPG keys to `ssh-keys` and `gpg-keys`
2. Run `./setup.sh` to perform the following:

- Confirm private keys in place to restore
- Clear NVRAM
- Install Homebrew
  - Install software via Homebrew
  - Install software via Homebrew Cask
  - Install Mac App Store apps via mas
- Configure general UI/UX settings
- Configure security settings
- Configure Dock settings
- Configure screenshot defaults
- Configure Safari settings
- Configure TextEdit settings
- Configure Git
  - Install setgit
- Configure .bash_profile
- Configure GPG
- Configure SSH

## Contributing workflow

Here’s how we suggest you go about proposing a change to this project:

1. [Fork this project][fork] to your account.
2. [Create a branch][branch] for the change you intend to make.
3. Make your changes to your fork.
4. [Send a pull request][pr] from your fork’s branch to our `master` branch.

Using the web-based interface to make changes is fine too, and will help you
by automatically forking the project and prompting to send a pull request too.

[fork]: https://help.github.com/articles/fork-a-repo/
[branch]: https://help.github.com/articles/creating-and-deleting-branches-within-your-repository
[pr]: https://help.github.com/articles/using-pull-requests/

## License

[MIT License](./LICENSE).