<%--suppress HtmlUnknownTarget --%>
<%--suppress JspAbsolutePathInspection --%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ tag pageEncoding="UTF-8" %>
<spring:eval expression="@environment.getProperty('base.url')" var="baseUrl"/>
<spring:message var="profile" code="profile.title"/>
<spring:message var="search" code="search.title"/>
<spring:message var="notifications" code="notifications"/>
<spring:message var="darkMode" code="darkMode"/>
<spring:message var="manage" code="manage"/>
<%@ attribute name="user" required="false" type="ar.edu.itba.paw.models.user.User" %>
<c:set var="loggedIn" value="${user ne null}"/>
<c:set var="isAdmin" value="${user.roles[1] ne null}"/>

<nav class="navbar">
    <div class="container-fluid d-flex align-items-center">
        <a class="navbar-brand text-dark-primary" href="${baseUrl}">Apuntea</a>
        <div class="d-flex justify-content-center align-items-center mx-1">

            <div class="search-container">
                <button class="btn nav-icon-button search-icon" type="button" id="searchNavButton">
                    <img src="<c:url value="/svg/search.svg"/>" alt="${search}" class="icon-s fill-dark-primary"/>
                </button>
                <input id="searchNavInput" type="text" class="search-input"
                       placeholder="<spring:message code="search.word.placeholder"/>"/>
            </div>

            <button id="darkModeToggle" class="btn nav-icon-button" type="button">
                <img id="darkModeIcon" src="<c:url value="/svg/sun.svg"/>" alt="${darkMode}"
                     class="icon-s fill-dark-primary"/>
            </button>

            <c:if test="${isAdmin eq true}">
                <a href="${baseUrl}/manage/careers" class="btn nav-icon-button">
                    <img src="<c:url value="/svg/gears.svg"/>" alt="${manage}"
                         class="icon-s fill-dark-primary"/>
                </a>
            </c:if>

            <c:if test="${loggedIn}">
                <div class="btn-group mx-2">
                    <div class="p-2 my-1 d-flex flex-row align-items-center justify-content-center dropdown-container" data-bs-toggle="dropdown" aria-expanded="false">
                        <img src="<c:url value="/svg/user.svg"/>" alt="${profile}" class="icon-s fill-dark-primary mx-1 dropdown-icon"/>
                        <img src="<c:url value="/svg/chevron-down.svg"/>" alt="${profile}" class="icon-xs fill-dark-primary mx-1 dropdown-icon"/>
                    </div>
                        <ul class="dropdown-menu dropdown-menu-end">
                            <li>
                                <div class="d-flex flex-column dropdown-item disabled my-2">
                                    <span class="logged-in"><spring:message code="navbar.loggedIn"/></span>
                                    <strong><c:out value="${user.displayName}"/></strong>
                                </div>
                            </li>
                            <hr class="p-0">
                            <li><a class="dropdown-item" href="${baseUrl}/profile"><spring:message
                                    code="myProfile.title"/></a></li>
                            <li><a class="dropdown-item" href="${baseUrl}/profile/notes"><spring:message
                                    code="myProfileNotes.title"/></a></li>
                            <li><a class="dropdown-item" href="${baseUrl}/change-password"><spring:message
                                    code="changePassword.title"/></a></li>
                            <hr class="p-0">
                            <li><a class="dropdown-item my-2" href="${baseUrl}/logout"><spring:message
                                    code="logout"/></a></li>
                        </ul>
                </div>
            </c:if>

            <c:if test="${!loggedIn}">
                <a href="${baseUrl}/login" class="btn rounded-box button-primary mx-2">
                    <spring:message code="login"/>
                </a>
                <a href="${baseUrl}/register" class="btn login-register-button box">
                    <spring:message code="register"/>
                </a>
            </c:if>
        </div>
    </div>
</nav>

<script src="<c:url value="/js/global-search.js"/>"></script>
<script src="<c:url value="/js/darkmode.js"/>"></script>