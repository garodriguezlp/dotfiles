# Some utility functions for working with GitLab

# --- -----------------------------------------------------------------------
# --- Environment variables
# --- -----------------------------------------------------------------------
export GITLAB_HOST=https://gitlab.devops.fnbo.io
export GITLAB_G_BACLOG_PROJECT="core-phoenix/team-transact/backlog"
export GITLAB_G_USER="gustavo"

# --- -----------------------------------------------------------------------
# --- Assing issue to me and move it to in progress
# --- -----------------------------------------------------------------------
fun glab-issue-assign-to-me() {

    # Check if the issue number was provided
    if [ -z "$1" ]; then
        echo "Usage: glab-issue-assign-to-me <issue-number>"
        return 1
    fi

    # Check if the issue exists
    if ! output=$(glab issue view $1 --repo $GITLAB_G_BACLOG_PROJECT 2>/dev/null); then
        echo "Issue $1 does not exist"
        return 1
    fi

    # Display the first 2 lines of the output
    echo "$output" | head -n 2

    # Validate if the user wants to continue
    vared -p "Are you sure you want to assign this issue to you and move it to in progress? [y/N]" -c reply
    if [[ ! $reply =~ ^[Yy]$ ]]; then
        return 1
    fi

    echo "Assigning issue $1 to $GITLAB_G_USER and moving it to in status::doing"
    glab issue update $1 \
        --repo $GITLAB_G_BACLOG_PROJECT \
        --unlabel "status::todo" \
        --label "status::doing" \
        --assignee $GITLAB_USER
}
