# Resolving Conflicts After Squash Merge with Stacked Branches

## Scenario

You are trying to add a feature to a project:

- Create `feature-1` branch from `main`
- Commit feature to `feature-1` -> submit PR for review
- Build new feature from `feature-1` (`feature-2` branch)
- Commit feature to `feature-2`
- Respond to PR review and add new commit to `feature-1`
- PR approved and "squash merge" into `main`

Visual representation:

```
main:       A─────────────────S (squash commit)
             \
feature-1:    B───C───D       (D added during review)
                   \
feature-2:          X───Y     (branched after C)
```

where...

- **A** = Initial commit
- **B, C** = Commits working on Feature-1
- **D** = Changes made after code review
- **X, Y** = Commits working on feature-2
- **S** = The "squash" commit (all of B+C+D smooshed into one commit)

**ISSUE:** `feature-2` contains commits B and C in its history, but `main`
now has commit S (which contains the same changes as B+C+D but with a different
SHA). Git sees these as unrelated changes and reports conflicts.

## The Solution: `git rebase --onto`

```bash
git rebase --onto <new-base> <old-base> <branch>
```

- **new-base**: Where you want to put the commits (usually `main` or `origin/main`)
- **old-base**: The commit BEFORE your first unique commit (the branch point)
  - See `git merge-base <original-parent-branch> <branch>` (use the branch you created from, not main)
- **branch**: The branch you're moving

Going back to our example:

```bash
git fetch origin main
git checkout feature-2
git rebase --onto origin/main <commit-C> feature-2
```

In simple terms, `git rebase --onto` "replays" parts of Feature-2 not found on
`main` (commits X and Y) on top of the new squashed commit (S).

---

## Example 1: Clean Rebase (No Conflicts)

The simplest demonstration of `git rebase --onto` is where changes in
Feature-2 do not overlap with code added in Feature-1.

### Step 1: Create Demo Repo + Commit A

```bash
# Create 'test_rebase' directory with initial 'main' branch
git init -b main test_rebase
cd test_rebase

# Create 'README.md' and commit (A)
echo "# Project" > README.md
git add README.md
git commit -m "A: Initial commit"

```

**The repository now looks like this:**

```
main:       A ← We are here
```

### Step 2: Build Feature-1

```bash
# Create feature branch from 'main'
git checkout -b feature-1

# Create 'feature1.txt' and commit (B)
echo "feature 1 - part 1" > feature1.txt
git add feature1.txt
git commit -m "B: Add feature 1 part 1"

# Add line to 'feature1.txt' and commit (C)
echo "feature 1 - part 2" >> feature1.txt
git add feature1.txt
git commit -m "C: Add feature 1 part 2"
```

**The repository now looks like this:**

```
main:       A
             \
feature-1:    B───C  ← We are here
```

At this point, we would create a PR request to merge `feature-1` into
`main` and wait for a review.

### Step 3: Start Building Feature-2 (Commits X and Y)

While we wait for the review to complete, we create a new branch
`feature-2` from `feature-1` and build Feature-2.

```bash
# Create feature branch 'feature-2' from 'feature-1' branch
git checkout -b feature-2

# Create 'feature2.txt' and commit (X)
echo "feature 2 - part 1" > feature2.txt
git add feature2.txt
git commit -m "X: Add feature 2 part 1"

# Add line to 'feature2.txt' and commit (Y)
echo "feature 2 - part 2" >> feature2.txt
git add feature2.txt
git commit -m "Y: Add feature 2 part 2"
```

**The repository now looks like this:**

```
main:       A
             \
feature-1:    B───C
                   \
feature-2:          X───Y  ← We are here
```

### Step 4: Respond to Code Review (Commit D)

The reviewer requests some changes to `feature-1` before we can merge to
`main`.

```bash
# Add response to PR review
git checkout feature-1
echo "feature 1 - review fix" >> feature1.txt
git add feature1.txt
git commit -m "D: Address review feedback"
```

**The repository now looks like this:**

```
main:       A
             \
feature-1:    B───C───D  ← We are here (added D after review)
                   \
feature-2:          X───Y
```

The branch `feature-1` is now ready to merge into `main`!

### Step 5: Squash Merge Feature-1 into Main (Creating S)

Feature branches frequently include multiple commits as the feature is
developed. When it is time to merge onto `main`, "squash merge" represents the
entire feature as a single commit. This creates a clear, linear history.
Additionally, it makes it easier to remove the feature at a later time.

Here, we merge `feature-1` branch into `main` using a "squash merge". This
takes all the commits (B, C, D) and combines them into ONE new commit (S).

```bash
git checkout main
git merge --squash feature-1
git commit -m "S: Add feature 1 (#1)"

```

**_LAZYGIT:_**

- Checkout `main` branch
- Navigate to `feature-1` branch
- `M` + `S` to "squash merge" (will not prompt you for commit message)

**The repository now looks like this:**

```
main:       A─────────────────S  ← We are here (S contains B+C+D smooshed together)
             \
feature-1:    B───C───D
                   \
feature-2:          X───Y
```

**The problem is now visible:** `feature-2` has commits B and C in its history,
but `main` has commit S (which contains the same changes but looks different to
git).

More importantly, the commit histories are much different.

- `main` -> A and S
- `feature-2` -> B, C, X, and Y

Git sees 4 commits that aren't in main. But wait—B and C are already in main
(inside S)! Git just doesn't know that because S has a different ID.

### Step 6: The Magic Fix (Rebase --onto)

To rebase, we will use the following command:

From the `feature-2` branch, we will rebase onto `main` using the following
command:

```bash
git rebase --onto <new-base> <old-base> <branch>
```

Where:

- `<new-base>` = `main`, branch we want to rebase onto
- `<old-base>` = `{{commit C hash}}`
  - Fetch hash using `git merge-base feature-1 feature-2 | pbcopy` (use the branch feature-2 was created from)
- `<branch>` = `feature-2`, branch we wish to move to `main`

**_LAZYGIT:_**

- Checkout `feature-2` branch
- Define <old-base> by navigating to commit C + `B`
- Rebase onto `main` by navigating to `main` branch + `r` + `s`

**The repository now looks like this:**

```
main:       A───S
                 \
feature-2:        X'───Y'  ← The commits have new IDs (X' and Y') because they were replayed
```

### Step 7: Verify It Worked

```bash
git log --oneline main..feature-2
```

**What this shows:**

```
Y': Add feature 2 part 2
X': Add feature 2 part 1
```

Only 2 commits now—exactly what feature-2 actually added.

## Quick Reference: The Magic Command

```bash
git rebase --onto <new-base> <old-base> <branch>
```

- **new-base**: Where you want to put the commits (usually `main` or `origin/main`)
- **old-base**: The commit BEFORE your first unique commit (the branch point)
- **branch**: The branch you're moving

**In English:** "Take everything after old-base on branch, and replay it onto new-base."

---

## References

- [git-rebase documentation](https://git-scm.com/docs/git-rebase)
- [Git Book: Rebasing](https://git-scm.com/book/en/v2/Git-Branching-Rebasing)
