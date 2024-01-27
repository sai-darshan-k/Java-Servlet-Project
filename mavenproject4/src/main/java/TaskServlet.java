import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/TaskServlet")
public class TaskServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null) {
            switch (action) {
                case "add":
                    addTask(request);
                    retrieveTasks(request, response);
                    break;
                case "retrieve":
                    retrieveTasks(request, response);
                    break;
                case "edit":
                    editTask(request);
                    retrieveTasks(request, response);
                    break;
                case "delete":
                    deleteTask(request);
                    retrieveTasks(request, response);
                    break;
            }
        }
    }

    private void addTask(HttpServletRequest request) {
        HttpSession session = request.getSession(true);

        List<String> tasks = (List<String>) session.getAttribute("tasks");
        if (tasks == null) {
            tasks = new ArrayList<>();
        }

        String task = request.getParameter("task");
        if (task != null && !task.isEmpty()) {
            tasks.add(task);
            session.setAttribute("tasks", tasks);
        }
    }

   private void editTask(HttpServletRequest request) {
        HttpSession session = request.getSession(true);

        List<String> tasks = (List<String>) session.getAttribute("tasks");
        if (tasks != null && !tasks.isEmpty()) {
            String editedTask = request.getParameter("task");

            // Implement your logic to find and edit the task
            // For simplicity, let's assume we edit the first task
            if (editedTask != null && !editedTask.isEmpty()) {
                tasks.set(0, editedTask);
                session.setAttribute("tasks", tasks);
            }
        }
    }
   
       private void deleteTask(HttpServletRequest request) {
        HttpSession session = request.getSession(true);

        List<String> tasks = (List<String>) session.getAttribute("tasks");
        if (tasks != null && !tasks.isEmpty()) {
            // Implement your logic to delete the task
            // For simplicity, let's assume we delete the first task
            tasks.remove(0);
            session.setAttribute("tasks", tasks);
        }
    }
    
private void retrieveTasks(HttpServletRequest request, HttpServletResponse response) throws IOException {
    HttpSession session = request.getSession(false);

    if (session != null) {
        List<String> tasks = (List<String>) session.getAttribute("tasks");

        response.setContentType("text/html");  // Set Content-Type header
        PrintWriter out = response.getWriter();

        if (tasks != null && !tasks.isEmpty()) {
            out.println("<ul>");
            for (String task : tasks) {
                out.println("<li>" + task + "</li>");
            }
            out.println("</ul>");
        } else {
            out.println("No tasks found.");
        }
    }
}
}

