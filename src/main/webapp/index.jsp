<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<title>FitTrack Login</title>

<style>
body {
    font-family: Arial, sans-serif;
    background: #f4f6f8;
}

.box {
    width: 350px;
    margin: 100px auto;
    background: white;
    padding: 25px;
    border-radius: 10px;
    box-shadow: 0 0 10px #ccc;
}

h2 {
    text-align: center;
}

input {
    width: 100%;
    padding: 8px;
    margin: 10px 0;
}

button {
    width: 100%;
    padding: 10px;
    background: #2c3e50;
    color: white;
    border: none;
    border-radius: 5px;
}

button:hover {
    background: #1a252f;
    cursor: pointer;
}

a {
    display: block;
    text-align: center;
    margin-top: 15px;
}

.error {
    
    color: #ff0000;
    padding: 10px;
    border-radius: 5px;
    margin-bottom: 15px;
    text-align: center;
    font-size: 14px;
}
</style>
</head>

<body>

<div class="box">
    <h2>FitTrack Login</h2>

    <form action="LoginServlet" method="post">
        <input type="email" name="email" placeholder="Email" required>
        <input type="password" name="password" placeholder="Password" required>
        <button type="submit">Login</button>
    </form>

	
	<% 
        String error = (String) request.getAttribute("errorMessage");
        if(error != null){
    %>
        <div class="error">
            <%= error %>
        </div>
    <% } %>
    
    <a href="register.jsp">New user? Create account</a>
</div>

</body>
</html>
