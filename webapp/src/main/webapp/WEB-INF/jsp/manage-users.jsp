<%--suppress HtmlFormInputWithoutLabel --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fragment" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<spring:eval expression="@environment.getProperty('base.url')" var="baseUrl"/>

<!DOCTYPE html>
<html lang="en" data-bs-theme="dark" data-search-view="horizontal">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Apuntea | <spring:message code="manageUsers.title"/></title>
    <link rel="shortcut icon" type="image/x-icon" href="<c:url value="/image/teacher.png"/>">

    <link rel="stylesheet" href="<c:url value="/css/main.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/elements.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/sizes.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/backgrounds.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/autocomplete.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/texts.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/buttons.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/color-picker.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/icons.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/general/boxes.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/sections/navbar.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/sections/search/table-list.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/sections/manage/bar.css"/>"/>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&display=swap" rel="stylesheet">

</head>
<body>

<header>
    <!-- NAVBAR -->
    <fragment:navbar loggedIn="${user != null}" isAdmin="${user.roles[1] ne null}"/>

    <!-- BOTTOM-NAVBAR -->
    <spring:message code="manageUsers.title" var="title"/>
    <fragment:bottom-navbar title="/manage/users:${title}">
    </fragment:bottom-navbar>

</header>

<main>

    <!-- SEARCH -->
    <div class="container my-5">
        <c:url var="searchUrl" value="./"/>
        <form:form modelAttribute="searchForm"
                   action="${searchUrl}"
                   method="get"
                   id="searchForm">
            <div class="row row-cols-1 row-cols-lg-2 justify-content-center" style="margin-left: 50px !important;">


                <div class="col col-lg-5">
                    <div class="col">
                        <div class="input-group mb-3">
                            <spring:message code="username" var="placeholderUsername"/>
                            <form:input path="username" type="text" class="form-control bg-bg"
                                        placeholder="${placeholderUsername}"/>
                        </div>
                    </div>
                </div>

                <div class="col col-lg-5 w-25">
                    <div class="col">
                        <button type="submit" class="btn button-primary w-100"><spring:message
                                code="search.button"/></button>
                    </div>
                </div>

            </div>
        </form:form>
    </div>

    <!-- HORIZONTAL LIST -->
    <section class="container mt-4 p-0" style="max-height: 500px; overflow-y: scroll">
        <div class="table-responsive">
            <table class="table table-hover table-search">
                <thead>
                <tr>
                    <th class="col-md-2"><spring:message code="username"/></th>
                    <th class="col-md-4"><spring:message code="email"/></th>
                    <th class="col-md-3"><spring:message code="roles"/></th>
                    <th class="col-md-1"><spring:message code="status"/></th>
                    <th class="col-md-2"></th> <!-- ACTIONS -->
                </tr>
                </thead>
                <tbody>
                <c:forEach var="item" items="${users}">
                    <tr class="note-found no-select" id="<c:out value="${item.userId}"/>">
                        <td class="note-found-title">
                            <span class="card-title align-middle mx-2 note-name">
                                <c:out value="${item.username}"/>
                            </span>
                        </td>
                        <td><c:out value="${item.email}"/></td>
                        <td>
                            <c:out value="${item.roles[0].shortName}"/>
                            <c:forEach var="role" items="${item.roles}" begin="1">- <c:out value="${role.shortName}"/>
                            </c:forEach>
                        </td>
                        <td>
                            <c:out value="${item.status.status}"/>
                        </td>

                        <td class="search-actions">
                            <div class="d-flex justify-content-end">

                                <c:if test="${item.status.status eq 'Active'}">
                                    <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                         data-bs-title="<spring:message code="banUser"/>" data-bs-trigger="hover">
                                        <button class="btn nav-icon-button ban-button"
                                                data-bs-toggle="modal" data-bs-target="#banUserModal"
                                                id="<c:out value="${item.userId}"/>.b1">
                                            <img src="<c:url value="/svg/user-slash.svg"/>"
                                                 alt="<spring:message code="banUser"/>"
                                                 class="icon-xs fill-text">
                                        </button>
                                    </div>
                                </c:if>
                                <c:if test="${item.status.status eq 'Banned'}">
                                    <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                         data-bs-title="<spring:message code="unbanUser"/>" data-bs-trigger="hover">
                                        <button class="btn nav-icon-button unban-button"
                                                data-bs-toggle="modal" data-bs-target="#unbanUserModal"
                                                id="<c:out value="${item.userId}"/>.u1">
                                            <img src="<c:url value="/svg/user-check.svg"/>"
                                                 alt="<spring:message code="unbanUser"/>"
                                                 class="icon-xs fill-text">
                                        </button>
                                    </div>
                                </c:if>

                            </div>
                        </td>

                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </section>

    <!-- PAGINATION -->
    <section class="container d-flex justify-content-center mt-5">
        <nav aria-label="...">
            <ul class="pagination">
                <c:if test="${searchForm.pageNumber gt 1}">
                    <li class="page-item">
                            <%--suppress XmlDuplicatedId --%>
                        <a class="page-link" id="previousPage"><spring:message code="search.pagination.previous"/></a>
                    </li>
                </c:if>
                <c:if test="${searchForm.pageNumber le 1}">
                    <li class="page-item disabled">
                            <%--suppress XmlDuplicatedId --%>
                        <a class="page-link" id="previousPage"><spring:message code="search.pagination.previous"/></a>
                    </li>
                </c:if>

                <c:if test="${searchForm.pageNumber gt 2}">
                    <li class="page-item">
                        <a class="page-link" data-page="1"><c:out value="1"/></a>
                    </li>
                </c:if>

                <c:if test="${searchForm.pageNumber gt 3}">
                    <li class="page-item disabled">
                        <a class="page-link">...</a>
                    </li>
                </c:if>

                <c:if test="${searchForm.pageNumber gt 1}">
                    <li class="page-item">
                        <a class="page-link" data-page="${searchForm.pageNumber - 1}"><c:out
                                value="${searchForm.pageNumber - 1}"/></a>
                    </li>
                </c:if>

                <li class="page-item active" aria-current="page">
                    <a class="page-link" data-page="${searchForm.pageNumber}"><c:out
                            value="${searchForm.pageNumber}"/></a>
                </li>

                <c:if test="${searchForm.pageNumber lt maxPage}">
                    <li class="page-item">
                        <a class="page-link" data-page="${searchForm.pageNumber + 1}"><c:out
                                value="${searchForm.pageNumber + 1}"/></a>
                    </li>
                </c:if>

                <c:if test="${searchForm.pageNumber lt maxPage - 2}">
                    <li class="page-item disabled">
                        <a class="page-link">...</a>
                    </li>
                </c:if>

                <c:if test="${searchForm.pageNumber lt maxPage - 1}">
                    <li class="page-item">
                        <a class="page-link" data-page="${maxPage}"><c:out value="${maxPage}"/></a>
                    </li>
                </c:if>

                <c:if test="${searchForm.pageNumber lt maxPage}">
                    <li class="page-item">
                            <%--suppress XmlDuplicatedId --%>
                        <a class="page-link" id="nextPage"><spring:message code="search.pagination.next"/></a>
                    </li>
                </c:if>
                <c:if test="${searchForm.pageNumber ge maxPage}">
                    <li class="page-item disabled">
                            <%--suppress XmlDuplicatedId --%>
                        <a class="page-link" id="nextPage"><spring:message code="search.pagination.next"/></a>
                    </li>
                </c:if>
            </ul>
        </nav>
    </section>

    <!-- SIDEBAR -->
    <div class="sidebar">
        <a class="btn nav-icon-button" href="${baseUrl}/manage/careers" data-bs-toggle="tooltip" data-bs-placement="right"
           data-bs-title="<spring:message code="manageCareers.title"/>" data-bs-trigger="hover">
            <img src="<c:url value="/svg/books.svg"/>"
                 alt="<spring:message code="manageUsers.title"/>"
                 class="icon-m fill-dark-primary"/>
        </a>

        <a class="btn nav-icon-button" href="${baseUrl}/manage/users" data-bs-toggle="tooltip" data-bs-placement="right"
           data-bs-title="<spring:message code="manageUsers.title"/>" data-bs-trigger="hover">
            <img src="<c:url value="/svg/user-slash.svg"/>"
                 alt="<spring:message code="manageUsers.title"/>"
                 class="icon-m fill-dark-primary"/>
        </a>
    </div>

</main>

<!-- BAN USER MODAL -->
<c:url var="banUrl" value="${baseUrl}/users/ban"/>
<div class="modal fade" id="banUserModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="banUserLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form id="banUserForm" method="POST" action="${banUrl}"
                       modelAttribute="banUserForm">
                <div class="modal-header">
                    <h3 class="modal-title fs-5" id="banUserLabel"><spring:message code="banUser"/> :
                        <span id="banUserName"></span></h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn rounded-box button-primary"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <input id="banUserButton" type="submit" class="btn rounded-box button-secondary" value="<spring:message
                                                code="banUser"/>"/>
                </div>

                <form:input type="hidden" path="userId" id="banUserId" value=""/>

            </form:form>
        </div>
    </div>
</div>

<!-- UNBAN USER MODAL -->
<c:url var="unbanUrl" value="${baseUrl}/users/unban"/>
<div class="modal fade" id="unbanUserModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="unbanUserLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form id="unbanUserForm" method="POST" action="${unbanUrl}"
                       modelAttribute="unbanUserForm">
                <div class="modal-header">
                    <h3 class="modal-title fs-5" id="unbanUserLabel"><spring:message code="unbanUser"/> :
                        <span id="unbanUserName"></span></h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>

                <div class="modal-footer">
                    <button type="button" class="btn rounded-box button-primary"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <input id="unbanUserButton" type="submit" class="btn rounded-box button-secondary" value="<spring:message
                                                code="unbanUser"/>"/>
                </div>

                <form:input type="hidden" path="userId" id="unbanUserId" value=""/>

            </form:form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
        crossorigin="anonymous"></script>

<script src="<c:url value="/js/darkmode.js"/>"></script>
<c:if test="${not empty users}">
    <script src="<c:url value="/js/pagination.js"/>"></script>
    <script src="<c:url value="/js/ban-unban.js"/>"></script>
</c:if>

</body>
</html>