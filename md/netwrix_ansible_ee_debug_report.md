# Netwrix Ansible Development & Execution-Environment Debugging Report

## Objectives
- Develop and test the **Netwrix Linux Agent** Ansible role locally.
- Run the role in a way that is **consistent with SMBC production policy**:
  - No local sudo passwords
  - Privilege via **Execution Environments (EE)**
  - Inventory and policy coming from ServiceNow / AAP
- Build a **safe, repeatable local developer workflow** that allows:
  - `--list-tasks` / dry inspection
  - Real execution only through the EE

---

## Where We Started
- Local development of `smbc.netwrix` collection under:
  ```text
  ~/ansible-dev/ansible_collections/smbc/netwrix
  ```
- A simple wrapper function calling `ansible-navigator run`.
- Initial attempts used `--ee false` and relied on local Ansible execution.
- Immediate issues encountered:
  - SNOW inventory bleeding in
  - Missing collections
  - Missing facts
  - Privilege escalation failures (`sudo` password prompts)

---

## Changes / Enhancements Attempted (Chronological)

### 1. Inventory & SNOW Isolation
- Static inventory explicitly set via `-i`.
- Discovered that `ansible-navigator` always injected inventory from `~/.ansible-navigator.yml` unless overridden.

### 2. Tags & Role Execution Semantics
- Learned that `--tags` skips untagged `pre_tasks`.
- Added `tags: always` to bootstrap tasks.

### 3. Fact Gathering Issues
- Role depended on `ansible_distribution_major_version`.
- Minimal `setup` only produced modern facts under `ansible_facts.*`.
- Created local shim logic to populate legacy alias for dev runs.

### 4. Privilege Model Discovery
- Learned that **humans are not meant to sudo**.
- Privilege in SMBC is delegated via **Execution Environments**.
- `--ee false` was explicitly **breaking the intended model**.

### 5. EE Re-Enablement
- Re-enabled EE execution.
- Encountered failures because:
  - Local collection code was invisible inside the container.

### 6. Volume Mounting for EE-based Development
- Correct approach identified:
  - Bind-mount local dev collection into EE.
- Required path:
  ```text
  /usr/share/ansible/collections/ansible_collections
  ```

### 7. Path Errors Encountered
- Tilde (`~`) not expanded → mount failures.
- `ansible-collections` vs `ansible_collections` typo.

### 8. Environment Variable Poisoning
- Exporting `ANSIBLE_COLLECTIONS_PATH` on the host broke EE resolution.
- Had to **remove host-side exports entirely**.

### 9. Argument Boundary Errors
- `ansible-navigator` vs `ansible-playbook` argument order confusion.
- Learned strict rule:
  ```text
  navigator opts → playbook → -- → playbook opts
  ```

### 10. Invalid Flag Discovery
- `--env-vars` is **not a valid ansible-navigator option**.
- Any occurrence was forwarded to `ansible-playbook` and caused failures.

---

## Problems Encountered (Root Causes)

| Problem | Root Cause |
|-------|-----------|
| Role not found | Collection not visible inside EE |
| Facts undefined | Minimal setup + legacy var assumption |
| sudo timeout | No user password by design |
| volume mount ignored | Wrong container path |
| collection ignored | Host env var overriding EE |
| persistent arg errors | Invalid `--env-vars` usage |

---

## Where We Are Now
- ✅ Clear understanding of SMBC execution model:
  - EE is the authority boundary
  - Humans never sudo
  - Local runs are for *reasoning*, EE runs for *execution*
- ✅ Working local collection layout.
- ✅ Correct mount strategy identified.
- ❌ Still failing role resolution because current wrapper is mixing:
  - Host `ANSIBLE_COLLECTIONS_PATH`
  - EE execution

---

## What to Try Next (Recommended Path)

### Step 1 – Clean Separation (Critical)
- **Remove all host-side Ansible env exports**, especially:
  ```bash
  export ANSIBLE_COLLECTIONS_PATH=...
  ```

### Step 2 – Minimal, Correct Wrapper
- Use only:
  - EE enabled
  - Volume mount to correct collection path
  - No env var overrides

Canonical working pattern:
```bash
ansible-navigator run   --execution-environment-volume-mounts   "$HOME/ansible-dev/ansible_collections:/usr/share/ansible/collections/ansible_collections"   test_netwrix_install.yml   --   -e snow_company=SMBC   -i "$INVENTORY"   --tags linux_agents_netwrix   --list-tasks
```

### Step 3 – Validate Inside EE
```bash
ansible-navigator exec --ee-shell
ls /usr/share/ansible/collections/ansible_collections/smbc/netwrix
```

If visible → role resolution will succeed.

---

## Final Notes
- Nothing uncovered here was user error; every failure revealed **implicit organisational contracts**.
- This exercise successfully reverse-engineered:
  - Policy boundaries
  - Execution responsibility
  - Correct dev vs prod expectations

Once collection visibility is solved cleanly, all further failures will be **real Netwrix logic**, not infrastructure.
