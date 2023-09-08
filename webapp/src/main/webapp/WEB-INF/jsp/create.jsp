<%--suppress HtmlUnknownTarget --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Subir Archivo</title>
</head>
<body>
<h2>Subir Archivo</h2>
<form action="" method="post" enctype="multipart/form-data">
    <label for="file">Archivo:</label>
    <input type="file" name="file" id="file" required><br>
    <label for="name">Nombre:</label>
    <input type="text" name="name" id="name" required><br>
    <label for="institution">Institucion:</label>
    <input type="text" name="institution" id="institution"><br>
    <label for="career">Carrera:</label>
    <input type="text" name="career" id="career"><br>
    <label for="subject">Materia:</label>
    <input type="text" name="subject" id="subject"><br>
    <label for="type">Tipo:</label>
    <input type="text" name="type" id="type"><br>
    <button type="submit">Subir</button>
</form>

<h2>${user.email}</h2>
</body>
</html>