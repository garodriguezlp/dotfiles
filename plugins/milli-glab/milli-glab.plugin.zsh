
# Some utility functions for working with GitLab

# --- -----------------------------------------------------------------------
# --- Environment variables
# --- -----------------------------------------------------------------------
export GITLAB_HOST=https://gitlab.devops.fnbo.io
export GITLAB_G_BACLOG_PROJECT="core-phoenix/team-transact/backlog"
export GITLAB_G_USER="gustavo"
export GITLAB_G_REVIEWERS="jguerrero,jmcneal,evans,mrahate,schallagulla,fernando,joaquin"

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

# --- -----------------------------------------------------------------------
# --- Mark MR as ready for review
# --- -----------------------------------------------------------------------
fun glab-mr-ready-for-review() {

    # Check if the MR number was provided
    if [ -z "$1" ]; then
        echo "Usage: glab-mr-ready-for-review <mr-number>"
        return 1
    fi

    # Check if the MR exists
    if ! output=$(glab mr view $1 2>/dev/null); then
        echo "MR $1 does not exist"
        return 1
    fi

    # Display the first 2 lines of the output
    echo "$output" | head -n 2

    # Validate if the user wants to continue
    vared -p "Are you sure you want to mark this MR as ready for review? [y/N]" -c reply
    if [[ ! $reply =~ ^[Yy]$ ]]; then
        return 1
    fi

    echo "Marking MR $1 as ready for review, and adding reviewers: $GITLAB_G_REVIEWERS"
    glab mr update $1 \
        --reviewer $GITLAB_G_REVIEWERS \
        --ready
}

# --- -----------------------------------------------------------------------
# --- Issues assigned to me
# --- -----------------------------------------------------------------------
fun glab-issues-assigned-to-me() {
    glab issue list --repo $GITLAB_G_BACLOG_PROJECT --assignee $GITLAB_G_USER
}
