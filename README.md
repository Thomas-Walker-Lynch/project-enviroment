# project_share

This document explains how Thomas sets up his projects.

A ‘project’ is something that a group of people may work on simultaneously, or in series,
while each person does small tasks.  Some tasks may be done in parallel, while others have
dependencies.  Specifically in this case we are talking about projects for developing
software.

(push pull need to be updated for the submodules stuff)

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
We will resolve this problem by using a couple of two word short names:

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
    project_share/   <--- resources and tools under the user directory
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
    customer_gateway_master/
    subu/ 
    tm/
    ws4_master/   <--- a project environment directory
      LICENSE
      README.md
      env/
         bin/
         lib/
         include/
      tmp/
      uWebSockets/
      ws4/   <--- a project home environment
```

Scripts common to all of my projects are in `project_share`. This consists mostly of
executables, so I stuck it under `bin`.  I added the following to my `.bashrc`:

```
 export PATH=~/bin:~/bin/project_share:"$PATH"

```

`project_share` is a repo, and I created it with the commands:


```
> cd ~/bin
> git clone git@github.com:Thomas-Walker-Lynch/project_share.git
```

It is important that each time `project_share` is updated from the repo that an audit is
done.  This is an attempt to prevent mischief from fellow developers.  For example we
wouldn't want `pull` to instead run a program that draws a chu-chu train in the terminal
while email spaming all our colleauges, or worse. Pay close attention to the messages
printed out by git so that you know which files to look at during the audit.  Chances are
you will not pull `project_share` very often.

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

`ws4_dev` is a project environment. It also comes from a git repo. Inside this project
environment we have a couple of git submodule: `uWebSockets` and `ws4`.

`ws4` is the project home. It contains the source code we are developing.  `uWebSockets` is
someone elses github project which we are making use of.

## Repo and Directory Naming

The directory name for a project environment has two parts separated by an underscore,
`<name>_<version>`.  Conventionally I call the project environment directory for the code
that is actively being developed `<name>_master` (in older code it is called
`<name>_dev`).  

Here is another example listing of my projects directory

```
> cd ~/projects
> ls
    customer_gateway_master
    customer_gateway_v1.0
    customer_gateway_v2.0
```

These all come from the repo named `customer_gateway_env` on github.  All my repos for
project environments have a `_env` suffix.  I follow the convention of first expanding the
project environment repo and then changing the suffix to be the same as the branch if that
is practical, otherwise some variation of that.

This is how the `customer_gateway_master` project environment directory was made:

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

  If there is not already a `projects` directory in your home directory:
  ```
    > mkdir ~/projects
  ```

  Then, 
  ```
    > cd ~/projects
    > git clone git@github.com/<user>/<project>_env.git
    > mv <project>_env <project>_master 
    > cd <project>_master
    > 
  ```

  Note in the line that moves the cloned repo `<project>_master` you might use a different
  suffix than `master`.  Conventionally the suffix is the branch to be checked out and
  worked on inside the project home directory, which in turn is the release version or ‘master’ 
  for unreleased code, but the suffix could be anything.


2. for submodules that have not yet been added:

  ```
    > git submodule add https://github.com/../<resource_project>
    > git submodule add https://github.com/../<resource_project>
    ...

  ```
   Etc. for the other modules


3. for submodules were added before but appear as empty directories:

  ```
    > git submodule init
    > git submodule update
  ```

4. audit, legible scripts, and binary executables

  These rules are best practice.
  
  New files on a clone or pull should be audited.  

  It is best to not have any executables pulled in the repo, text or binary. 

  The `project_share` repo has executable text scripts. You know this when you download
  it, and should do a careful audit.  Unlike a project under development, this repo does
  not change often, so a careful audit is possible.
  
  Binary executables are unauditable, consequently they are barred from the repos. It is
  permissible, of course, for a build process to create a binary executable from source
  files in a repo.  Source files are auditable.  Often times this is the whole point of
  a repo.

  `<project>_env` repos most typically have an `env` subdirectory, which in turn has `bin`
  and `lib` subdirectories. The language environment might put executables into these
  directories. Consequently, we typically do not put the `env` file nor its contents into
  a repo.  You will typically find it listed in `.gitignore`.

  However, there is a security hole in that `.gitignore` does not apply to pulled content,
  so another developer with access to the repo could make it so that when we pull, the `env`
  directory is given executable contents.  git gives us no feature to prevent this.  So
  when you do a `git pull`, or `git clone`, for a `<project>_env` repo be careful to check
  that nothing is pulled into `env` subdirectory. Chances are this is not too much trouble
  as `<project>_env` is typically cloned once and then used there after.  The action occurs
  in the project's home directory.

  If you use the `push` and `pull` wrappers in `project_share`, they will scan for
  executables and block them from being pushed/pulled to/from the repo for the project.



5. check the .gitignore

 Conversely, we also do not want to add clutter to the repo ourselves, so you will
 want to have a .gitignore.  This might be part of the project, check after a clone.

 It should contain:

  ```
      env/
      tmp/
      .*
      !.gitignore
      *~
      *.o
  ```

  This is setup to exclude the env and tmp directories, hidden files (except for .gitignore),
  files suffixed by a tilda, and compiler object files.

    Additionally for a python project:
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

  Note, unless you explicitly disallow it, .gitignore will be pushed back to the repo.

6. To work in the project:

   First enter a shell with a dedicated environment

  ```
     start <project> <version>
  ```

  As noted above `<version>` is typically the name of the branch that will be expanded out
  in the project home directory.

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


(`push` and `pull` have not been updated to work with the new project tree yet.)

