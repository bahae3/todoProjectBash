#!/bin/sh

TODO_FILE="todo_tasks.txt"

# Function to display error message and exit
display_error() {
    echo "Error: $1" >&2
    exit 1
}

# Function to create a task
create_task() {
    echo "Enter task title (required):"
    read -r title
    if [[ -z $title ]]; then
        display_error "Title cannot be empty"
    fi

    echo "Enter task description:"
    read -r description

    echo "Enter task location:"
    read -r location

    echo "Enter due date (YYYY-MM-DD) (required):"
    read -r due_date
    if [[ ! $due_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        display_error "Invalid due date format. Use YYYY-MM-DD."
    fi

    echo "Enter due time (HH:MM):"
    read -r due_time

    echo "Is the task completed? (yes/no):"
    read -r completed
    if [[ $completed != "yes" && $completed != "no" ]]; then
        display_error "Invalid input for completion status. Enter 'yes' or 'no'."
    fi

    # Generate unique task ID
    task_id=$(date +%s)

    # Save task to file
    echo "$task_id|$title|$description|$location|$due_date $due_time|$completed" >> "$TODO_FILE"
    echo "Task created with ID: $task_id"
}

# Function to update a task
update_task() {
    echo "Enter task ID to update:"
    read -r task_id

    task_info=$(grep "^$task_id|" "$TODO_FILE")
    if [[ -z $task_info ]]; then
        display_error "Task with ID $task_id not found"
    fi

    echo "Enter new title (leave blank to keep existing):"
    read -r new_title
    if [[ -n $new_title ]]; then
        task_info=$(echo "$task_info" | sed "s/^[^|]*|/$new_title|/")
    fi

    echo "Enter new description:"
    read -r new_description
    task_info=$(echo "$task_info" | sed "s/|[^|]*|/|$new_description|/2")

    echo "Enter new location:"
    read -r new_location
    task_info=$(echo "$task_info" | sed "s/|[^|]*|/|$new_location|/3")

    echo "Enter new due date (YYYY-MM-DD):"
    read -r new_due_date
    if [[ $new_due_date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        task_info=$(echo "$task_info" | sed "s/|[^|]*|/|$new_due_date|/4")
    fi

    echo "Enter new due time (HH:MM):"
    read -r new_due_time
    task_info=$(echo "$task_info" | sed "s/|[^|]*$|/|$new_due_time|/")

    echo "Is the task completed? (yes/no):"
    read -r new_completed
    if [[ $new_completed == "yes" || $new_completed == "no" ]]; then
        task_info=$(echo "$task_info" | sed "s/|[^|]*$/|$new_completed/")
    else
        display_error "Invalid input for completion status. Enter 'yes' or 'no'."
    fi

    # Update task in file
    sed -i "/^$task_id|/c\\$task_info" "$TODO_FILE"
    echo "Task with ID $task_id updated"
}

# Function to delete a task
delete_task() {
    echo "Enter task ID to delete:"
    read -r task_id

    if grep -q "^$task_id|" "$TODO_FILE"; then
        sed -i "/^$task_id|/d" "$TODO_FILE"
        echo "Task with ID $task_id deleted"
    else
        display_error "Task with ID $task_id not found"
    fi
}

# Function to show task information
show_task() {
    echo "Enter task ID:"
    read -r task_id

    task_info=$(grep "^$task_id|" "$TODO_FILE")
    if [[ -z $task_info ]]; then
        display_error "Task with ID $task_id not found"
    else
        echo "$task_info"
    fi
}

# Function to list tasks for a given day
list_tasks_for_day() {
    echo "Enter date (YYYY-MM-DD) to list tasks for:"
    read -r date

    if [[ ! $date =~ ^[0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
        display_error "Invalid date format. Use YYYY-MM-DD."
    fi

    echo "Completed tasks for $date:"
    grep "|$date" "$TODO_FILE" | grep "|yes" | cut -d '|' -f2,3,4,5

    echo "Uncompleted tasks for $date:"
    grep "|$date" "$TODO_FILE" | grep "|no" | cut -d '|' -f2,3,4,5
}

# Function to search for a task by title
search_task_by_title() {
    echo "Enter title to search for:"
    read -r title

    echo "Tasks with title '$title':"
    grep "|$title|" "$TODO_FILE"
}

# Main function
main() {
    case $1 in
        create)
            create_task
            ;;
        update)
            update_task
            ;;
        delete)
            delete_task
            ;;
        show)
            show_task
            ;;
        list)
            list_tasks_for_day
            if [[ $# -eq 1 ]]; then
                list_tasks_for_day
            else
                shift
                list_tasks_for_day "$@"
            fi
            ;;
        search)
            search_task_by_title
            ;;
        *)
            display_error "Invalid action. Available actions: create, update, delete, show, list, search"
            ;;
    esac
}

main "$@"
