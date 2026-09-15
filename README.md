# Scripts

A collection of small Linux utilities and GitHub helpers, organized as one
directory you can symlink into your `PATH`.

## Quick install

```bash
./install.sh                 # symlinks scripts into ~/.local/bin
./install.sh ~/bin           # or choose another directory
```

Make sure the target directory is in your `PATH`:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

## Scripts

| Script | Purpose |
|--------|---------|
| [`list-apps.sh`](#list-appssh) | List installed apps grouped by desktop-file category |
| [`check-app.sh`](#check-appsh) | Find which package manager installed an app |
| [`gh-repos.sh`](#gh-repossh) | Print GitHub repos as a Markdown table; or maintain a tracker |
| [`ct_template`](#ct_template) | Scaffold a minimal HTML/CSS/JS project |
| [`list-agents.sh`](#list-agentssh) | Detect installed AI agent CLIs and install method |
| [`clip-board/clipboard.sh`](#clip-boardclipboardsh) | Copy/paste clipboard text (Wayland + X11) |
| [`budget_split.py`](#budget_splitpy) | Split income using the 50/30/20 rule |

### `list-apps.sh`

Reads `.desktop` files from `/usr/share/applications` and `~/.local/share/applications`.

```bash
./list-apps.sh              # full listing (categories + apps + totals)
./list-apps.sh categories   # categories only, with counts
./list-apps.sh Network      # filter by one category
```

### `check-app.sh`

```bash
./check-app.sh firefox      # checks dpkg, snap, flatpak, and .AppImage
```

Reports which package manager owns the app and prints version/details.

### `gh-repos.sh`

Requires the [`gh` CLI](https://cli.github.com/) and `jq`. The GitHub username
comes from `$GH_USER` and falls back to the logged-in OS user.

```bash
./gh-repos.sh               # one-shot table: name/description/stars/forks
./gh-repos.sh --simple      # same as above
./gh-repos.sh --track       # update github_repos.md, keeping manual Status edits
```

`--track` regenerates only the table between the
`<!-- AUTO-GENERATED START -->` / `<!-- AUTO-GENERATED END -->` markers, so you
can keep notes and a manual `Status` column in the same file.

### `ct_template`

```bash
./ct_template my-site       # creates my-site/index.html, style.css, script.js
```

Fails if the directory already exists.

### `list-agents.sh`

```bash
./list-agents.sh
```

Checks PATH for common AI agent CLIs and guesses the install method from the
binary path and available package managers.

### `clip-board/clipboard.sh`

```bash
echo "Hello World" | ./clip-board/clipboard.sh copy
./clip-board/clipboard.sh paste
```

Uses `wl-copy`/`wl-paste` on Wayland, falling back to `xclip`/`xsel` on X11.

### `budget_split.py`

```bash
./budget_split.py 5000
```

Splits an amount into needs (50%), wants (30%), and savings (20%).

## Development

Every `.sh` script passes [ShellCheck](https://www.shellcheck.net/):

```bash
shellcheck *.sh clip-board/*.sh ct_template
```

A GitHub Actions workflow runs ShellCheck on every push.