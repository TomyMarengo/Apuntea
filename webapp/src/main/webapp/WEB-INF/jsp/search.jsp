<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="fragment" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>

<!DOCTYPE html>
<html lang="en" data-bs-theme="dark">

<head>
    <meta charset="utf-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <title>Apuntea | <spring:message code="search.title"/></title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-4bw+/aepP/YC94hEpVNVgiZdgIC5+VKNBQNGCHeKRQN+PtmoHDEXuppvnDJzQIu9" crossorigin="anonymous">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm" crossorigin="anonymous"></script>

    <link rel="stylesheet" href="/css/main.css" />
    <link rel="stylesheet" href="/css/general/elements.css" />
    <link rel="stylesheet" href="/css/general/sizes.css" />
    <link rel="stylesheet" href="/css/general/backgrounds.css" />
    <link rel="stylesheet" href="/css/general/texts.css" />
    <link rel="stylesheet" href="/css/general/buttons.css" />
    <link rel="stylesheet" href="/css/general/icons.css" />
    <link rel="stylesheet" href="/css/general/boxes.css" />
    <link rel="stylesheet" href="/css/sections/navbar.css" />

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&display=swap" rel="stylesheet">

</head>
<body>

    <!-- NAVBAR -->
    <fragment:navbar/>

    <!-- BOTTOM-NAVBAR -->
    <fragment:bottom-navbar title="notes/search:Búsqueda" extraLinks="">
    </fragment:bottom-navbar>


    <!-- SEARCH -->
    <div class="container d-flex flex-column w-100">
        <form class="">
            <div class="row row-cols-1 row-cols-md-3 row-cols-lg-6 ">
                <div class="col">
                    <div class="input-group mb-3">
                        <span class="input-group-text"><img src="/svg/school.svg" alt="<spring:message code="search.institution.placeholder"/>" class="icon-s fill-text" /></span>
                        <input type="text" class="form-control bg-bg" placeholder="<spring:message code="search.institution.placeholder"/>">
                    </div>
                </div>

                <div class="col">
                    <div class="input-group mb-3">
                        <span class="input-group-text"><img src="/svg/books.svg" alt="<spring:message code="search.career.placeholder"/>" class="icon-s fill-text" /></span>
                        <input type="text" class="form-control bg-bg" placeholder="<spring:message code="search.career.placeholder"/>">
                    </div>
                </div>

                <div class="col">
                    <div class="input-group mb-3">
                        <span class="input-group-text"><img src="/svg/book-alt.svg" alt="<spring:message code="search.subject.placeholder"/>" class="icon-s fill-text" /></span>
                        <input type="text" class="form-control bg-bg" placeholder="<spring:message code="search.subject.placeholder"/>">
                    </div>
                </div>

                <div class="col">
                    <div class="input-group mb-3">
                        <select class="form-select bg-bg" id="inputGroupSelectType">
                            <option selected><spring:message code="search.category.placeholder"/></option>
                            <option value="1"><spring:message code="search.category.exam"/></option>
                            <option value="2"><spring:message code="search.category.practical"/></option>
                            <option value="3"><spring:message code="search.category.theoretical"/></option>
                        </select>
                    </div>
                </div>

                <div class="col">
                    <div class="input-group mb-3">
                        <select class="form-select bg-bg" id="inputGroupSelectRating">
                            <option selected><spring:message code="search.score.placeholder"/></option>
                            <option value="5">> ⭐⭐⭐⭐⭐</option>
                            <option value="4">> ⭐⭐⭐⭐</option>
                            <option value="3">> ⭐⭐⭐</option>
                            <option value="2">> ⭐⭐</option>
                            <option value="1">> ⭐</option>
                        </select>
                    </div>
                </div>

                <div class="col">
                    <div class="input-group mb-3">
                        <select class="form-select bg-bg" id="inputGroupSelectOrder">
                            <option selected><spring:message code="search.sort.placeholder"/></option>
                            <option value="1"><spring:message code="search.sort.name"/> (<spring:message code="search.sort.ascending"/>)</option>
                            <option value="2"><spring:message code="search.sort.name"/> (<spring:message code="search.sort.descending"/>)</option>
                            <option value="3"><spring:message code="search.sort.score"/> (<spring:message code="search.sort.ascending"/>)</option>
                            <option value="4"><spring:message code="search.sort.score"/> (<spring:message code="search.sort.descending"/>)</option>
                        </select>
                    </div>
                </div>

            </div>

            <button type="submit" class="btn button-primary w-100 "><spring:message code="search.button"/></button>
        </form>
    </div>

    <!-- TODO: NOTES FOUND -->


    <script src="/js/scripts.js"></script>
</body>

</html>