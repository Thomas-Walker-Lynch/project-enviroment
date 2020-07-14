# bin_project

Stuff common to projects.

This document explains how to make use of this project bin template.

## Directory Structure:
--------

`<project_name>` is the nane of your project. 

The directory tree starting from the user working on the project typically looks something like
this:
```
  /home/<user>
             ╘projects
                     ╘<project_name>_dev
                      ┝ LICENSE/COPYRIGHT
                      ╞ project  <- from project.git
                      ┝ env  <- this holds executables and libraries to be used for the project
                      ┝ <project_name>  <-  from <project>.git
                     ...
```

Here the user's home directory is `/home/<user>`. Under the home directory the user
has a subdirectory called `projects` where he or she puts all of his projects.  Each
project then has an environment directory.

The environment directory is where we expand out the repo, hold installed programs from
builds, put stuff common to all projects, and expand out other projects that we use as
tools.  The initial project directory is called: `<project_name>_dev`. When a project is
released a new `_dev` version is made, typically from scratch using all the latest tools,
and the release directory is renamed to `<project_name>_<version>`, where `version` is
typically an iso8601 date, but could be a number. Thus the release moves with all of the
environment that made it work.

This approach has been used with our customer_gateway project on the RT server. That
project is the website.

The `<project_name>_dev/<project_name>`directory has the main `.git` file for our project
code. This then gets backed to github or the company server, or wherever. Hence the sources
end up in the repo, and not the environment. We should be able to make a new environment,
pull the sources, and rebuild the project.  The project should have a `requirements.txt` 
file at the top level or in a docs directory. This should list the versions that things
were built with if that seems relevent.

The `<project_name>/div/project` directory also has a `.git` file in it.  This directory
cloned from github (or wherever) has scripts and programs common to all projects. If
local modifications are made be sure to put them on a branch.

Other repos that the project makes use of may also be cloned into the `<project_name>_dev`
directory.


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
    > git clone https://github.com/Thomas-Walker-Lynch/project.git
    > cd project
    > git branch <project_name>
    > git checkout <project_name>
  ```

    Note, in the start script there is a PROJECT= variable.  Set that to <project_name>.
    Chances are that is the only changed needed, but review the contents just to be sure.

    .. Gosh I should make that variable part of environment launch command pcd_<p>,
    .. this has been planeed for a long time ... right now pcd is an alias
    
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




