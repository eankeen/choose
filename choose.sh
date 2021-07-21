#!/usr/bin/env bash

# async issues with +u when sourcing
set -Eo pipefail

DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# ------------------------- start ------------------------ #
source "$DIR/lib/do.sh"
source "$DIR/lib/helper.sh"
source "$DIR/lib/plumbing.sh"
source "$DIR/lib/util.sh"

dbDir="${CHOOSE_DB_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/choose/db}"

main() {
	declare -A args=()
	declare -a argsCommands=()

	# shellcheck disable=SC1091
	source bash-args parse "$@" <<-"EOF"
	@arg launch - (category) Launches the default program in a particular category
	@arg set - (category) (application) Sets the default program in a particular category
	@flag [gui] - Whether to open a GUI
	@flag [help.h] - Show help menu
	@flag [version.v] - Show version
	EOF

	if [ -z "${argsCommands[0]}" ]; then
		printf "%s\n" "$argsHelpText"
		log.die "$gui" 'No subcommand found'
	fi

	local gui="${args[gui]}"

	case "${argsCommands[0]}" in
	set)
		local category="${argsCommands[1]}"
		local program="${argsCommands[2]}"

		do_set "$category" "$program" "$gui"
		;;
	launch)
		local category="${argsCommands[1]}"

		do_launch "$category" "$gui"
		;;
	print)
		local category="${argsCommands[1]}"

		do_print "$category" "$gui"
		;;
	esac
}

main "$@"
