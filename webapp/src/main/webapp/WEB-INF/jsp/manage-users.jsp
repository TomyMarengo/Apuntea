<%--suppress HtmlFormInputWithoutLabel --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fragment" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<spring:eval expression="@environment.getProperty('base.url')" var="baseUrl"/>

<!DOCTYPE html>
<html lang="en" data-search-view="horizontal">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title>Apuntea | <spring:message code="manageUsers.title"/></title>
    <link rel="shortcut icon" type="image/x-icon" href="<c:url value="/image/apuntea-icon.png"/>">

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
    <link rel="stylesheet" href="<c:url value="/css/sections/bars.css"/>"/>
    <link rel="stylesheet" href="<c:url value="/css/sections/search/table-list.css"/>"/>

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato:wght@400;700;900&display=swap" rel="stylesheet">

</head>
<body>

<header>
    <!-- NAVBAR -->
    <fragment:navbar user="${user}" institutionId="${user.institutionId}" careerId="${user.career.careerId}"/>

    <!-- BOTTOM-NAVBAR -->
    <spring:message code="manageUsers.title" var="title"/>
    <fragment:bottom-navbar title="${baseUrl}/manage/users,${title}">
    </fragment:bottom-navbar>

</header>

<main>
    <fragment:sidebar user="${user}" active="manage-users"/>

    <section class="mt-5">

        <!-- SEARCH -->
        <div class="container my-5">
            <c:url var="searchUrl" value="./users"/>
            <form:form modelAttribute="searchForm"
                       action="${searchUrl}"
                       method="get"
                       id="searchForm">
            <div class="row row-cols-1 row-cols-lg-2 justify-content-center">


                <div class="col col-lg-5">
                    <div class="col">
                        <div class="input-group mb-3">
                            <spring:message code="searchUserForm.query" var="placeholderQuery"/>
                            <form:input path="query" type="text" class="form-control bg-bg"
                                        placeholder="${placeholderQuery}"/>
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

            <form:hidden path="pageNumber" id="pageNumber" value="1"/>

        </div>

        <div class="container d-flex justify-content-between p-0">

            <div class="d-flex align-items-center gap-3">
                <div class="input-group">
                    <label class="input-group-text d-block" for="statusSelect"><spring:message code="status"/></label>
                    <form:select path="status" id="statusSelect" class="form-select bg-bg" onchange="document.getElementById('searchForm').submit();">
                        <!-- For each different year in ownedSubjects -->
                        <form:option value="all"><spring:message code="category.all"/></form:option>
                        <form:option value="active"><spring:message code="user.status.active"/></form:option>
                        <form:option value="banned"><spring:message code="user.status.banned"/></form:option>
                    </form:select>
                </div>

            </div>
        </div>
        </form:form>

        <!-- HORIZONTAL LIST -->
        <section class="container mt-4 p-0">

            <c:if test="${empty users}">
                <div class="d-flex container mt-4 p-0 justify-content-center">
                    <div class="card box p-4">
                        <h5 class="text-center"><spring:message code="searchUserForm.noContent"/></h5>
                    </div>
                </div>
            </c:if>

            <c:if test="${not empty users}">
                <div class="table-responsive">
                    <table class="table table-hover table-search">
                        <thead>
                        <tr>
                            <th class="h-list-username col-lg-2"><spring:message code="username"/></th>
                            <th class="h-list-email col-8 col-md-4"><spring:message code="email"/></th>
                            <th class="h-list-roles col-lg-3"><spring:message code="roles"/></th>
                            <th class="h-list-status col-4 col-md-4 col-lg-3"><spring:message code="status"/></th>
                            <th class="h-list-actions col-4 col-md-4   "></th> <!-- ACTIONS -->
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${users}">
                            <tr class="note-found no-select" id="<c:out value="${item.userId}"/>"
                                ondblclick="window.location = '${baseUrl}/user/${item.userId}/note-board'">
                                <td class="h-list-username">
                                    <span class="card-title align-middle mx-2 note-name">
                                    <c:out value="${item.username}"/>
                                </span>
                                </td>
                                <td class="h-list-email">
                                    <c:out value="${item.email}"/>
                                </td>
                                <td class="h-list-roles">
                                    <c:choose>
                                        <c:when test="${item.roles[0] eq 'ROLE_STUDENT'}">
                                            <spring:message code="role.student"/>
                                        </c:when>
                                        <c:when test="${item.roles[0] eq 'ROLE_MODERATOR'}">
                                            <spring:message code="role.moderator"/>
                                        </c:when>
                                        <c:when test="${item.roles[0] eq 'ROLE_ADMIN'}">
                                            <spring:message code="role.admin"/>
                                        </c:when>
                                    </c:choose>
                                    <c:forEach var="role" items="${item.roles}" begin="1">
                                        - <c:choose>
                                        <c:when test="${role eq 'ROLE_STUDENT'}">
                                            <spring:message code="role.student"/>
                                        </c:when>
                                        <c:when test="${role eq 'ROLE_MODERATOR'}">
                                            <spring:message code="role.moderator"/>
                                        </c:when>
                                        <c:when test="${role eq 'ROLE_ADMIN'}">
                                            <spring:message code="role.admin"/>
                                        </c:when>
                                    </c:choose>
                                    </c:forEach>
                                </td>
                                <td class="h-list-status">
                                    <spring:message code="user.status.${item.status.status}"/>
                                </td>

                                <td class="h-list-actions">
                                    <div class="d-flex justify-content-end">

                                        <c:if test="${item.status.status eq 'active'}">
                                            <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                 data-bs-title="<spring:message code="banUser"/>" data-bs-trigger="hover">
                                                <button class="btn nav-icon-button ban-button"
                                                        data-email="<c:out value="${item.email}"/>"
                                                        data-bs-toggle="modal" data-bs-target="#banUserModal"
                                                        id="<c:out value="${item.userId}"/>.b1">
                                                    <img src="<c:url value="/svg/user-slash.svg"/>"
                                                         alt="<spring:message code="banUser"/>"
                                                         class="icon-xs fill-text">
                                                </button>
                                            </div>
                                        </c:if>
                                        <!-- TODO: Change data-email for data-username or the method to handle all names -->
                                        <!-- TODO: (Change the modal too) -->
                                        <c:if test="${item.status.status eq 'banned'}">
                                            <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                 data-bs-title="<spring:message code="unbanUser"/>" data-bs-trigger="hover">
                                                <button class="btn nav-icon-button unban-button"
                                                        data-email="<c:out value="${item.email}"/>"
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
            </c:if>
        </section>

        <!-- PAGINATION -->
        <c:if test="${maxPage gt 1}">
            <fragment:paging maxPage="${maxPage}" pageNumber="${currentPage}"/>
        </c:if>
    </section>
</main>

<!-- BAN USER MODAL -->
<c:url var="banUrl" value="./users/ban"/>
<div class="modal fade" id="banUserModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="banUserLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form id="banUserForm" method="POST" action="${banUrl}"
                       modelAttribute="banUserForm">
                <div class="modal-header">
                    <h3 class="modal-title fs-5" id="banUserLabel"><spring:message code="banUser"/>:
                        <span id="banUserName"></span></h3>

                    <button type="button" class="btn-close close-modal" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>

                <div class="modal-body pb-0">
                    <spring:message code="ban.confirm"/>

                    <spring:message code="BanUserForm.explain" var="banMessagePlaceholder"/>
                    <label for="reason"></label>
                    <form:textarea name="reason" class="form-control mt-3" id="reason"
                                   placeholder="${banMessagePlaceholder}" path="reason"/>
                    <form:errors cssClass="text-danger" path="reason" element="p"/>
                </div>


                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary close-modal"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <button id="banUserButton" class="btn rounded-box button-primary"><spring:message
                            code="banUser"/></button>
                </div>

                <form:input type="hidden" path="userId" id="banUserId" value=""/>

            </form:form>
        </div>
    </div>
</div>

<!-- UNBAN USER MODAL -->
<c:url var="unbanUrl" value="./users/unban"/>
<div class="modal fade" id="unbanUserModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="unbanUserLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form id="unbanUserForm" method="POST" action="${unbanUrl}"
                       modelAttribute="unbanUserForm">
                <div class="modal-header">
                    <h3 class="modal-title fs-5" id="unbanUserLabel"><spring:message code="unbanUser"/>:
                        <span id="unbanUserName"></span></h3>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>

                <div class="modal-body pb-0">
                    <spring:message code="unban.confirm"/>
                    <form:errors cssClass="text-danger" element="p"/>
                </div>

                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <button id="unbanUserButton" class="btn rounded-box button-primary"><spring:message
                            code="unbanUser"/></button>
                </div>

                <form:input type="hidden" path="userId" id="unbanUserId" value=""/>

            </form:form>
        </div>
    </div>
</div>

<fragment:custom-toast message=""/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
        crossorigin="anonymous"></script>

<script src="<c:url value="/js/popups.js"/>"></script>
<c:if test="${not empty users}">
    <script src="<c:url value="/js/ban-unban.js"/>"></script>
</c:if>


<c:if test="${errorsBanUserForm ne null }">
    <script>
        const id = "<c:out value="${banUserId}"/>";
        const banUserButton = document.getElementById(id + '.b1');
        banUserButton.click();
    </script>
</c:if>

<script>
    <c:if test="${userBanned eq true}">
    displayToast('<spring:message code="toast.userBanned"/>')
    </c:if>
    <c:if test="${userUnbanned eq true}">
    displayToast('<spring:message code="toast.userUnbanned"/>')
    </c:if>
</script>

</body>
</html>
