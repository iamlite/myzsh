# Homebrew — set up the environment only if a brew binary actually exists.
# The 2023 version of this file ran `eval "$(/opt/homebrew/bin/brew shellenv)"`
# unguarded; a missing or broken brew would print errors into every login
# shell. Probing both install prefixes keeps this silent on any machine.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Setting PATH for Python 3.11 (python.org installer)
# The original version is saved in .zprofile.pysave
# Guarded: machines without the framework install skip this silently.
if [[ -d "/Library/Frameworks/Python.framework/Versions/3.11/bin" ]]; then
  PATH="/Library/Frameworks/Python.framework/Versions/3.11/bin:${PATH}"
  export PATH
fi
