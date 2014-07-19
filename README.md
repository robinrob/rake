<<<<<<< HEAD
# Installaton

In order to checkout the HEAD of master for each submodule repo (instead of a detached commit), after cloning the git@bitbucket.org:robinrob/programming.git repo, do this in each git repo that has subdirectories:

## Removing submodules
Update repos.csv.

Then run: deinit.rb

This will remove all references to all submodules.

## Adding submodules
Update repos.csv.

Then run: submodules.rb

This will re-add all submodules and checkout the HEAD of the branch specified in all .gitmodules files instead of checking out a detached commit!

## Initialising submodules
Update repos.csv.

Then run: install.rb

This will init and update (cloning all commit references for each submodule).

=======
>>>>>>> 653d387088fa9b1cc4af8c772a193ee9f7fd1890
# Usage of Rakefile

Examples based on Rakefile functions in this Rakefile:

rake clean
rake save
rake commit