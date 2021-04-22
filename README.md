

# `project-environment`

`project-environment` is a collection of scripts and resources I use for multiple github
projects. Scripts include such things as ‘start’, ’push’, and ‘pull’.  Built into the
scripts are assumptions on the structure of the directory used for holding a
project.

## What is a ‘project’

The term ‘project’ occurs repeatedly in this document and generally when we talk about
code, so it is best to start by nailing that term down.  Generally speaking, a ‘project’
has a well defined final product, along with a list resource needs, tasks, task
dependencies, and a tasks schedule.  It is the job of the team members to execute said
tasks.

In project management parlance, a group of related projects is called a ‘program’. Well
that sure is an unfortunate choice of term for us CS people, so instead we will call a
group of related projects a ‘project ensemble’.  A project ensemble itself is also a kind
of project, where the tasks are the component projects.  Hence we have a recursive
structure. CS people like recursive structures ;-)  

Projects are held in git repositories, as project ensembles are also projects, they are
also held in git repositories. When we clone a project ensemble we will find other git
repositories have been expanded inside the directory tree.  Those are for the component
projects.  In git speak we call these component project directory trees ‘submodules’.

When a project ensemble is expanded out, we end up with a directory tree structure where
project resources, tools, and work products are stored.

## `Z`

‘Z’ stands for ‘Zulu time’ an antiquated term for UTC time.  Probably because it is
nostalgic and convenient the abbreviation `Z` has been maintained as part of ISO 8601.

The script Z prints a time stamp.  Scripts in `project-environment` make use of it.  An admin
should change its ownership to root and install it in `/usr/local/bin`.  Some scripts here might
reference it through an absolute path.

## `home`

`home` is binary executable for getting the user's home directory from `/etc/passwd`.
This is used for security reasons in bash scripts, because `$HOME` is inherited 
from the environment and thus might not be the home directory.

The source and makefile for building home are in `project-environment/src/home`.  However an admin needs
to install this program.  If the program is owned by the same user it is used by, then it
might be overwritten to give different answers.

To use `home` place it at the top of your script and overwrite the `HOME` variable
from the environment. Something like: `HOME=$(/usr/local/bin/home)`.


## Where project code goes
--------

On a typical project we will have three distinct types of code:

1. the application source code
2. the libraries and other resources the application makes use of
3. the tools used for building the source code

Let's give these code types short names:

1. source
2. resources
3. tools

We have various places where we might put code that we need in a program:

1. in the system
2. in the developer's user directory
3. in a project ensemble
4. in a project's home directory.

We shorten these to

1. system
2. user
3. ensemble
4. project

Now combining our code and locations into one list:

1. source
   1. project
2. resources
   1. system
   2. user
   3. ensemble
3. tools
   1. system
   2. user
   3. ensemble
   
So there is only one place we will find the application source code that we are
developing, and that is under the project directory. Resources that we may need in
order to compile our code will be found either in the system, the user directory, or in
the ensemble. The same can be said for the tools we will use.

This is what my home directory looks like:

```
/home/thomas/
  bin/
  Desktop/
  Documents/
  Downloads/
  projects/
    chessgame/
    share/      <--- place for resources and tools shared by all projects
        LICENSE
        README.md
        makefile-cc
        pull
        push
        rm_tilda_files_tree
        start
    subu/ 
    tm/
    ws4_master/   <--- an ensemble directory
      LICENSE
      README.md
      env/  <--- place to put stuff shared within the ensemble
          bin/
          lib/
          include/
      tmp/
      uWebSockets/ <--- resource project directory
      ws4/   <--- target project directory
```

Scripts common to all of my projects are in the project `project-environment`.  I added the following to my
`.bashrc`:

```
 export PATH=~/bin:~/projects/share:"$PATH"

```

If you need to modify a script in the `project-environment` project and do not want to distribute the
changes to the team, make a copy of the script in your own bin directory and modify it
there.  note `~/bin` appears before `~/projects/share`, so the changed script will get
picked up instead of the `project-environment` version. For custom project specific scripts put them in
the project environment `env/bin`.  Be sure modify the default `env/bin/init.sh` script to
add `env/bin` to the executables search path.  Also note, that the contents of the `env`
directory do not get pushed back to the repo, so you will need to make copies of your `env`
stuff if you want to keep them.

This is how to clone the `project-environment` project:

```
> cd ~/projects
> git clone git@github.com:Thomas-Walker-Lynch/share.git
```

It is important that each time `project-environment` is updated from the repo that an audit is done.
With this audit we hope to prevent mischief from fellow developers.  For example we
wouldn't want the `pull` to run a program that draws a chu-chu train in the terminal while
emailing itself to everyone on your contacts list, or worse. Pay close attention to the
messages printed out by git so that you know which files to look at during the audit.

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

`ws4_master` is a project ensemble. The component projects include `uWebSockets` and
`ws4`. This project ensemble also comes from a git repo.

`ws4_master/ws4` is the home directory for the project this team is actively working on.
We know it is the active project because it has the same name as the ensemble prefix.
Whereas `ws4_master/uWebSockets` is someone else's github project. There are other people
working that, but it is not us, and it is being developed in a different
environment. Rather we are just making use of the work product of that project.

Also inside of `ws4_master` we have a directory called `env`. Frankly, I don't like the
name.  I have toyed with calling it `project-environment`, but `env` is the name that Python and others
expect.  Perhaps make it a symbol link?  This directory is used to hold project specific
resources and tools.  Note that the contents of `env` are *not* pushed to the repo. This
means that custom edits you make to scripts will not be backed up to the repo.  I also do
not like `env` because it is not pushed to the repo, but it might be *pulled* from it.
`.gitignore` does not affect pulls.  This is a security hazard.


## Repo and Directory Naming

All my repos for project ensembles have a `_ensemble` suffix.  Hence they will clone
into directories named `<project>_ensemble`.  After cloning I rename the directory to
`<project>_<version>`, where `<version>` is typically the same name as the branch
that is most commonly checked out in the directory.

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
> git clone --recursive --jobs 8 git@github.com:Reasoning-Technology/customer_gateway_ensemble.git
> mv customer_gateway_ensemble customer_gateway_master

```
When downloading a `<project>_ensemble` repo, we can expand the submodules at the same time
by including the --recursive switch, as was shown above.  If the `--recursive` switch
is not given, the submodules will have to be initialized and updated.

The second directory was then created with the commands:

```
> git clone --recursive --jobs 8 git@github.com:Reasoning-Technology/customer_gateway_ensemble.git
> mv customer_gateway_ensemble customer_gateway_v1.0
> cd customer_gateway_v1.0
> git checkout v1.0

```

So you ask why do we need more than one directory for the same repo? Well in this case I
am running a web server against the v2.0 branch, and it needs to see the files the v2.0.
The v1.0 directory was the one that was formally being served. There are no servers
pointed at it now, so I should probably delete it.  If I ever need v1.0 again I can always
check it out. 


## Git Modules and Submodules

Cloning a `git` repository produces a directory tree, which in git speak is
apparently called a `module`.

We may `cd` into a module and clone another module, this will be called a ‘submodule’.  A
submodule clone operation requires a special command so that the module will know it is
there:

```
git submodule add <repo>
```

We might do this because our project depends on other projects, and those other projects
have their own git repositories, or because we are developing more than one project
together with one shared environment.

We then use the submodule just like we would use any other git module.  I.e. after we make
changes we must add the changes, then commit them, and then push the submodule.

The parent module only sees the submodule changes when there is a commit in the
submodule.  Hence, after there is a commit in a submodule, we must go up to the module, and
then add the submodule, commit, then push the module.

We truly have two layers, and we have to maintain them individually. Luckily we have some
scripts so that we don't to type stuff twice. In the `project-environment` project there are two
scripts, one called `push` the other called `pull`.  When we run the `push` script it goes
into the project home and does an add, commit, and push.  It then goes up to the ensemble
directory and `git add`s the project submodule, commits the change, and then pushes. Finally
it pops directory back to the project.  The current `pull` script pulls down all the
submodules and the ensemble.


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
    > git clone git@github.com/<user>/<project>_ensemble.git
    > mv <project>_ensemble <project>_master 
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
   `init` and `update` so that it is easier to tell what caused errors.


4. audit, legible scripts, and binary executables

  These rules are best practice.
  
  New files on a clone or pull should be audited.

  It is best to not have any executables pulled in the repo, text or binary. There should be
  no executables in a project home directory.

  The whole point of the `project-environment` repo is to provide executable text scripts, so of
  course it does not follow this rule.  There should be a careful audit after a pull into 
  `project-environment`.
  
  Binary executables are unauditable, consequently they are barred from the repos. It is
  permissible, of course, for a build process to create a binary executable from source
  files and put it within the directory structure for the project, it is just that the
  executable should not be pushed to the repo.  Source files are auditable.

  `<project>_ensemble` repos most typically have an `env` sub-directory, which in turn has
  `bin` and `lib` sub-directories. Local builds might put executables into these
  directories. Consequently, we do not put the `env` file nor its contents into a repo.
  You should find `env/` listed in `.gitignore` for the project ensemble.

  However, there is a security hole in that `.gitignore` does not apply to pulled content,
  so another developer with access to the repo could make it so that when we pull, the `env`
  directory is given executable contents.  git gives us no feature to prevent this.  So
  when you do a `git pull`, or `git clone`, for a `<project>_ensemble` repo be careful to check
  that nothing is pulled into `env` sub-directory. Chances are this is not too much trouble
  as `<project>_ensemble` is typically cloned once and then used thereafter.  The action occurs
  in the project's home directory.

  If you use the `push` and `pull` wrappers in `project-environment`, they will scan for executables and
  warn you about them.


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

  This command will open a new shell with the environment setup for the project.  The
  new shell will source your user directory `.bashrc` file, and will source the project
  environment's `env/bin/init.sh` file.


  ```
     start <project> <version>
  ```

  As noted above `<version>` is typically the name of the branch that will be expanded out
  in the project home directory.

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
   
  On the first line, the time shown is UTC in standard iso8601 format.  We use time stamps
  of this form for transcripts and logs. Following in square brackets you will see the
  name of the project environment directory.

  If the time does not show as above, copy the `Z` command in `project-environment` to `/usr/local/bin`.

  On the second line we have the user name, machine name, and current working directory.

  Then on the third line we have the prompt, `>`. Anything you type after the prompt is
  taken as the command for the shell.

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
  


