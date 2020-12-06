# Project Share

This document explains how I setup my projects both personally and for RT.  This has
evolved into place over some years.  I use git or hg, C, C++, Python, and occasionally Rust,
Django, Common Lisp, Racket, and some other things.

## What is a ‘project’

The term 'project' occurs over and over again so we best define it.

Generally speaking, a ‘project’ consists of a number of tasks for humans to perform.  Some
tasks may be done in parallel, while others have dependencies. There is a science for
managing a team of people who are working on tasks so as to get a project done.

This document describes creating a development tree for a software project.  The directory
is created by expanding one or more git repos.


## Where code goes
--------

We have three distinct types of code:

1. the application source code
2. the libraries and other resources the application makes use of
3. the tools used for building the source code

Let's give these code types short names:

1. source
2. resources
3. tools

We have various places where we might put code:

1. in the system
2. in the developer's user directory
3. in a project environment directory
4. in a project's home directory.

It is hard to give these one word short names because the term ‘project’ appears in two
places, and because the term ‘environment’ already has overloaded meaning.  We will
resolve this problem by using a couple of two word short names:

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
   
So there is only one place we will find the application source code that we are
developing, and that is under the project home directory. Resources that we may need in
order to compile our code will be found either in the system, the user directory, or in
the project environment. The same can be said for the tools we will use.

Here is an example of what this looks like on disk:

```
/home/thomas/
  bin/
    cargo/
    project_share/   <--- resources and tools under the user directory
        LICENSE
        README.md
        makefile-cc
        pull
        push
        rm_tilda_files_tree
        start
    RT-RPC/
    rustup/
    ssh_shine.sh
    sed_tree
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
      ws4/   <--- a project home directory
```

Scripts common to all of my projects are in `project_share`. This consists mostly of
executables, so I stuck `project_share` under my user `bin` directory.  I added the
following to my `.bashrc`:

```
 export PATH=~/bin:~/bin/project_share:"$PATH"

```

If you need to modify a script in `project_share` and do not want to share the changes with
the team, make a copy of the script in your own bin directory and modify it there.  note
`~/bin` appears before `~/bin/project_share`, so the changed script will get picked up
instead of the `project_share` version. For project specific scripts put them in 
the project environment `env/bin`.  Be sure to add `env/bin` to the path in the 
`env/bin/init.sh` script.

`project_share` is a repo, and I created it with the commands:


```
> cd ~/bin
> git clone git@github.com:Thomas-Walker-Lynch/project_share.git
```

It is important that each time `project_share` is updated from the repo that an audit is
done.  This is an attempt to prevent mischief from fellow developers.  For example we
wouldn't want the `pull` to run a program that draws a chu-chu train in the terminal while
email spaming all our colleauges, or worse. Pay close attention to the messages printed
out by git so that you know which files to look at during the audit.

Now looking under my `projects` directory, and expanding out `ws4_master`:


```
   ws4_master/
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

`ws4_master` is a project environment. It also comes from a git repo. Inside this project
environment we have a couple of git submodule: `uWebSockets` and `ws4`.

`ws4_master/ws4` is the project home directory. It contains the source code we are
developing.  

`ws4_master/uWebSockets` is someone else's github project which we are making use of.

Also inside of `ws4_master` we have a directory called `env`. This is used to hold
project specific resources and tools.  Note that the contents of `env` are *not* 
pushed to the repo. Normally `env` holds the results of tool builds.


## Repo and Directory Naming

All my repos for project environments have a `_env` suffix.  Hence they will clone
into directores named `<project>_env`.  After cloning I rename the directory to
`<project>_<version>`, where `<version>` is typically the same name as the branch
that is most commonly checked out in the directory.

The directory name for a project environment has two parts separated by an underscore,
`<name>_<version>`.

Here is another example listing of a projects directory:

```
> cd ~/projects
> ls
    customer_gateway_master
    customer_gateway_v1.0
    customer_gateway_v2.0
```

This is how the `customer_gateway_master` project environment directory was made:

```
> cd ~/projects
> git clone --recursive --jobs 8 git@github.com:Reasoning-Technology/customer_gateway_env.git
> mv customer_gateway_env customer_gateway_master

```
When downloading a `<project>_env` repo, we can expand the submodules at the same time
by including the --recusive switch, as was shown above.  If the `--recurisve` switch
is not given, the submodules will have to be initialized and updated.

The second directory was then created with the commands:

```
> git clone --recursive --jobs 8 git@github.com:Reasoning-Technology/customer_gateway_env.git
> mv customer_gateway_env customer_gateway_v1.0
> cd customer_gateway_v1.0
> git checkout v1.0

```

So you ask why do we need more than one directory for the same repo? Well in this case I
am running a web server against the v2.0 branch, and it needs to see the files the v2.0.
The v1.0 directory was the one that was formally being served. There are no servers
pointed at it now, so I should probably delete it.  If I ever need v1.0 again I can always
check it out. 


## Git Modules and Submodules

Clone a `git` repository produces a directory tree, which in git speak is
apparently called a `module`.

We may `cd` into a module and clone another module, this will be called a ‘submodule’.  A
submodule clone requires a special command so that the module will know it is there:

```
git submodule add <repo>
```

We might do this because our project depends on other projects, and those other projects
have their own git repositories, or because we are developing more than one project
together under one shared environment.

We then use the submodule just like we would use any other git module.  I.e. after we make
changes we must add the changes, then commit them, and then push the submodule.

The parent module only sees the submodule changes when there is a commit in the
submodule.  Hence, after there is a commit in a submodule, we must go up to the module, and
then add the submodule, commit, then push the module.

We truly have two layers, and we have to maintain them individually. Luckily we have some
scripts so that we don't to type stuff twice. In `project_share` there are two
scripts, one called `push` the other called `pull`.  The `push`script goes to the project
home and does an add, commit, and push.  It then goes up to the environment directory and
adds the project submodule, commits the change, and the pushes.  The `pull` script takes
analogous actions for a pull.


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

  Note in the line that moves the cloned repo directory to `<project>_master`, you might
  use a different suffix than `master`.  Conventionally the suffix is the branch to be
  checked out and worked on, but the scripts do not care what it is set to. Inside the
  scripts this suffix is called the project ‘version’.

2. for submodules that have not yet been added:

  ```
    > git submodule add https://github.com/../<resource_project>
    > git submodule add https://github.com/../<resource_project>
    ...

  ```
   Etc. for the other modules


3. if a submodule is empty, then do the following:

  ```
    > git submodule init
    > git submodule update
  ```

   Submodules directories will be empty when the `--recursive` switch is not provided with
   the clone. Actually, I prefer not to use `--recursive` and then to follow up with an
   `init` and `update` so that it is easier to tell what caused errors.  See the git man
   pages for more details.


4. audit, legible scripts, and binary executables

  These rules are best practice.
  
  New files on a clone or pull should be audited.

  It is best to not have any executables pulled in the repo, text or binary. No executables
  should appear in a project home directory.

  The whole point of the `project_share` repo is to provide executable text scripts, so of
  course it does not follow this rule.  There should be a careful audit after a pull into 
  `project_share`.
  
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
 want to have a `.gitignore`.  This might be part of the project, check after a clone.

 A project environment `.gitignore` will have the `env` and `tmp` files init.  We
 don't want hidden files in the environment, except for .gitignore, which we have no
 choice over. By convention files ending in a ‘~’ character are ignored.

  ```
      env/
      tmp/
      .*
      !.gitignore
      *~
  ```

  For a C or C++ project home directory we will also ignore various intermediate files,

  ```
      tmp/
      .*
      !.gitignore
      *~
      *.o
      *.i
      *.s
      a.out
  ```


  For a python project:
  ```
      tmp/
      .*
      !.gitignore
      __pycache__/
      **/*.pyc
  ```
 
    And for a django project:

  ```
      tmp/
      .*
      !.gitignore
      __pycache__/
      **/*.pyc
      manage.py
      **/migrations
      .vscode
  ```

6. To work in the project:

   First enter a shell with a dedicated environment

  ```
     start <project> <version>
  ```

  As noted above `<version>` is typically the name of the branch that will be expanded out
  in the project home directory.

  This command will open a new shell with the environment setup for the project.  The
  new shell will source your user directory `.bashrc` file, and will source the project
  environment's `env/bin/init.sh` file.

  So for the `ws4` project mentioned above:

  ```
     start ws4
  ```

  The `<version>` defaults to ‘master’.  After `start` runs you will see this prompt:
  
  ```
      2020-12-01T14:56:31Z [ws4_master]
      thomas@localhost§~/projects/ws4_master§
      > 
  ```
   
  On the first line, the time shown is UTC in standard iso8601 format.  We use timestamps
  of this form for transcripts and logs. Following in square brackets you will see the
  name of the project environment directory.

  If the time does not show as above, copy the `Z` command in `project_share` to `/usr/local/bin`.

  On the second line we have the user name, machine name, and current working directory.

  Then on the third line we have the prompt, `>`. Anything you type appears after that is
  taken as the command for the shell.

  When transcripts appear in this form we can hopefully make sense of what happened and in
  what order when reading them later.

  When you have made changes in the project home directory and want to push them back to 
  the repo, first pull on the work from other team members:

  ```
     > pull
  ```

  You will have to work out any conflicts.


  The push your work back to the repo:

  ```
     > push
  ```

  Those scripts do the intermediate staging, commit, and push/pull, both for the project
  and the project environment.  If things go wrong, you will have to read through the
  transcripts.  Sometimes the scripts may be played again, sometime you have to drop back
  and use `git` directly.
  


