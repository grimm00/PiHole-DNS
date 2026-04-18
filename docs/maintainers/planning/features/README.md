# Feature Planning Hub

**Purpose:** Feature-based planning and tracking using hub-and-spoke documentation  
**Status:** ✅ Active  
**Last Updated:** 2026-04-19

---

## 📋 Quick Links

### Active Features

- **[layer-0-foundation](layer-0-foundation/README.md)** — Layer 0 MVP (runbooks, README entry points, Compose digest pin) — 🟠 In progress ([status](layer-0-foundation/status-and-next-steps.md))

---

## 🎯 Overview

Feature planning organizes development work around user-facing functionality. Each feature has its own directory with hub-and-spoke documentation for clear navigation and focused content.

### Feature Planning Philosophy

1. **User-Centric** - Features solve real user problems
2. **Hub-and-Spoke** - Clear entry points with detailed documentation
3. **Task-Group Based** - Break features into manageable task groups
4. **Status Tracking** - Consistent progress monitoring
5. **Fix Integration** - Troubleshooting documentation included

---

## 📁 Feature Directory Structure

```
features/
├── [feature-name]/
│   ├── README.md                    # 📍 HUB - Feature overview
│   ├── implementation-plan.md       # Task index (YAML frontmatter + GFM checkboxes)
│   ├── status-and-next-steps.md     # Current status and progress
│   ├── tasks/                       # 📁 Task group details
│   │   ├── 01-foundation.md         # Group 1 tasks
│   │   ├── 02-implementation.md     # Group 2 tasks
│   │   └── 03-polish.md             # Group 3 tasks
│   ├── fix/                         # 📁 Troubleshooting
│   │   ├── README.md                # Fix hub
│   │   └── *.md                     # Fix documentation
│   └── archived/                    # 📁 Superseded docs
│       └── old-plan.md              # Historical documents
```

---

## 🎨 Feature Development Pattern

### 1. Feature Discovery

- Identify user problem or opportunity
- Create feature directory
- Run `/explore` and `/research` for investigation

### 2. Planning

- Create ADRs with `/decision` for key decisions
- Generate plan with `/transition-plan` (creates `implementation-plan.md` + `tasks/`)
- Review plan with `/plan-review`
- Set up status tracking

### 3. Implementation

- Execute tasks sequentially with `/task next`
- Update status documents as groups complete
- Document decisions and learnings
- Create fix documentation as needed

### 4. Completion

- Document results and metrics
- Archive superseded documents
- Update project roadmap
- Share lessons learned

---

## 📊 Feature Status Overview

### ✅ Completed Features

| Feature     | Status      | Duration | Result    |
| ----------- | ----------- | -------- | --------- |
| [Feature 1] | ✅ Complete | X days   | [Summary] |

### 🟠 In Progress Features

| Feature     | Current Group | Progress | Next        |
| ----------- | ------------- | -------- | ----------- |
| [Feature 1] | Group 2       | 5/12     | [Next step] |

### 🟡 Planned Features

| Feature     | Priority | Estimated | Dependencies   |
| ----------- | -------- | --------- | -------------- |
| [Feature 1] | High     | X days    | [Dependencies] |

---

## 🚀 Quick Start

### Creating a New Feature

1. **Create Directory**

   ```bash
   mkdir -p features/[feature-name]/tasks
   cd features/[feature-name]
   ```

2. **Generate Plan**

   Use `/transition-plan` to scaffold the plan automatically, or create manually:
   - `implementation-plan.md` — Task index with YAML frontmatter
   - `status-and-next-steps.md` — Progress tracking
   - `tasks/01-group-name.md` — Task group files

3. **Customize Content**

   - Update feature description and goals
   - Define success criteria
   - Break into task groups
   - Set up status tracking

4. **Link to Hub**
   - Add feature to `features/README.md`
   - Update project roadmap
   - Create initial status document

### Feature Planning Checklist

- [ ] Feature directory created with `tasks/` subdirectory
- [ ] README.md hub with quick links
- [ ] `implementation-plan.md` with overview and task checkboxes
- [ ] Task group files in `tasks/` (e.g., `01-foundation.md`)
- [ ] `status-and-next-steps.md` created
- [ ] Feature added to `features/README.md`
- [ ] Project roadmap updated

---

## 📝 Templates

### Implementation Plan Template

```markdown
---
task_count: 8
groups:
  - name: "Foundation"
    file: "tasks/01-foundation.md"
    tasks: [1, 2, 3]
  - name: "Implementation"
    file: "tasks/02-implementation.md"
    tasks: [4, 5, 6, 7, 8]
tasks_files:
  - "tasks/01-foundation.md"
  - "tasks/02-implementation.md"
---
# Implementation Plan - [Feature Name]

**Status:** [Status]
**Created:** [Date]

## 📋 Overview

[Feature description and context]

## 📝 Implementation Plan

### Foundation
- [ ] Task 1: [Task description]
- [ ] Task 2: [Task description]

### Implementation
- [ ] Task 3: [Task description]

## ✅ Definition of Done

- [ ] All tasks complete
- [ ] Tests passing
```

### Task Group Template

```markdown
# [Group Name]

**Feature:** [Feature Name]
**Group:** [Group Name]
**Status:** [Status]

## 📝 Tasks

- [ ] Task N: [Title]
  - [Description]
  - [Acceptance criterion]

## ✅ Completion Criteria

- [ ] [Criterion 1]
- [ ] [Criterion 2]
```

---

## 📚 Related Documents

### Planning

- [Planning Hub](../README.md) - Overall planning overview
- [Release Process](../releases/README.md) - Release management

### External References

- [Hub-and-Spoke Best Practices](../../../../../docs/BEST-PRACTICES.md) - See hub-and-spoke documentation patterns

---

**Last Updated:** 2026-04-19  
**Status:** ✅ Active  
**Next:** [Next feature planning task]
