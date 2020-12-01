# project_share

This document explains how Thomas sets up his projects.

A project is something that a group of people may work on simultaneously, or in series, while each does
small tasks.  Some tasks may be done in parallel, while others have dependencies.  Specifically in 
this case we are talking about projects for developing software.

## Where code goes
--------

We have three distinct types of code:

1. the application source code
2. the libraries and other resources the application links into
3. the tools used for building the source code

Let's give these code types short names:

1. source
2. resources
3. tools

We have various places where we might put code:

1. in the system
2. in the developer's user directory
3. in a project environment directory
4. in a dedicated project directory.

Unforunately it is hard to give these one word short names because the term ‘project’
appears in two places, and because the term ‘environment’ already has overloaded meaning.
I see a lot of programmers struggling with the resulting abiguity. Hence we will use some
two word short names:

1. system
2. user
3. project environment
4. project home

Now combining our code and locations into one list:

1. source
   1. project home
2. resources
   1. system
   2. user
   3. project environment
3. tools
   1. system
   2. user
   3. project environment
   
So there is only one place we will find the application code we are developing, and that is 
under the project home directory. Resources that we may need in order to compile our code
will be found either in the system, the user directory, or in the project environment. The
same can be said for the tools we will use.

Here is an example of what this looks like on disk:

```
/home/thomas/
  bin/
    RT-RPC/
    cargo/
    rustup/
    ssh_sunshine.sh
    project_share/
        LICENSE
        README.md
        makefile-cc
        pull
        push
        rm_tilda_files_dir
        rm_tilda_files_tree
        sed_dir
        sed_tree
        start
  Desktop/
  Documents/
  Downloads/
  projects/
    chessgame/
    customer_gateway_dev/
    subu/ 
    tm/
    ws4_dev/
      LICENSE
      README.md
      env/
         bin/
         lib/
         include/
      tmp/
      uWebSockets/
      ws4/
```
I can use a lot of my scripts on many projects, so I put it under my home directory. 
`project_share` consists mostly of scripts, so I stuck it under
`bin`, then added this to my `.bashrc`:

```
 export PATH=~/bin:~/bin/project_share:"$PATH"

```

`project_share` is a repo, and I created it with the commands:


```
> cd ~/bin
> git clone git@github.com:Thomas-Walker-Lynch/project_share.git
```

It is important that each time `project_share` is updated from the repo that an audit is
done.  This is to hopefully prevent mischief from fellow developers.  For example we
wouldn't want `pull` to put use curses to draw chu-chu train in the terminal while email
spaming all your colleauges, or worse. Pay close attention to the messages printed out by
git so that you know which files to look at during the audit.  Chances are you will not pull
`project_share` very often.

The other thing to note about this directory listing is the subdirectory called
`projects`.  This is where I put my project environment directories.  Note, the path
`$HOME/projects` is built into some of the scripts in `project_share`.  Here is the
expansion of just the project `ws4`:

```
   ws4_dev/
     LICENSE
     README.md
     env/
        bin/
        include/
        lib/
     tmp/
     uWebSockets/
     ws4/
```

`ws4_dev` is a project environment. It is a repo. Inside this project environment we have a
number a coupld of git submodule: `uWebSockets` and `ws4`.

`ws4` is the project home. It contains the source code we are developing.  `uWebSockets` is
someone elses github project which we are making use of.

## Directory Naming

The directory name for a project environment has two parts separated by an underscore, `<name>_<branch>`. 
Conventionally I call the project environment that is actively being developed `<name>_master`.  Then
I also call the repo that holds the project environment `<name>_env`.

Here is another example listing of my projects directory

```
> cd ~/projects
> ls
    customer_gateway_master
    customer_gateway_v1.0
    customer_gateway_v2.0
```

The first directory was created with the commands:

```
> cd ~/projects
> git clone git@github.com:Reasoning-Technology/customer_gateway_env.git
> mv customer_gateway_env customer_gateway_master

```

The second directory was created with the commands:

```
> git clone git@github.com:Reasoning-Technology/customer_gateway_env.git
> mv customer_gateway_env customer_gateway_v1.0
> cd customer_gateway_v1.0
> git checkout v1.0

```

So you ask why do we need more than one directory for the same repo? Well in this case I
am running a web server against the v2.0 branch, and it needs to see the files the v2.0.
In general this approach makes it easy to make changes against released code, where those
changes are not immediately, if ever, folded back into the master version.


## How To
--------

1. to make the directory structure:

  If there is not already a projects directory in your home directory:
  ```
    > mkdir ~/projects  # literally called projects
  ```

  Then, 
  ```
    > cd ~/projects
    > git clone .../<project>_env
    > cd <project>_env
    > 
  ```

2. for submodules that have not yet been added:

  ```
    > git submodule add https://github.com/Thomas-Walker-Lynch/project_share.git
    > git submodule add https://github.com/../<project>
    ...

  ```
   Etc. for the other modules

   Note that we add the submodule <project> here,  *not* <project>_<version>. That
   is the actual code we are developing, what we normally think of as a project.


3. for submodules were added before but appear as empty directories:

  ```
    > git submodule init
    > git submodule update
  ```

4. be careful about executables and scripts

  There should be no direct to run executables or libraries that come with a pull or clone
  of the repo.

  .gitignore does not prevent files from being pulled, so .. other project members
  are able to put executables in the repo accidentally (or gosh, hopefully not on
  purpose). 

  Your PATH variable should not point to any directory in the repo, and it should not
  contain the dot directory '.'.   This will prevent accidentally picking up such an
  executable.


5. check the .gitignore

 Conversely, we also do not want to add clutter to the repo ourselves.

 .gitignore can be found both in the project environment and the project home directories.  
 You mightshould get one when pulling the project repo.  This file lists things that will
 not be added when you do a git add. (or a push from the bin project scripts).  So no
 backup files, no test executables that are built as part of testing.

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

   First enter a shell with a dedicated environment

  ```
     start <project> <branch>
  ```

  So for the `ws4` project mentioned above:

  ```
     start ws4
  ```

  The branch defaults to master.  After start runs you will see this prompt:
  
  ```
      2020-12-01T14:56:31Z [ws4_dev]
      thomas@localhost§~/projects/ws4_dev§
      > 
  ```
   
  On the first line, the time shown is UTC in standard iso8601 format.  We use timestamps
  of this form for transcripts and logs.  Following in square brackets you will see the
  name of the project environment directory.

  On the second line we have the user name, machine name, and current working directory.

  Then on the third line we have the prompt. Anything you type appears after that.

  When transcripts appear in this form we can hopefully make sense of what happened if
  we examine them later.

  

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




