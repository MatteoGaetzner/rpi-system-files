#! /bin/sh

DIRSIZE_LIMIT=25000

pnotify "Backing up to GitHub ..."

# zsh
rsync -av ~/.zprofile ~/Sync/System/Zsh/.zprofile
rsync -av ~/.zshrc ~/Sync/System/Zsh/.zshrc

# ssh
rsync -av ~/.ssh/authorized_keys ~/Sync/System/Ssh/authorized_keys
rsync -av ~/.ssh/config ~/Sync/System/Ssh/config

dirsize=$(du ~/Sync/System | tail -n 1 | sed 's/\t.*//')

if [[ $dirsize -ge $DIRSIZE_LIMIT ]]; then
  perror "You probably tried to backup some very large files. Check if you really want to commit $dirsize bytes."
else
  git -C ~/Sync/System pull
  git -C ~/Sync/System add .
  git -C ~/Sync/System commit-status
  git -C ~/Sync/System push
fi

psuccess "Backup to GitHub done."
