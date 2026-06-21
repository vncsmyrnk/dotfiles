#!/usr/bin/env bash
#
# A simple CLI helper for managing a specific set of dotfiles.

# Bash strict mode
set -euo pipefail
IFS=$'\n\t'

if [ -t 1 ]; then
  RED='\033[0;31m'
  GREEN='\033[0;32m'
  YELLOW='\033[0;33m'
  NC='\033[0m' # No Color
else
  RED=''
  GREEN=''
  YELLOW=''
  NC=''
fi

log_info() { echo -e "${GREEN}==>${NC} $*"; }
log_warn() { echo -e "${YELLOW}WARNING:${NC} $*" >&2; }
log_error() { echo -e "${RED}ERROR:${NC} $*" >&2; }
die() {
  log_error "$@"
  exit 1
}

usage() {
  cat <<EOF >&2
Usage: $(basename "$0") [flags] <action> [args]

A simple CLI helper for managing a specific set of dotfiles.

Flags:
  -d, --dir <path>    Override the default dotfiles repository path
  -f, --force         Pull updates even if a repository has uncommitted changes
  -h, --help          Show this help message and exit

Actions:
  pull                Pulls latest repo updates for root and submodules
  config <target>     Runs the config recipe for a specific submodule or '--all' / '-a'
  unset-config <tgt>  Unsets the config recipe for a specific submodule or '--all' / '-a'

Examples:
  $(basename "$0") pull
  $(basename "$0") config nvim
  $(basename "$0") config --all
EOF
}

require_tool() {
  if ! command -v "$1" >/dev/null 2>&1; then
    die "'$1' is required but not installed. Aborting."
  fi
}

require_tool git
require_tool awk

INSTALL_DIR_PLACEHOLDER=""
DEFAULT_DIR="${INSTALL_DIR_PLACEHOLDER:-$(dirname "$(realpath "${BASH_SOURCE[0]}")")}"
DOTFILES_DIR="${DOTFILES_DIR:-$DEFAULT_DIR}"

FORCE_PULL=false

parse_args() {
  ACTION=""
  ARGS=()

  while [[ $# -gt 0 ]]; do
    case "$1" in
    -d | --dir)
      if [[ -n "${2:-}" ]]; then
        DOTFILES_DIR="$2"
        shift 2
      else
        log_error "Missing argument for $1"
        usage
        exit 1
      fi
      ;;
    -f | --force)
      FORCE_PULL=true
      shift
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    -*)
      log_error "Unknown flag: $1"
      usage
      exit 1
      ;;
    *)
      if [[ -z "$ACTION" ]]; then
        ACTION="$1"
      else
        ARGS+=("$1")
      fi
      shift
      ;;
    esac
  done

  if [[ -z "$ACTION" ]]; then
    log_error "Missing action."
    usage
    exit 1
  fi
}

# --- Core Logic ---

get_submodules() {
  if [[ -f .gitmodules ]]; then
    git config --file .gitmodules --get-regexp path | awk '{ print $2 }'
  fi
}

run_config() {
  local target_dir="$1"
  (
    cd "$target_dir" || die "Failed to enter directory $target_dir"
    if [[ -f ./justfile ]]; then
      require_tool just
      just config
    elif [[ -f ./Makefile || -f ./makefile || -f ./GNUmakefile ]]; then
      require_tool make
      make PREFIX="$HOME/.local" install
    else
      die "No config recipe found in $target_dir."
    fi
  )
}

run_unset_config() {
  local target_dir="$1"
  (
    cd "$target_dir" || die "Failed to enter directory $target_dir"
    if [[ -f ./justfile ]]; then
      require_tool just
      just unset-config
    elif [[ -f ./Makefile || -f ./makefile || -f ./GNUmakefile ]]; then
      require_tool make
      make PREFIX="$HOME/.local" uninstall
    else
      die "No config recipe found in $target_dir."
    fi
  )
}

pull_with_confirmation() (
  local repo="$1"
  local behind
  local user_reply=""

  command cd "$repo" || return 1
  if ! git diff-index --quiet HEAD --; then
    if [[ "$repo" != "." ]] && [[ "$FORCE_PULL" != true ]]; then
      log_warn "Repository '$repo' has uncommitted changes. Skipping pull."
      return 0
    else
      log_warn "Repository '$repo' has uncommitted changes, but proceeding anyway."
    fi
  fi

  git fetch --quiet

  default_branch=$(git symbolic-ref refs/remotes/origin/HEAD --short | grep -Po '/\K[a-zA-Z0-9-/]+')
  behind=$(git rev-list --count "HEAD..$default_branch" 2>/dev/null || true)
  if [[ -z "$behind" ]]; then
    log_warn "No upstream branch configured for '$repo'. Skipping."
    return 1
  fi

  if [[ "$behind" -eq 0 ]]; then
    log_info "Repository '$repo' is up to date."
    return 0
  fi

  log_info "Repository '$repo' is behind by $behind commit(s)."
  echo "Recent changes:"
  git log --oneline "HEAD..$default_branch"
  echo

  read -r -p "Do you want to pull these updates for '$repo'? [y/N] " -n 1 user_reply
  echo

  if [[ "$user_reply" =~ ^[Yy]$ ]]; then
    git checkout "$default_branch"
    if ! git pull --rebase --autostash; then
      log_error "Failed to pull updates for '$repo'."
      return 1
    fi
  else
    log_info "Skipped pulling updates for '$repo'."
  fi
)

main() {
  parse_args "$@"

  trap 'echo; log_error "Aborted by user."; exit 130' INT TERM

  cd "$DOTFILES_DIR" || die "Failed to enter dotfiles repository at '$DOTFILES_DIR'. Was it moved or deleted?"

  case "$ACTION" in
  pull)
    if ! submodule_status=$(git submodule status) || grep -qP '^-' <<<"$submodule_status"; then
      git submodule update --init --recursive
    fi
    pull_with_confirmation "."

    for config in $(get_submodules); do
      pull_with_confirmation "$config" 2>&1
    done
    ;;
  config)
    local target="${ARGS[0]:-}"
    if [[ -z "$target" ]]; then
      log_error "Action 'config' requires a target name or '--all'."
      usage
      exit 1
    fi

    if [[ "$target" == "--all" || "$target" == "-a" ]]; then
      for config in $(get_submodules); do
        run_config "$config"
      done
    else
      run_config "$target"
    fi
    ;;
  unset-config)
    local target="${ARGS[0]:-}"
    if [[ -z "$target" ]]; then
      log_error "Action 'unset-config' requires a target name or '--all'."
      usage
      exit 1
    fi

    if [[ "$target" == "--all" || "$target" == "-a" ]]; then
      for config in $(get_submodules); do
        run_unset_config "$config"
      done
    else
      run_unset_config "$target"
    fi
    ;;
  *)
    log_error "Undefined action '$ACTION'."
    usage
    exit 1
    ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  main "$@"
fi
