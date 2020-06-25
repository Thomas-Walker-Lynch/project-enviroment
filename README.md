# bin_project

generic project bin directory

This document explains how to make use of this project bin template.

## Summary:
--------

<project_name> is the nane of your project.

My convention for a project directory structure goes like this:

  projects
         ╘<project_name>_dev
          ┝ LICENSE/COPYRIGHT
          ╞ bin  <- from bin_project.git
          ┝ env  <- this holds executables and libraries to be used for the project
          ┝ <project_name>  <-  from <project>.git
         ...

Only bin and <project_name> directories come from the repo.  The rest is
are either created manually or by other setup scripts.

You will notice there are two layers.  The top layer is <project_name>_dev
and it is not tied to any repo.  There is no .git file in this directory.

At the second level down there is the directory <project_name>_dev/<project_name>. This
directory has the main .git file in it.

The project_name/div/bin directory also has a .git file in it.  This bin directory
has generic project scripts in it, and also this file.


## Directions
--------

1. to make the directory structure:

  If there is not already a projects directory in your home directory:
  ```
    > mkdir ~/projects  # literally called projects
  ```

  Then,
  ```
    > cd ~/projects
    > mkdir <project_name>_dev   # that is the project name with a suffix of '_dev'
    > cd <project>_dev
    > mkdir tmp env env/bin env/lib env/include
  ```


2. install the generic project scripts

  ```
    > git clone https://github.com/Thomas-Walker-Lynch/bin_project.git
  ```

    Rename the directory from 'bin_projects' to 'bin'.
    
  ```
    > cd bin
    > git branch <project_name>
    > git checkout <project_name>
  ```

    Note, in the start script there is a PROJECT= variable.  Set that to <project_name>.
    Chances are that is the only changed needed, but review the contents just to be sure.
    
    Go back to the project environment directory
    
  ```
    > cd .. 
  ```

3. install the project 'repo' from github

  ```
    > git clone https://github.com/.../<project_name>.git
  ```

4. be careful about executables and scripts

  There should be no direct to run executables or libraries that come with a pull or clone
  of the repo.  If there are, there is a problem and we should figure out where it is
  coming from.  git rm them.

  .gitignore does not prevent files from being pulled, so .. other project members
  are able to put executables in the repo accidentally (or gosh, hopefully not on
  purpose). 

  Your PATH variable should not point to any directory in the repo, and it should not
  contain the dot directory '.'.   This will prevent accidentally picking up such an
  executable.

  Executables and libraries that we build, and scripts that come with the repo have two
  types.  One type are those that we should install.  After a review, put them in ../env/bin
  ../env/lib ../env/include directories as appropriate.  Others are repo specific, for
  example for building code or testing.  Execute those directly by name, and not through
  your path.

5. check the .gitignore

 Conversely, we also do not want to add clutter to the repo ourselves.   

 .gitignore goes in: ~/<project_name>_dev/<project_name>/.gitignore.  You mightshould get one
 when pulling the project repo.  This file lists things that will not be added when you
 do a git add. (or a push from the bin project scripts).  So no backup files, no test
 executables that are built as part of testing.

 It should contain:

  ```
      tmp/
      .*
      !.gitignore
      *~
      *.o
      **/test
  ```

    And for a python project:
  ```
      __pycache__/
      **/*.pyc
  ```
 
    And for a django project:
  ```
      manage.py
      **/migrations
      .vscode
  ```

  This is setup by default to exclude tmp directories, files who's name starts with
  temp, dot files (except for .gitignore), and files suffixed by a tilda.

  Note, edits to this file will be shared with others on the project. This can
  lead to accidents where a change by one user causes another user's files not
  to get checked into the repo.  Check with git status what files will be
  pushed.

6. To work in the project:

   add an alias in your .bashrc file analogous to this one:

  ```
     alias pcd_pn="/home/thomas/projects/<project_name>/bin/start"
  ```

   here pn stands for 'project name', so you will probably want to change that.
   The command:

  ```
    > pcd_pn
  ```

   will then open a new shell with the pwd set to the project repo directory and the PATH
   setup to pull commands from the project environment.  When finished with the project,
   exit the shell.

   One in the project directory you should use the command

  ```
     > pull
  ```

   to pull from the repo.  And

  ```
     > push
  ```

   to add, commit, and push to the repo.  If things get out of sync, fix them using
   the usual git commands.  For example, if push fails you might have to git commit -m and
   git push to get the code pushed.




