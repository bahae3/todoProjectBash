# Task Manager Script
## A todo program

## Overview

This is a simple task manager script written in Bash. It allows users to manage tasks stored in a text file through a command-line interface.

## Design Choices

### Data Storage

Tasks are stored in a text file named `todo.txt`. Each task is represented as a single line in the file, with the following format:

task_id|title|description|location|due_date due_time|completed


Where:
- `task_id` is a unique identifier generated using the current timestamp.
- `title` is the title of the task.
- `description` is an optional description of the task.
- `location` is an optional field specifying the location of the task.
- `due_date` is the due date of the task in the format `YYYY-MM-DD`.
- `due_time` is the optional due time of the task in the format `HH:MM`.
- `completed` indicates whether the task is completed or not, with values 'yes' or 'no'.

### Code Organization

The code is organized into functions, each responsible for a specific task:
- `create_task`: Prompts the user to input task details and adds the task to the file.
- `update_task`: Allows the user to update an existing task by providing its ID.
- `delete_task`: Deletes a task based on the provided ID.
- `show_task`: Displays detailed information about a specific task.
- `list_tasks_for_day`: Lists tasks for a given date, both completed and uncompleted.
- `search_task_by_title`: Searches for tasks by title.
- `display_error`: Displays error messages and exits the program in case of invalid inputs or errors.
- `main`: The main function parses command-line arguments and executes the appropriate action.

## How to Run
1. Make the script executable:
chmod +x todo.sh

2. Run the script with desired actions:
./todo.sh <action>

Replace `<action>` with one of the following:
- `create`: Create a new task.
- `update`: Update an existing task.
- `delete`: Delete a task.
- `show`: Show details of a task.
- `list`: List tasks for a specific date.
- `search`: Search tasks by title.

Follow the prompts to input necessary details and interact with the task manager.
