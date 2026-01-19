package com.example;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@WebServlet("/hello")
public class HelloServlet extends HttpServlet {
    
    private static final long serialVersionUID = 1L;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        // Use modern date/time API
        LocalDateTime currentDateTime = LocalDateTime.now();
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String formattedDate = currentDateTime.format(formatter);
        
        // Get deployment info
        String contextPath = request.getContextPath();
        String serverInfo = getServletContext().getServerInfo();
        
        try (PrintWriter out = response.getWriter()) {
            out.println("<!DOCTYPE html>");
            out.println("<html lang='en'>");
            out.println("<head>");
            out.println("    <meta charset='UTF-8'>");
            out.println("    <meta name='viewport' content='width=device-width, initial-scale=1.0'>");
            out.println("    <title>Simple Java App</title>");
            out.println("    <style>");
            out.println("        * { margin: 0; padding: 0; box-sizing: border-box; }");
            out.println("        body { ");
            out.println("            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;");
            out.println("            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);");
            out.println("            min-height: 100vh;");
            out.println("            display: flex;");
            out.println("            justify-content: center;");
            out.println("            align-items: center;");
            out.println("            padding: 20px;");
            out.println("        }");
            out.println("        .container {");
            out.println("            background: white;");
            out.println("            padding: 40px;");
            out.println("            border-radius: 16px;");
            out.println("            box-shadow: 0 10px 40px rgba(0,0,0,0.2);");
            out.println("            max-width: 600px;");
            out.println("            width: 100%;");
            out.println("        }");
            out.println("        h1 {");
            out.println("            color: #333;");
            out.println("            margin-bottom: 24px;");
            out.println("            font-size: 32px;");
            out.println("        }");
            out.println("        .info-item {");
            out.println("            margin: 16px 0;");
            out.println("            padding: 12px;");
            out.println("            background: #f8f9fa;");
            out.println("            border-left: 4px solid #667eea;");
            out.println("            border-radius: 4px;");
            out.println("        }");
            out.println("        .info-item strong {");
            out.println("            color: #667eea;");
            out.println("        }");
            out.println("        .status {");
            out.println("            display: inline-block;");
            out.println("            padding: 8px 16px;");
            out.println("            background: #10b981;");
            out.println("            color: white;");
            out.println("            border-radius: 20px;");
            out.println("            font-weight: bold;");
            out.println("            margin-top: 20px;");
            out.println("        }");
            out.println("    </style>");
            out.println("</head>");
            out.println("<body>");
            out.println("    <div class='container'>");
            out.println("        <h1>Hello, Docker! 🐳</h1>");
            out.println("        <div class='info-item'>");
            out.println("            <strong>📅 Current Date/Time:</strong> " + formattedDate);
            out.println("        </div>");
            out.println("        <div class='info-item'>");
            out.println("            <strong>🖥️ Server:</strong> " + serverInfo);
            out.println("        </div>");
            out.println("        <div class='info-item'>");
            out.println("            <strong>🌐 Context Path:</strong> " + contextPath);
            out.println("        </div>");
            out.println("        <div class='info-item'>");
            out.println("            <strong>☕ Java Version:</strong> " + System.getProperty("java.version"));
            out.println("        </div>");
            out.println("        <div class='info-item'>");
            out.println("            <strong>🔧 Deployment:</strong> Jenkins CI/CD Pipeline");
            out.println("        </div>");
            out.println("        <div style='text-align: center;'>");
            out.println("            <span class='status'>✅ Application running successfully!</span>");
            out.println("        </div>");
            out.println("    </div>");
            out.println("</body>");
            out.println("</html>");
        } catch (Exception e) {
            throw new ServletException("Error generating response", e);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        // Forward POST requests to GET
        doGet(request, response);
    }
}