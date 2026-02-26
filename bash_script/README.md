# 🗂️ Mini Task Manager

A full-featured **Task Management System** built with pure Bash scripting. Manage your daily tasks directly from the terminal with an interactive menu, full CRUD operations, search, and reports.

---

## 📋 Project Overview

This project was built as part of a Bash Scripting course assignment. It allows users to create, view, update, delete, and report on tasks — all stored locally in a plain text file.

---

## ✨ Features

### Core (CRUD)

- **Add Task** — Enter a title, priority, and due date; the system auto-generates a unique ID and sets status to `pending`
- **List Tasks** — Display all tasks in a clean, formatted table
- **Update Task** — Modify any field of an existing task by ID
- **Delete Task** — Remove a task by ID with a confirmation prompt
- **Search** — Search tasks by keyword in the title field

### Reports

- **Task Summary** — Count of tasks per status (`pending`, `in-progress`, `done`)
- **Overdue Tasks** — Lists all non-done tasks whose due date has already passed
- **Priority Report** — Tasks grouped and displayed by priority level (`high`, `medium`, `low`)

### Bonus

- 🎨 Colored terminal output using ANSI escape codes

---

## 🚀 Getting Started

### Prerequisites

- A Unix/Linux environment (or Git Bash / WSL on Windows)
- Bash 4+

### Run the Script

```bash
bash task_final.sh
```

---

## 🗃️ Data Storage

All tasks are stored in `tasks.txt` in the same directory as the script. Each line represents one task with fields separated by `|`:

```
ID|Title|Priority|Due Date|Status
```

**Example:**

```
1|Fix login bug|high|2025-06-01|in-progress
2|Write unit tests|medium|2025-06-10|pending
3|Deploy to staging|low|2025-05-20|done
```

The file is created automatically on first run if it doesn't exist.

---

## 🖥️ Interactive Menu

```
---- Task Manager ----

1) Add Task
2) List Tasks
3) Update Task
4) Delete Task
5) Search
6) Task Summary
7) Overdue Tasks
8) Priority Report
9) Exit
```

After every operation the menu is shown again, so you can keep working until you choose **9) Exit**.

---

## ✅ Input Validation

| Field    | Rule                                        |
| -------- | ------------------------------------------- |
| Title    | Cannot be empty                             |
| Priority | Must be `high`, `medium`, or `low`          |
| Due Date | Must be a valid date in `YYYY-MM-DD` format |
| Task ID  | Must exist before update or delete          |

---

## 🛠️ Tools & Commands Used

| Tool / Command | Purpose                         |
| -------------- | ------------------------------- |
| `grep`         | Searching and filtering tasks   |
| `sed`          | In-place editing and deletion   |
| `date`         | Date validation and comparison  |
| `read`         | Capturing user input            |
| `IFS` / `<<<`  | Splitting pipe-delimited fields |
| ANSI codes     | Colored terminal output         |

---

## 📁 Project Structure

```
.
├── task_final.sh   # Main script
├── tasks.txt       # Auto-generated task storage file
└── README.md       # Project documentation
```

---

## 👤 Author

Built as a Bash Scripting course project.
