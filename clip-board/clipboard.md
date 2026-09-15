Great — let’s put everything together into a **Linux clipboard script** that works whether you have `xclip` or `xsel` installed. This way, you can copy and paste text without worrying about which tool is available.

### 📄 Script: `clipboard.sh`
```bash
#!/usr/bin/env bash

# Universal clipboard helper for Linux
# Usage:
#   ./clipboard.sh copy   < input.txt
#   ./clipboard.sh paste

action="$1"

case "$action" in
  copy)
    if command -v xclip &>/dev/null; then
      xclip -selection clipboard
    elif command -v xsel &>/dev/null; then
      xsel --clipboard --input
    else
      echo "No clipboard utility found. Install xclip or xsel."
      exit 1
    fi
    ;;
  paste)
    if command -v xclip &>/dev/null; then
      xclip -selection clipboard -o
    elif command -v xsel &>/dev/null; then
      xsel --clipboard --output
    else
      echo "No clipboard utility found. Install xclip or xsel."
      exit 1
    fi
    ;;
  *)
    echo "Usage: $0 {copy|paste}"
    exit 1
    ;;
esac
```

### 🔧 How to Use
1. Save the script as `clipboard.sh`.
2. Make it executable:
   ```bash
   chmod +x clipboard.sh
   ```
3. Copy text:
   ```bash
   echo "Hello World" | ./clipboard.sh copy
   ```
4. Paste text:
   ```bash
   ./clipboard.sh paste
   ```

---

This gives you a **portable command**: `./clipboard.sh copy` and `./clipboard.sh paste`. You can even add an alias in your `~/.bashrc`:

```bash
alias to_clip="~/clipboard.sh copy"
alias from_clip="~/clipboard.sh paste"
```

Then you can simply run:
```bash
ls | to_clip
from_clip
```

Would you like me to extend this script so it **automatically installs `xclip` or `xsel`** if neither is found, making it completely self-sufficient?
