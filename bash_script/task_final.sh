#!/bin/bash

# ===============================
# Mini Task Manager - Bash Project
# ===============================

TASK_FILE="tasks.txt"

# --------- Colors ----------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'
ITALIC='\033[3m'
BOLD='\033[1m'
UNDERLINE='\033[4m'

# Create file if not exists
if [ ! -f "$TASK_FILE" ]; then
    touch "$TASK_FILE"
fi

# --------- Shared Display Helpers ----------
print_header() {
    printf "%-5s %-20s %-10s %-12s %-12s\n" "ID" "Title" "Priority" "Due Date" "Status"
    echo "------------------------------------------------------------"
}

print_row() {
    IFS="|" read -r id title priority due_date status <<< "$1"
    printf "%-5s %-20s %-10s %-12s %-12s\n" "$id" "$title" "$priority" "$due_date" "$status"
}

# Generate new ID (last ID + 1)
generate_id() {
    if [ ! -s "$TASK_FILE" ]; then
        echo 1
    else
        last_id=$(tail -n 1 "$TASK_FILE" | cut -d '|' -f1)
        echo $((last_id + 1))
    fi
}

# --------- Add Task ----------
add_task() {
    echo -e "${BLUE}--- Add New Task ---${NC}"

    read -p "Enter title: " title
    if [ -z "$title" ]; then
        echo -e "${RED}Title cannot be empty!${NC}"
        return
    fi

    read -p "Enter priority (high/medium/low): " priority
    if [[ "$priority" != "high" && "$priority" != "medium" && "$priority" != "low" ]]; then
        echo -e "${RED}Invalid priority!${NC}"
        return
    fi

    read -p "Enter due date (YYYY-MM-DD): " due_date
    date -d "$due_date" >/dev/null 2>&1

    if [ $? -ne 0 ]; then
        echo -e "${RED}Invalid date format!${NC}"
        return
    fi

    id=$(generate_id)
    echo "$id|$title|$priority|$(date -d "$due_date" +%Y-%m-%d)|pending" >> "$TASK_FILE"

    echo -e "${GREEN}Task added successfully!${NC}"
}

# --------- List Tasks ----------
list_tasks() {
    echo -e "${BLUE}--- All Tasks ---${NC}"
    if [ ! -s "$TASK_FILE" ]; then
        echo "No tasks found."
        return
    fi

    print_header
    while IFS= read -r line; do
        print_row "$line"
    done < "$TASK_FILE"
}

# --------- Update Task ----------
update_task() {
    list_tasks
    read -p "Enter task ID to update: " id

    line_num=$(grep -n "^$id|" "$TASK_FILE" | cut -d: -f1)

    if [ -z "$line_num" ]; then
        echo -e "${RED}Task ID not found!${NC}"
        return
    fi

    current=$(grep "^$id|" "$TASK_FILE")
    IFS="|" read -r cur_id cur_title cur_priority cur_date cur_status <<< "$current"

    read -p "New title ($cur_title): " new_title
    new_title="${new_title:-$cur_title}"

    read -p "New priority ($cur_priority): " new_priority
    new_priority="${new_priority:-$cur_priority}"

    read -p "New due date ($cur_date): " new_date
    new_date="${new_date:-$cur_date}"

    read -p "New status ($cur_status): " new_status
    new_status="${new_status:-$cur_status}"

    sed -i "${line_num}s/.*/$id|$new_title|$new_priority|$new_date|$new_status/" "$TASK_FILE"

    echo -e "${GREEN}Task updated successfully!${NC}"
}

# --------- Delete Task ----------
delete_task() {
    list_tasks
    read -p "Enter task ID to delete: " id

    line_num=$(grep -n "^$id|" "$TASK_FILE" | cut -d: -f1)

    if [ -z "$line_num" ]; then
        echo -e "${RED}Task ID not found!${NC}"
        return
    fi

    read -p "Are you sure? (y/n): " confirm
    if [ "$confirm" != "y" ]; then
        echo "Cancelled."
        return
    fi

    sed -i "${line_num}d" "$TASK_FILE"

    echo -e "${GREEN}Task deleted successfully!${NC}"
}

# --------- Search ----------
search_task() {
    read -p "Enter keyword: " keyword

    print_header
    while IFS= read -r line; do
        print_row "$line"
    done < <(grep -i "$keyword" "$TASK_FILE")
}

# --------- Reports ----------
task_summary() {
    echo -e "${YELLOW}--- Task Summary ---${NC}"
    echo "Pending:     $(grep -c '|pending$' "$TASK_FILE")"
    echo "In-Progress: $(grep -c '|in-progress$' "$TASK_FILE")"
    echo "Done:        $(grep -c '|done$' "$TASK_FILE")"
}

overdue_tasks() {
    today=$(date +%Y-%m-%d)
    echo -e "${YELLOW}--- Overdue Tasks ---${NC}"

    print_header
    while IFS= read -r line; do
        IFS="|" read -r id title priority due_date status <<< "$line"
        if [[ "$due_date" < "$today" && "$status" != "done" ]]; then
            print_row "$line"
        fi
    done < "$TASK_FILE"
}

priority_report() {
    for level in high medium low; do
        echo -e "${YELLOW}--- ${level^} Priority ---${NC}"
        print_header
        while IFS= read -r line; do
            print_row "$line"
        done < <(grep "|$level|" "$TASK_FILE")
        echo
    done
}

# --------- Main Menu ----------
while true
do
    echo
    echo
    echo -e "${BLUE}${ITALIC}${BOLD}---- Task Manager ----${NC}"
    echo
    echo "1) Add Task"
    echo "2) List Tasks"
    echo "3) Update Task"
    echo "4) Delete Task"
    echo "5) Search"
    echo "6) Task Summary"
    echo "7) Overdue Tasks"
    echo "8) Priority Report"
    echo "9) Exit"

    read -p "Choose option: " choice
    echo
    echo

    case $choice in
        1) add_task ;;
        2) list_tasks ;;
        3) update_task ;;
        4) delete_task ;;
        5) search_task ;;
        6) task_summary ;;
        7) overdue_tasks ;;
        8) priority_report ;;
        9) exit ;;
        *) echo -e "${RED}Invalid option!${NC}" ;;
    esac
done