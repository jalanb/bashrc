# projects-clones Tool Outline

Pipe-friendly filter for deduplicating paths by project

## Purpose

Takes file paths on stdin, groups them by project (GitHub URL), and outputs one path per project - the "best" clone according to selection criteria.

## Directpry structure

The directory structure in place at the monent clones github repositories into sub-dirs
For example, if there is a github repo at https://github.com/jalanb/freds, then the directory structure will be:
```
/opt/clones/github/jalanb/freds/
    __main__/
    other/
```

where "freds" is the "project dir", and "__main__" and "other" are the "clone dirs".

`__main__` and `other`, being clones from the same repo, will have a lot of duplicates - dirs, files, text.

## Usage Examples

The tool is designed to work as a Unix filter in pipes:
- Find bin directories, one per project
- Find Python files, one per project  
- Grep across projects with deduplicated results

## Core Algorithm

The tool processes paths in two main phases:

**Phase 1: Grouping**
For each path coming in on stdin, we need to figure out which project it belongs to. We do this by walking up the directory tree until we find a git repository, then asking git for the origin URL. Paths with the same GitHub URL belong to the same project.

**Phase 2: Selection**  
Once we've grouped paths by project, we need to pick which clone to keep for each project. We use the priority rules: prefer `__main__` clone first, then clone matching the project name, then fall back to whichever was modified most recently.

**Phase 3: Filtering**
For each group, we throw away paths from all clones except the chosen one, then output what remains.

## Dependencies

The tool will rely on two modules we're creating:

**From `jalanb_clones` module** (the personal clone structure stuff):
- Finding the git repository root that contains a given path
- Getting the GitHub URL for a repository  
- Finding all clones of a project given its URL
- Selecting the best clone from a list according to our priority rules

**From `pysyte.git` module** (the generic git operations):
- Running git commands in a repository (used by the above functions)

## Edge Cases

### Path Not in Git Repo
**Input**: `/opt/clones/github/jalanb/random_file.txt` (not in a git repo)
**Behavior**: Skip, don't output

### No Remote Configured
**Input**: Path in repo with no remote URL
**Behavior**: Skip, can't determine project identity

### Multiple Paths Same Clone
**Input**: 
```
/opt/clones/github/jalanb/freds/fred/bin/
/opt/clones/github/jalanb/freds/fred/src/
```
**Behavior**: Output both (same clone, both kept)

### Paths from Different Clones
**Input**:
```
/opt/clones/github/jalanb/freds/fred/bin/
/opt/clones/github/jalanb/freds/__main__/bin/
```
**Behavior**: Output only `/opt/clones/github/jalanb/freds/__main__/bin/` (best clone)

## Testing Strategy

### Unit Tests

We'll need tests to verify:
- Paths from the same project (same GitHub URL) get grouped together
- When `__main__` clone exists, it's always preferred
- When no `__main__`, prefer clone whose name matches the project name
- When neither of above, fall back to most recently modified clone
- Paths that aren't in git repositories get skipped quietly

### Integration Tests

We'll need to create test directory structures with actual git repositories, different clone patterns, and verify the tool behaves correctly when piped real data from fd or grep.

## Performance Considerations

### Caching
- Cache git root lookups (same path prefix → same root)
- Cache GitHub URL lookups (same repo → same URL)
- Cache mtime checks for clone selection

### Large Input
- Process in batches if memory becomes an issue
- Consider streaming output rather than buffering all results

### Git Command Overhead  
- Minimize git command invocations
- Consider batch operations where possible

## Future Enhancements

### v2 Features
- `--project <name>` - filter to specific project only
- `--exclude-clones <pattern>` - exclude certain clone patterns
- `--prefer-clone <name>` - custom clone preference
- `--verbose` - show which clones were selected/skipped

### v3 Features  
- Support other VCS (not just git)
- Support other hosting (not just GitHub)
- Configuration file for custom selection rules

## Related Tools

**Will follow similar pattern**:
- `grep-projects` - grep deduplicated by project
- `ack-projects` - ack deduplicated by project  
- `git-all-clones` - run git command across all clones of a project

**All will use**: `jalanb_clones` module for understanding structure

## Open Questions

1. **Output format**: Just paths, or include project name?
2. **Error handling**: Silent skip or warn on stderr?
3. **Configuration**: Hard-coded selection rules or configurable?
4. **Performance**: Acceptable for 1000+ repos?

## Implementation Notes

### Phase 1: Basic Functionality
- Read stdin, group by GitHub URL, output best
- Hard-coded selection rules
- No caching, simple implementation

### Phase 2: Polish  
- Add error handling
- Add basic caching
- Add tests
- Document edge cases

### Phase 3: Performance
- Optimize git command usage
- Add comprehensive caching
- Handle large inputs gracefully
