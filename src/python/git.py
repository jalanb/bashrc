"""This module provides methods to cover many git commands"""

import os
import re
import sys
import shutil
from contextlib import contextmanager
from functools import partial
from typing import Any
from typing import List

from subprocess import getstatusoutput

_working_dirs = ["."]


class GitException(RuntimeError):
    """This class is the base for git exceptions

    For many git exceptions there are known workarounds
        E.g. if a commit didn't work, then add some files first!

    But that error (nothing to commit) can arise in many contexts
        eg as a "Git Commit Exception"
        or as a "Git Merge Exception"
        and those 2 exception classes might not be derived from each other
    So the merge exception cannot rely on inheriting an "add_files_handler()"
        It cannot check bases classes, so must check derived classes

    This metaclass allows any class derived from it to insist
        that any further-derived classes provide some handlers
    """

    required_handlers: List[Any] = []

    def __new__(cls, name, bases, body):
        """Derived classes must have all required_handlers"""
        if "required_handlers" in body:
            missing = set(cls.required_handlers) - set(body.keys())
            if missing:
                plural = (len(missing) == 1 and "" or "s",)
                missings = "\n".join(f"{cls.__class__.__name__}.{m}()" for m in missing)
                raise TypeError(f"Missing handler{plural}: {missings}")
        return super(GitException, cls).__new__(cls, name, bases, body)


class GitError(GitException):
    def __init__(self, command, status_, output):
        super(GitError, self).__init__(
            "\nPWD: %r\nCommand: %r\nstderr:\n%r" % (os.getcwd(), command, output)
        )
        self.command = command
        self.status = status_
        self.output = output

    def inits(self):
        return self.command, self.status, self.output


# pylint: disable=too-many-ancestors
class UnknownRevision(GitError):
    pass


class NoRemoteRef(GitError):
    pass


class NoSuchCommit(GitError):
    pass


class ExistingReference(GitError):
    pass


class ExistingBranch(GitError):
    pass


class EmptyCommit(GitError):
    pass


def resolve_conflicts(in_lines):
    lines = []
    resolved = set()
    conflicts = set()
    for line in in_lines:
        if line.startswith("Resolved"):
            name = line.split("'")[1]
            resolved.add(name)
            add(name)
            if name in conflicts:
                conflicts.remove(name)
            continue
        lsw = line.startswith
        if lsw("CONFLICT") or lsw("Recorded preimage"):
            if lsw("CONFLICT"):
                name = line.split()[-1]
            else:
                name = line.split()[-1].strip("'")
            if name in resolved or name in conflicts:
                continue
            conflicts.add(name)
        lines.append(line)
    return "\n".join(lines), resolved, conflicts


class Resolver(GitError):
    required_handlers = ["resolve_conflicts"]

    def __init__(self, command, status_, output):
        super(Resolver, self).__init__(command, status_, output)
        self.output, self.resolved, self.conflicts = self.resolve_conflicts()

    def resolve_conflicts(self):
        """Remove files that git says are resolved from the conflicts"""
        return resolve_conflicts(self.output.splitlines())


# importers can assign to this to change the Exception raised
# new Exception should derive from Resolver
class ResolveError(Resolver):
    pass


@contextmanager
def use_resolver(resolver):
    # pylint: disable=global-variable-undefined
    global ResolveError
    old = ResolveError
    assert issubclass(resolver, GitError)
    try:
        ResolveError = resolver
        yield resolver
    finally:
        ResolveError = old


def root_from(path):
    p = path if os.path.isdir(path) else os.path.dirname(path)
    p = os.path.realpath(p)
    while p[:2] >= "/A":
        p_git = os.path.join(p, ".git")
        if os.path.isdir(p_git):
            return p
        p = os.path.dirname(p)
    raise ValueError(f"No .git above {path}")


@contextmanager
def pushd(path):
    _working_dirs.insert(0, root_from(path))
    yield _working_dirs[0]
    del _working_dirs[0]


def cd(path):
    """Change the directory that git will use for subsequent commands

    method is named for consistency with similar in shell.py
    Actually it just adds the "-C" option to git commands

    If this method is not called then commands default to current directory
        i.e. the global _working_dirs, above, defaults to '.'
    """
    _working_dirs[0] = root_from(path)


def run(sub_command, quiet=True, no_edit=False, no_verify=False):
    """Run a git command

    Prefix that sub_command with "git "
        then run the command in shell

    If quiet if True then do not log results
    If no_edit is True then prefix the git command with "GIT_EDITOR=true"
        (which does not wait on user's editor)

    If the command gives a non-zero status, raise a GitError exception
    """
    if _working_dirs[0] != ".":
        git_command = f'git -C "{_working_dirs[0]}"'
    else:
        git_command = "git"
    edit = "GIT_EDITOR=true" if no_edit else ""
    verify = "GIT_SSL_NO_VERIFY=true" if no_verify else ""
    command = f"{verify} {edit} {git_command} {sub_command}"
    if not quiet:
        print(f"$ {command}")
    status_, output = getstatusoutput(command)
    if status_:
        if quiet:
            print(f"$ {command}", file=sys.stderr)
        print(f"\n{output}", file=sys.stderr)
        if "unknown revision" in output:
            raise UnknownRevision(command, status_, output)
        elif "remote ref does not exist" in output:
            raise NoRemoteRef(command, status_, output)
        elif "no such commit" in output:
            raise NoSuchCommit(command, status_, output)
        elif "reference already exists" in output:
            raise ExistingReference(command, status_, output)
        elif re.search("Resolved|CONFLICT|Recorded preimage", output):
            raise ResolveError(command, status_, output)
        elif re.search("branch named.*already exists", output):
            raise ExistingBranch(command, status, output)
        raise GitError(command, status_, output)
    elif output and not quiet:
        print(f"\n{output}")
    return output


def log(args, number=None, oneline=False, quiet=True):
    """Run a "git log ..." command, and return stdout

    args is anything which can be added after a normal "git log ..."
        it can be blank
    number, if true-ish, will be added as a "-n" option
    oneline, if true-ish, will add the "--oneline" option
    """
    options = " ".join([number and f"-n {number}" or "", oneline and "--oneline" or ""])
    try:
        return run(f"log {options} {args}", quiet=quiet)
    except UnknownRevision:
        return ""


def rev_parse(options, *args, **kwargs):
    """Run 'git rev-parse' with those options"""
    return run(f"rev-parse {options}", *args, **kwargs)


def root():
    """Get the root directory of the repo

    i.e. this directory (or one above) which contains the ".git" directory
    """
    return os.path.dirname(rev_parse("--absolute-git-dir", quiet=True))


def branch(options=False, *args, **kwargs):
    """Run "$ git branch" with those options

    If not options then return name of the branch currently checked out
    """
    return (
        options
        and run(f"branch {options}", *args, **kwargs)
        or rev_parse("--abbrev-ref HEAD", *args, **kwargs)
    )


def branches(remotes=False):
    """Return a list of all local branches in the repo

    If remotes is true then also include remote branches

    Note: the normal '*' indicator for current branch is removed
        this method just gives a list of branch names
    Use branch() method to determine the current branch
    """
    options = remotes and "-a" or ""
    stdout = branch(f"--list {options}", quiet=True)
    return [_.lstrip("*").strip() for _ in stdout.splitlines()]


def branches_containing(commit):
    """Return a list of branches conatining that commit"""
    lines = run(f"branch --contains {commit}").splitlines()
    return [_.lstrip("* ") for _ in lines]


def hide(item):
    """Hide that item (branch or tag), i.e. remove it from origin"""
    try:
        return push("origin --delete", item)
    except NoRemoteRef:
        pass


def unstaged_files():
    """A list of all filenames which have changes, but not staged for commit"""
    return diff_files("", "")


def conflicted(path_to_file):
    """Whether there are any conflict markers in that file"""
    for line in open(path_to_file, "r"):
        for marker in '>="<':
            if line.startswith(marker * 8):
                return True
    return False


def add(path=None, force=False, quiet=True):
    """Add that path to git's staging area (default current dir)

    so that it will be included in next commit
    """
    option = "-f" if force else ""
    return run(f'add {option} {path or "."}', quiet=quiet)


def push(qualifiers="", refspec=None):
    """Push the local refspec to remote repository

    If refspec is left as None, then push current branch
    If any qualifiers are given, then they will be added to the push command
    """
    run(f'push {qualifiers} {refspec or ""}')


def fetch_all():
    """Fetch all (new) branches and tags from remote"""
    run("fetch --all")


def grup():
    """Prune all local branches and tags removed from remote

    method name is an acronym of the command
    """
    run("remote update origin --prune")


def config(key, value, local=True):
    """Set that config key to that value

    Unless local is set to False: only change local config
    """
    option = local and "--local" or ""
    run(f'config {option} "{key}" "{value}"')


def clean(full=False):
    options = "-d -f -f -x" if full else ""
    run(f"clean {options}")
    run("gc --quiet")
    if full:
        run("reset HEAD .")
        checkout(".")


def clone(url, path=None, remove=True):
    """Clone a local repo from that URL to that path

    If path is not given, then use the git default: same as repo name
    If path is given and remove is True
        then the path is removed before cloning

    Because this is run from a script it is assumed that user should be Admin
        so set config user values for the GitLab Admin
    """
    clean = True
    if path and os.path.isdir(path):
        if not remove:
            clean = False
        else:
            shutil.rmtree(path)
    if clean:
        stdout = run(f'clone {url} {path or ""}')
        into = stdout.splitlines()[0].split("'")[1]
        path_to_clone = os.path.realpath(into)
    else:
        path_to_clone = path
    old_dir = _working_dirs[0]
    _working_dirs[0] = path_to_clone
    config("user.name", "Release Script")
    config("user.email", "gitlab@wwts.com")
    _working_dirs[0] = old_dir
    return path_to_clone


def diff_files(branch_1, branch_2):
    return run(f"diff --name-only {branch_1} {branch_2}").splitlines()


def status(short=False):
    option = "--short" if short else "--long"
    return run(f"status {option}")


def needs_abort():
    """A command to abort an operation in progress

    For example a merge, cherry-pick or rebase
    If one of these operations has left the repo conflicted
        then give a command to abandon the operation
    """
    for line in status().splitlines():
        if "--abort" in line:
            for part in line.split('"'):
                if "--abort" in part:
                    return part
        elif "All conflicts fixed but you are still merging" in line:
            return "git merge --abort"
        elif "You have unmerged paths." in line:
            return "git merge --abort"
        elif 'all conflicts fixed: run "git rebase --continue"' in line:
            return "git rebase --abort"
    return None


@contextmanager
def very_clean():
    """Do a full git clean before and after"""
    abandon_fully()
    try:
        yield
    finally:
        abandon_fully()


def abandon_fully():
    abandon_operation()
    clean(full=True)


def abandon_operation():
    """Abandon any current operaton which needs it"""
    command = needs_abort()
    if not command:
        return False
    return run(command.replace("git", "", 1))


def show_branches(branch_1, branch_2):
    """Runs git show-branch between the 2 branches, parse result"""

    def parse_show_line(string):
        """Parse a typical line from git show-branch

        >>> parse_show_line('+ [master^2] TOOLS-122 Add bashrc')
        '+ ', 'master^2', 'TOOLS-122 Add bashrc'
        """
        regexp = re.compile(r"(.*)\[(.*)] (.*)")
        match = regexp.match(string)
        if not match:
            return None
        prefix, commit, comment = match.groups()
        return prefix[0] == " " and 1 or 0, commit, comment

    log = run(f'show-branch --sha1-name "{branch_1}" "{branch_2}"')
    lines = iter(log.splitlines())
    line = lines.next()
    branches = {}
    while line != "--":
        column, branch, comment = parse_show_line(line)
        branches[column] = [branch]
        line = lines.next()
    line = lines.next()
    for line in lines:
        column, commit, comment = parse_show_line(line)
        branches[column].append((commit, comment))
    return branches


# pylint: disable=redefined-outer-name
# From here down args may redefine methods
# This arises from trying to match git commands
#   where one command may appear as an option in another command
# For example
#   The word "commit" is a "command" in "$ git commit ..."
#   But it is an "option" in "$ git tag ... commit"
#
# Callers should not have to use mangled names for args / options

# Define aliases for those defined above and used below:
current_branch = branch


def latest_commit(branch=None, path=None):
    """Last commit message on given (or current) branch

    If a path is given, then get latest for that path only
    """
    options = "--no-abbrev-commit %s %s" % (branch or "", path and f"-- {path}" or "")
    result = log(options, 1, True, True)
    return result and result.split(" ", 1) or ("", "")


def commits_with_message(message):
    """All commits with that message (in current branch)"""
    output = log(f"--grep '{message}'", oneline=True, quiet=True)
    lines = output.splitlines()
    return [_.split(" ", 1)[0] for _ in lines]


def sha1(branch=None, path=None):
    """SHA1 of the last commit on given (or current) branch

    If a path is given, then get latest for that path only
    """
    return latest_commit(branch, path)[0]


def checkout(branch, quiet=True, as_path=False):
    """Check out that branch

    Defaults to a quiet checkout, giving no stdout
        if stdout it wanted, call with quiet = False

    Defaults to checking out branches
        If as_path is true, then treat "branch" like a file, i.e.
        $ git checkout -- branch

    All errors will pass silently, just returning False
        except any messages about "you need to resolve your current index"
        These indicate that the repository is not in a normal state
            and action by a user is usually needed to resolve that
        So the exception is allowed to rise
            probably stopping the script
    """
    try:
        if as_path:
            branch = "-- {branch}"
            option = quiet and "-q" or ""
        run(f"checkout {option} {branch}")
        return True
    except GitError as e:
        if "need to resolve your current index" in e.output:
            raise
        return False


checkout_path = partial(checkout, as_path=True)


def diff(options=None, branch="master", path=None):
    suffix = path and f"-- {path}" or ""
    return run(f"diff {options} {branch} {suffix}")


def same_diffs(commit1, commit2):
    """Whether those 2 commits have the same change

    Run "git range-diff" against 2 commit ranges:
        1. parent of commit1 to commit1
        1. parent of commit2 to commit2

    If the two produce the same diff then git will only show header lines
        Header lines are prefixed like "1: ...."
    Otherwise there will be lines after the header lines
        (and those lines will show the difference)
    """

    def range_one(commit):
        """A git commit "range" to include only one commit"""
        return f"{commit}^..{commit}"

    output = run(f"range-diff {range_one(commit1)} {range_one(commit2)}")
    lines = output.splitlines()
    for i, line in enumerate(lines, 1):
        if not line.startswith(f"{i}"):
            break
    return not lines[i:]


def checkout_log(branch, number=15, quiet=True, as_path=False):
    if checkout(branch, quiet, as_path):
        return log("", number=number, oneline=True, quiet=quiet).splitlines()
    return []


def renew_local_branch_from_remote(branch, start_point):
    checkout(start_point)
    pulled = pull()
    renew_local_branch(branch, start_point)
    return pulled


def renew_local_branch(branch, start_point, remote=False):
    """Make a new local branch from that start_point

    start_point is a git "commit-ish", e.g branch, tag, commit

    If a local branch already exists it is removed
    If remote is true then push the new branch to origin
    """
    if branch in branches():
        checkout(start_point)
        delete(branch, force=True, remote=remote)
    result = new_local_branch(branch, start_point)
    if remote:
        publish(branch)
    return result


def pull_branch(branch):
    checkout(branch)
    pull()
    return up_to_date()


def up_to_date():
    return bool(re.search("up.to.date", status()))


def new_local_branch(branch, start_point):
    """Make a new local branch from that start_point

    start_point is a git "commit-ish", e.g branch, tag, commit
    """
    return run(f"checkout -b {branch} {start_point}")


def publish(branch, full_force=False):
    """Publish that branch, i.e. push it to origin"""
    checkout(branch)
    try:
        push("--force --set-upstream origin", branch)
    except ExistingReference:
        if full_force:
            push("origin --delete", branch)
            push("--force --set-upstream origin", branch)


def delete(branch, force=False, remote=False):
    option = "-D" if force else "-d"
    try:
        result = run(f"branch {option} {branch}")
        pass
    except GitError as e:
        if "checked out at" not in e.output:
            raise
        if branch == "master":
            raise
        checkout("master")
        result = run(f"branch {option} {branch}")
    except Exception:
        pass
    if remote:
        return hide(branch)
    return result


def commit(message, add=False, quiet=True):
    """Commit with that message and return the SHA1 of the commit

    If add is truish then "$ git add ." first
    """
    if add:
        run("add .")
    try:
        stdout = run("commit -m %r" % str(message), quiet=quiet)
    except GitError as e:
        s = str(e)
        if "nothing to commit" in s or "no changes added to commit" in s:
            raise EmptyCommit(*e.inits())
        raise
    return re.split(r"[ \]]", stdout.splitlines()[0])[1]


def pull(rebase=True, refspec=None):
    """Pull refspec from remote repository to local

    If refspec is left as None, then pull current branch
    The '--rebase' option is used unless rebase is set to false
    """
    options = rebase and "--rebase" or ""
    output = run(f'pull {options} {refspec or ""}')
    return not re.search("up.to.date", output)


def tag(name, remote=False, commit=None):
    """Add a local tag with that name at that commit

    If no commit is given, at current commit on cuurent branch
    If remote is true, also push the tag to origin
    """
    command = f'tag {name} {commit or ""}'
    result = run(command)
    if remote:
        push(f"origin {name}")
    return result


def tags():
    return run("tag", quiet=True).splitlines()


def in_tag(name):
    for tag in tags():
        if name in tag:
            return True
    return False


def is_tag(name):
    return name in tags()


def re_tag(name, remote=False, commit=None):
    """Add a local tag with that name at that commit

    If no commit is given, at current commit on cuurent branch
    If remote is true, also push the tag to origin

    If tag already exists, delete it, then re-make it
    """
    if remote:
        tags = run("ls-remote --tags", quiet=True).splitlines()
        if name in tags:
            hide(name)
    if is_tag(name):
        run(f"tag --delete {name}")
    return tag(name, remote, commit)


def merge(branch, fast_forward=False, commit=True, options=None):
    """Merge that branch into current branch

    fast_forward and commit add the eponymous options to the command
    """
    more_options = [
        fast_forward and "--ff" or "--no-ff",
        commit and "--commit" or "--no-commit",
    ] + (options and options or [])
    option_string = " ".join(more_options)
    all_branches = branches()
    assert branch in all_branches, f"Missing branch: {branch}"
    command = f"merge {option_string} {branch}"
    return run(command)


@contextmanager
def git_continuer(method, *args, **kwargs):
    try:
        yield
    except Resolver as resolved:
        while True:
            if resolved.conflicts:
                raise
            try:
                method(*args, **kwargs)
            except Resolver as resolved:  # noqa
                pass
            else:
                return


def cherry_pick(pick):
    """Cherry pick that arg into current branch

    pick would normally just be SHA1 of a commit,
        but can include command options, e.g.:
            cherry_pick('ab12cd34 -X theirs')
    """
    with git_continuer(run, "cherry-pick --continue", no_edit=True):
        return run(f"cherry-pick -x --allow-empty {pick}")


def rebase(upstream, branch=None):
    """Rebase branch onto upstream

    If branch is empty, use current branch

    """
    rebase_branch = branch and branch or current_branch()
    with git_continuer(run, "rebase --continue", no_edit=True):
        stdout = run(f"rebase {upstream} {rebase_branch}")
        return "Applying" in stdout


def merge_resolve(branch, fast_forward=False, commit=True, options=None):
    """Merge that branch into current branch

    If git raises an error, and the error is for conflicts
        then read the error message looking for any resolved conflicts
        Remove the resolved conflicts from the error message
    If all conflicts were resolved
        then remove the error
    """

    def get_resolution(resolved=None):
        return resolved

    with git_continuer(get_resolution):
        resolved = merge(branch, fast_forward, commit, options)
        if commit and resolved.resolved:
            # Then the resolved files were added, better commit them
            commit(f"Merge branch '{branch}' into '{current_branch()}'")


def split_conflict(conflict):
    position = before = []
    during = []
    after = []
    previous_conflict = False
    with open(conflict) as stream:
        for line in stream:
            markers = [
                "<<<<<<<",
                "|||||||",
                "=======",
                ">>>>>>>",
            ]
            for marker in markers:
                if line.startswith(marker):
                    if marker == "<<<<<<<":
                        position = during
                        # Assuming only one conflict in a version file
                        assert previous_conflict is False
                        previous_conflict = True
                    elif marker == ">>>>>>>":
                        position = after
                    break
            else:
                position.append(line)
    return before, during, after
