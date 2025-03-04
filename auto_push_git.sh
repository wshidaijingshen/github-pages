#!/bin/bash

GIT_REPO="~/github-pages"
LOG_FILE="~/auto_push_git.log"

echo "Starting auto-push service..." | tee -a $LOG_FILE

# ADD ssh private key 
cd "$GIT_REPO"
ssh-add ~/.ssh/github_id_rsa
# ssh -T git@github.com # error -T 

git remote set-url origin git@github.com:wshidaijingshen/github-pages

while true; do
    # Wait for changes in the repository
    EVENTS=$(inotifywait -r -q -e modify,create,delete,moved_to,moved_from "$GIT_REPO" --exclude '^\~\/github-pages\/\.git(\/|$)' )

    # Log the event
    echo "$(date '+%Y-%m-%d %H:%M:%S') - Detected changes: $EVENTS" | tee -a $LOG_FILE
    
    cd "$GIT_REPO"
    
    # Add all changed files
    git add .
    
    # Commit changes with a timestamp message
    COMMIT_MSG="$EVENTS Auto-commit at $(date '+%Y-%m-%d %H:%M:%S')"
    git commit -am "$COMMIT_MSG" || {
        echo "$(date '+%Y-%m-%d %H:%M:%S') - No changes to commit." | tee -a $LOG_FILE
        continue
    }
    
    # Push changes to remote repository
    git pull origin master && git push origin master || {
        echo "$(date '+%Y-%m-%d %H:%M:%S') - Failed to push changes." | tee -a $LOG_FILE
        continue
    }

    echo "$(date '+%Y-%m-%d %H:%M:%S') - Changes pushed successfully." | tee -a $LOG_FILE
done
