function auto_source -e fish_prompt -d "Automatically source config.fish when modified"
    set -q FISH_CONFIG_TIME
    if test $status -ne 0
        set -g FISH_CONFIG_TIME (date +%s -r $FISH_CONFIG_PATH)
    else
        set FISH_CONFIG_TIME_NEW (date +%s -r $FISH_CONFIG_PATH)
        if test "$FISH_CONFIG_TIME" != "$FISH_CONFIG_TIME_NEW"
            fsr
            set FISH_CONFIG_TIME (date +%s -r $FISH_CONFIG_PATH)
        end
    end
end
