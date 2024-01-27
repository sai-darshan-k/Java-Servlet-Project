<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat, jakarta.servlet.http.HttpSession" %>

<!DOCTYPE html>
<html>
<head>
    <title>Welcome, Sai</title>
    <style>
        body {
            background-color: #f0f0f0;
            font-family: Arial, sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
        }

        #welcome-container {
            background-color: #fff;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        #tasks-container {
            background-color: #f8f8f8;
            border: 1px solid #ddd;
            padding: 20px;
            border-radius: 8px;
            margin-top: 20px;
            width: 300px;
            margin-left: auto;
            margin-right: auto;
        }

        #taskInput {
            width: 100%;
            padding: 8px;
            margin-bottom: 16px;
            box-sizing: border-box;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        button {
            background-color: #4caf50;
            color: #fff;
            cursor: pointer;
            padding: 8px;
            border: none;
            border-radius: 4px;
        }

        button:hover {
            background-color: #45a049;
        }

        /* Modal styles */
        .modal {
            display: none;
            position: fixed;
            z-index: 1;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            overflow: auto;
            background-color: rgba(0, 0, 0, 0.4);
        }

        .modal-content {
            background-color: #fefefe;
            margin: 15% auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }

        .close {
            color: #aaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: black;
            text-decoration: none;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div id="welcome-container">
        <h2>Welcome, Sai</h2>
        <h3>Manage your tasks here</h3>

        <!-- To-Do List -->
        <div id="tasks-container"></div>
        <input type="text" id="taskInput" placeholder="Add a new task">
        <button onclick="addTask()">Add Task</button>
        <button onclick="editTask()">Edit Task</button>
        <button onclick="deleteTask()">Delete Task</button>

        <!-- Edit Task Modal -->
        <div id="editTaskModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeEditTaskModal()">&times;</span>
                <h2>Edit Task</h2>
                <input type="text" id="editedTaskInput" placeholder="Enter edited task">
                <button onclick="saveEditedTask()">Save Changes</button>
            </div>
        </div>

    

    <!-- Logout Button at the Bottom -->
    <div style="position: fixed; background-color: #4caf50; color: #fff; bottom: 150px; left: 50%; transform: translateX(-50%);">
        <form action="LogoutServlet" method="get">
            <input type="submit" value="Logout">
        </form>
    </div>


    <script>
        function addTask() {
            var taskInput = document.getElementById("taskInput");
            var task = taskInput.value.trim();

            if (task !== "") {
                // Use AJAX to send the task to the servlet
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function () {
                    if (xhr.readyState === 4 && xhr.status === 200) {
                        taskInput.value = "";
                        retrieveTasks();
                    }
                };

                xhr.open("POST", "TaskServlet", true);
                xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
                xhr.send("action=add&task=" + encodeURIComponent(task));
            }
        }
        
            function deleteTask(index) {
        // Use AJAX to send the delete task request to the servlet
        var xhr = new XMLHttpRequest();
        xhr.onreadystatechange = function () {
            if (xhr.readyState === 4 && xhr.status === 200) {
                retrieveTasks();
            }
        };

        xhr.open("POST", "TaskServlet", true);
        xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
        xhr.send("action=delete&index=" + index);
    }
 
        function editTask(index) {
            // Display the edit task modal
            var modal = document.getElementById("editTaskModal");
            modal.style.display = "block";

            // Set the index as a data attribute in the modal for reference
            modal.setAttribute("data-index", index);

            // Retrieve the task text for the selected index
            var taskText = document.getElementById("task-text-" + index).innerText;
            document.getElementById("editedTaskInput").value = taskText;
        }

        function closeEditTaskModal() {
            // Close the edit task modal
            var modal = document.getElementById("editTaskModal");
            modal.style.display = "none";
        }

        function saveEditedTask() {
            // Retrieve the index from the modal data attribute
            var modal = document.getElementById("editTaskModal");
            var index = modal.getAttribute("data-index");

            // Retrieve the edited task text
            var editedTask = document.getElementById("editedTaskInput").value;

            // Use AJAX to send the edited task to the servlet
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    closeEditTaskModal();
                    retrieveTasks();
                }
            };

            xhr.open("POST", "TaskServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.send("action=edit&index=" + index + "&task=" + encodeURIComponent(editedTask));
        }

        function retrieveTasks() {
            // Use AJAX to retrieve tasks from the servlet
            var xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
                if (xhr.readyState === 4 && xhr.status === 200) {
                    console.log("Received HTML content:", xhr.responseText);

                    var tasksContainer = document.getElementById("tasks-container");
                    tasksContainer.innerHTML = xhr.responseText;
                }
            };

            xhr.open("POST", "TaskServlet", true);
            xhr.setRequestHeader("Content-Type", "application/x-www-form-urlencoded");
            xhr.send("action=retrieve");
        }
    </script>
</body>
</html>
