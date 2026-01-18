package com.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Date;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        Date currentDate = new Date();
        
        PrintWriter out = response.getWriter();
        try {
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Simple Java App</title>");
            out.println("<style>");
            out.println("body { font-family: Arial, sans-serif; margin: 50px; background-color: #f0f0f0; }");
            out.println("h1 { color: #333; }");
            out.println(".info { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }");
            out.println("</style>");
            out.println("</head>");
            out.println("<body>");
            out.println("<div class='info'>");
            out.println("<h1>Hello, Docker! 🐳</h1>");
            out.println("<p><strong>Current date:</strong> " + currentDate + "</p>");
            out.println("<p><strong>Server:</strong> Apache Tomcat</p>");
            out.println("<p><strong>Status:</strong> ✅ Application running successfully!</p>");
            out.println("</div>");
            out.println("</body>");
            out.println("</html>");
        } finally {
            out.close();
        }
    }
}