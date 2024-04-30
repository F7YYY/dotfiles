##################################################################################
#   ________  ___      ________       ___  ___      ________      ________       #
#  |\  _____\|\  \    |\   ____\     |\  \|\  \    |\   __  \    |\   ____\      #
#  \ \  \__/ \ \  \   \ \  \___|_    \ \  \\\  \   \ \  \|\  \   \ \  \___|      #
#   \ \   __\ \ \  \   \ \_____  \    \ \   __  \   \ \   _  _\   \ \  \         #
#    \ \  \_|  \ \  \   \|____|\  \    \ \  \ \  \   \ \  \\  \|   \ \  \____    #
#     \ \__\    \ \__\    ____\_\  \    \ \__\ \__\   \ \__\\ _\    \ \_______\  #
#      \|__|     \|__|   |\_________\    \|__|\|__|    \|__|\|__|    \|_______|  #
#                        \|_________|                                            #
##################################################################################
#
##################################################################################
#	INTERACTIVE
##################################################################################
if status is-interactive
	# Commands to run in interactive sessions can go here
	set fish_greeting
end

##################################################################################
#	CUSTOM
##################################################################################
##-LIBREDEFENDER_COMPLETIONS
complete -c libredefender -n "__fish_use_subcommand" -s D -l data -r -F
complete -c libredefender -n "__fish_use_subcommand" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_use_subcommand" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_use_subcommand" -s C -l colors
complete -c libredefender -n "__fish_use_subcommand" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_use_subcommand" -f -a "scan" -d 'Scan directories for signature matches'
complete -c libredefender -n "__fish_use_subcommand" -f -a "scheduler" -d 'Run a background service that scans periodically'
complete -c libredefender -n "__fish_use_subcommand" -f -a "infections" -d 'List threats that have been detected'
complete -c libredefender -n "__fish_use_subcommand" -f -a "test-notify" -d 'Send a test notification'
complete -c libredefender -n "__fish_use_subcommand" -f -a "dump-config" -d 'Load the configuration and print it as json for debugging'
complete -c libredefender -n "__fish_use_subcommand" -f -a "completions" -d 'Generate shell completions'
complete -c libredefender -n "__fish_use_subcommand" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
complete -c libredefender -n "__fish_seen_subcommand_from scan" -s j -l concurrency -d 'Configure the number of scanning threads, defaults to number of cpu cores' -r
complete -c libredefender -n "__fish_seen_subcommand_from scan" -s D -l data -r -F
complete -c libredefender -n "__fish_seen_subcommand_from scan" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_seen_subcommand_from scan" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_seen_subcommand_from scan" -s C -l colors
complete -c libredefender -n "__fish_seen_subcommand_from scan" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_seen_subcommand_from scheduler" -s D -l data -r -F
complete -c libredefender -n "__fish_seen_subcommand_from scheduler" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_seen_subcommand_from scheduler" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_seen_subcommand_from scheduler" -s C -l colors
complete -c libredefender -n "__fish_seen_subcommand_from scheduler" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_seen_subcommand_from infections" -s D -l data -r -F
complete -c libredefender -n "__fish_seen_subcommand_from infections" -s d -l delete -d 'Interactively offer deletion for every file'
complete -c libredefender -n "__fish_seen_subcommand_from infections" -l delete-all -d 'Delete all files without further confirmation (DANGER!)'
complete -c libredefender -n "__fish_seen_subcommand_from infections" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_seen_subcommand_from infections" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_seen_subcommand_from infections" -s C -l colors
complete -c libredefender -n "__fish_seen_subcommand_from infections" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_seen_subcommand_from test-notify" -s D -l data -r -F
complete -c libredefender -n "__fish_seen_subcommand_from test-notify" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_seen_subcommand_from test-notify" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_seen_subcommand_from test-notify" -s C -l colors
complete -c libredefender -n "__fish_seen_subcommand_from test-notify" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_seen_subcommand_from dump-config" -s D -l data -r -F
complete -c libredefender -n "__fish_seen_subcommand_from dump-config" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_seen_subcommand_from dump-config" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_seen_subcommand_from dump-config" -s C -l colors
complete -c libredefender -n "__fish_seen_subcommand_from dump-config" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_seen_subcommand_from completions" -s D -l data -r -F
complete -c libredefender -n "__fish_seen_subcommand_from completions" -s q -l quiet -d 'Only show warnings'
complete -c libredefender -n "__fish_seen_subcommand_from completions" -s v -l verbose -d 'More verbose logs'
complete -c libredefender -n "__fish_seen_subcommand_from completions" -s C -l colors
complete -c libredefender -n "__fish_seen_subcommand_from completions" -s h -l help -d 'Print help'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "scan" -d 'Scan directories for signature matches'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "scheduler" -d 'Run a background service that scans periodically'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "infections" -d 'List threats that have been detected'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "test-notify" -d 'Send a test notification'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "dump-config" -d 'Load the configuration and print it as json for debugging'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "completions" -d 'Generate shell completions'
complete -c libredefender -n "__fish_seen_subcommand_from help; and not __fish_seen_subcommand_from scan; and not __fish_seen_subcommand_from scheduler; and not __fish_seen_subcommand_frominfections; and not __fish_seen_subcommand_from test-notify; and not __fish_seen_subcommand_from dump-config; and not __fish_seen_subcommand_from completions; and not __fish_seen_subcommand_from help" -f -a "help" -d 'Print this message or the help of the given subcommand(s)'
