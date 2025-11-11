#!/bin/zsh

# ALTERED VERSION OF DeanAyalon/fmp-migration - DOES NOT MIGRATE CREDENTIALS, uses zsh
# Requires the FileMaker Data Migration Tool (https://community.claris.com/en/s/article/FileMaker-data-migration-tool)

# Context
cd "$(dirname "$0")"
[ -f .env ] && source .env

# Utils
help() {
    if [ -z "$SOLUTION" ]; then 
        echo "Use $0 <source path> <clone path> <migrated path>"
        echo
        echo "  e.g. $0 ./solution.fmp12 ./solution_dev.fmp12 ./solution_migrated.fmp"
        echo '  Migrates from source solution.fmp12 using clone solution_dev.fmp12 into solution_migrated.fmp12'
        echo
        echo
        echo Alternatively, you can set a 'SOLUTION' parameter within .env and run:
        help_solution SOLUTION
        echo
        echo "To create .env, you can run:    echo SOLUTION=myapp > $(dirname "$0")/.env"
    else 
        printf "Use: "
        help_solution $SOLUTION
        echo
        echo SOLUTION is set in .env to $SOLUTION
    fi
    exit $1
}
help_solution() {
    echo "$0 <source suffix> <clone suffix> [migrated suffix]"
    echo
    echo "  e.g. $0 prod dev"
    echo "  Migrates from source ${1}_prod.fmp12 using clone ${1}_dev.fmp12 into ${1}_migrated.fmp12"
}   
fail() {
    echo $@
    exit 1
}

# Validate
[ "$1" = "-h" ] && help 0
[ -z "$2" ] && help 1
[ -z "$SOLUTION" ] && [ -z "$3" ] && help 1
# Check FMDataMigration
FMDataMigration -version &> /dev/null || fail "Please install the FMDataMigrationTool: https://community.claris.com/en/s/article/FileMaker-data-migration-tool"

# Solution paths
src=${${SOLUTION:+${SOLUTION}_$1.fmp12}:-$1}
clone=${${SOLUTION:+${SOLUTION}_$2.fmp12}:-$2}
migrated=${3:-migrated.fmp12}
target=${${SOLUTION:+${SOLUTION}_$migrated}:-$migrated}
echo target: $target

# Credentials prompt
credentials() {
    # Username
    print -n "Username: "
    local user
    read user
    [ -z "$user" ] && return
    ${1}_user="$user"
    # Password
    print -n "Password: "
    stty -echo
    read ${1}_pass
    echo
    stty echo
}
echo SOURCE FILE:
credentials src
echo CLONE FILE:
credentials clone

# Migrate
FMDataMigration -src_path "$src" -src_account "$src_user" -src_pwd "$src_pass" \
    -clone_path "$clone" -clone_account "$clone_user" -clone_pwd "$clone_pass" \
    -target_path "$target" -ignore_valuelists -v > migration.log

# Unset from memory to be safe in case the script is sourced
unset src_pass clone_pass