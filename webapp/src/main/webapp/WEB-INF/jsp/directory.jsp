<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="fragment" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<spring:eval expression="@environment.getProperty('base.url')" var="baseUrl"/>

<c:set var="colors" value="${fn:split('BBBBBB,16A765,4986E7,CD35A6', ',')}"/> <!-- TODO: ADD MORE COLORS -->

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <title> Apuntea | <c:out value="${directory.name}"/></title>
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
    <fragment:navbar user="${user}" institutionId="${user.institutionId}" careerId="${user.career.careerId}"/>

    <fragment:bottom-navbar
            title="${baseUrl}/directory/${directoryId},${directory.name}"
            hierarchy="${hierarchy}"
            category="directory"
            directory="${directory}"
            user="${user}"
            owner="${filterUser}"
    />
</header>

<c:url var="createUrl" value="./${directoryId}"/>
<c:url var="searchUrl" value="./${directoryId}"/>


<main>
    <fragment:sidebar user="${user}"/>
    <!-- SEARCH -->
    <section>
        <form:form modelAttribute="navigationForm"
                   action="${searchUrl}"
                   method="get"
                   id="searchForm"
                   cssClass="d-flex flex-column gap-2 mt-5">

            <div class="container my-5 d-flex flex-column align-items-center">
                <div class="w-50 input-group mb-3">
                    <spring:message code="search.word.placeholder" var="placeholderSearch"/>
                    <form:input path="word" type="text" class="form-control bg-bg" placeholder='${placeholderSearch}'/>
                </div>

                <!-- TODO: Maybe move and add profile info? -->
                <c:if test="${filterUser ne null}">
                    <form:hidden path="userId" id="userId" value="${filterUser.userId}"/>
                </c:if>
                <div class="w-50 d-flex flex-column justify-content-center align-items-center">
                    <button type="submit" class="btn button-primary w-50"><spring:message
                            code="search.button"/></button>
                    <c:if test="${filterUser ne null}">
                        <a class="btn text-dark-primary"
                           href="./${directory.id}?userId=${filterUser.userId}"><spring:message
                                code="search.button.clearAllFilters"/></a>
                    </c:if>
                    <c:if test="${filterUser eq null}">
                        <a class="btn text-dark-primary" href="./${directory.id}"><spring:message
                                code="search.button.clearAllFilters"/></a>
                    </c:if>
                </div>
            </div>

            <form:hidden path="pageNumber" id="pageNumber" value="1"/>

            <div class="container d-flex flex-wrap justify-content-between p-0 gap-3">
                <!-- SEARCH PILL -->
                <div class="d-flex align-items-center gap-3">
                    <div class="search-pill">
                        <button type="button" id="selectOnlyFoldersButton">
                            <img src="<c:url value="/svg/folder.svg"/>" alt="<spring:message code="folder"/>"
                                 class="icon-s fill-bg"/>
                            <spring:message code="folders"/>
                        </button>

                        <button type="button" id="selectAllCategoriesButton">
                            <spring:message code="category.all"/>
                        </button>

                        <button type="button" id="selectOnlyFilesButton">
                            <spring:message code="files"/>
                            <img src="<c:url value="/svg/file.svg"/>" alt="<spring:message code="folder"/>"
                                 class="icon-s fill-bg"/>
                        </button>
                    </div>

                    <div class="input-group min-w-350">
                        <button class="input-group-text input-group-icon" id="ascDescButton">
                            <form:checkbox path="ascending" id="ascCheckbox" cssClass="d-none"/>
                            <c:if test="${navigationForm.ascending}">
                                <img src="<c:url value="/svg/arrow-up.svg"/>"
                                     alt="<spring:message code="search.sort.image"/>"
                                     class="icon-s fill-dark-primary"
                                     id="arrowImage" title="ascending"/>
                            </c:if>
                            <c:if test="${!navigationForm.ascending}">
                                <img src="<c:url value="/svg/arrow-down.svg"/>"
                                     alt="<spring:message code="search.sort.image"/>"
                                     class="icon-s fill-dark-primary"
                                     id="arrowImage" title="descending"/>
                            </c:if>
                        </button>

                        <form:select path="sortBy" class="form-select bg-bg" id="sortBySelect"
                                     onchange="submitSearchForm()">
                            <form:option value="modified"><spring:message
                                    code="search.sort.lastModifiedAt"/></form:option>
                            <form:option value="date"><spring:message code="search.sort.createdAt"/></form:option>
                            <c:if test="${navigationForm.isNote}">
                                <form:option value="score"><spring:message code="search.sort.score"/></form:option>
                            </c:if>
                            <form:option value="name"><spring:message code="search.sort.name"/></form:option>
                        </form:select>
                    </div>

                    <div class="input-group mw-600" id="categorySelectContainer">
                        <c:if test="${navigationForm.category ne 'all' and navigationForm.category ne 'directory'}">
                            <div class="input-group">
                                <form:select path="category" class="form-select bg-bg" id="categorySelect"
                                             onchange="submitSearchForm()">
                                    <form:option
                                            value="note"><spring:message
                                            code="search.category.all"/></form:option>
                                    <form:option
                                            value="theory"><spring:message
                                            code="search.category.theory"/></form:option>
                                    <form:option
                                            value="practice"><spring:message
                                            code="search.category.practice"/></form:option>
                                    <form:option
                                            value="exam"><spring:message
                                            code="search.category.exam"/></form:option>
                                    <form:option
                                            value="other"><spring:message
                                            code="search.category.other"/></form:option>
                                    <form:option cssClass="d-none"
                                                 value="directory"/>
                                    <form:option cssClass="d-none"
                                                 value="all"/>
                                </form:select>
                            </div>
                        </c:if>
                        <c:if test="${navigationForm.category eq 'all' or navigationForm.category eq 'directory'}">
                            <form:hidden path="category" cssClass="form-select bg-bg d-none" id="categorySelect"/>
                        </c:if>
                    </div>
                </div>

                <!-- BUTTONS -->
                <c:if test="${not empty results}">
                    <!-- DEFINES -->
                    <spring:message code="download" var="download"/>
                    <spring:message code="folder" var="folder"/>
                    <spring:message code="search.toggleView" var="searchViewImage"/>
                    <c:url value="/svg/box-list.svg" var="boxViewUrl"/>
                    <c:url value="/svg/horizontal-list.svg" var="horizontalViewUrl"/>

                    <div class="d-flex">
                        <div id="selectedButtons" class="align-items-center" style="display: none;">
                            <button type="button" id="deselectAllButton" class="btn nav-icon-button"
                                    data-bs-toggle="tooltip"
                                    data-bs-placement="bottom"
                                    data-bs-title="<spring:message code="search.button.deselectAll"/>"
                                    data-bs-trigger="hover">
                                <img src="<c:url value="/svg/cross.svg"/>" alt="deselect"
                                     class="icon-s fill-dark-primary"/>
                            </button>
                            <span class="text-dark-primary d-flex flex-row">
                                <strong id="selectedCount" class="text-dark-primary mx-1"> 0 </strong>
                                    <spring:message code="search.selected"/>
                            </span>

                            <c:if test="${user ne null and directory.user ne null and (directory.user.userId eq user.userId or directory.user.isAdmin)}">
                                <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                     data-bs-title="<spring:message code="delete"/>" data-bs-trigger="hover">
                                    <button type="button" id="openDeleteSelectedModalButton" class="btn nav-icon-button"
                                            data-bs-toggle="modal" data-bs-target="#deleteManyModal">
                                        <img src="<c:url value="/svg/trash.svg"/>"
                                             alt="<spring:message code="delete"/>"
                                             class="icon-s fill-dark-primary">
                                    </button>
                                </div>
                            </c:if>

                            <button type="button" id="downloadSelectedButton" class="btn nav-icon-button"
                                    data-bs-toggle="tooltip"
                                    data-bs-placement="bottom" data-bs-title="<spring:message code="download"/>"
                                    data-bs-trigger="hover">
                                <img src="<c:url value="/svg/download.svg"/>" alt="download"
                                     class="icon-s fill-dark-primary"/>
                            </button>
                        </div>

                        <button type="button" id="selectAllButton" class="btn nav-icon-button" data-bs-toggle="tooltip"
                                data-bs-placement="bottom"
                                data-bs-title="<spring:message code="search.button.selectAll"/>"
                                data-bs-trigger="hover">
                            <img src="<c:url value="/svg/list-check.svg"/>" alt="select all"
                                 class="icon-s fill-dark-primary"/>
                        </button>

                        <button type="button" id="searchViewToggle" class="btn nav-icon-button" data-bs-toggle="tooltip"
                                data-bs-placement="bottom"
                                data-bs-title="<spring:message code="search.button.listView"/>"
                                data-horizontal="<spring:message code="search.button.listView"/>"
                                data-box="<spring:message code="search.button.boxView"/>" data-bs-trigger="hover">
                            <img id="searchViewIcon" src="${horizontalViewUrl}" alt="${searchViewImage}"
                                 class="icon-s fill-dark-primary"/>
                        </button>

                        <c:if test="${user ne null and (filterUser eq null or user eq filterUser) and (directory.user eq null or directory.user.userId eq user.userId)}">
                            <a href="#" data-bs-toggle="tooltip" data-bs-placement="bottom"
                               data-bs-title="<spring:message code="uploadNote"/>"
                               data-bs-trigger="hover">
                                <button type="button" class="btn nav-icon-button" data-bs-toggle="modal"
                                        data-bs-target="#createNoteModal"
                                        id="createNoteModalButton">
                                    <img src="<c:url value="/svg/add-document.svg"/>"
                                         alt="<spring:message code="uploadNote"/>"
                                         class="icon-m fill-dark-primary"/>
                                </button>
                            </a>
                            <a href="#" data-bs-toggle="tooltip" data-bs-placement="bottom"
                               data-bs-title="<spring:message code="createDirectory"/>"
                               data-bs-trigger="hover">
                                <button type="button" class="btn nav-icon-button" data-bs-toggle="modal"
                                        data-bs-target="#createDirectoryModal"
                                        id="createDirectoryModalButton">
                                    <img src="<c:url value="/svg/add-folder.svg"/>"
                                         alt="<spring:message code="createDirectory"/>"
                                         class="icon-m fill-dark-primary"/>
                                </button>
                            </a>
                        </c:if>

                        <div data-bs-toggle="tooltip" data-bs-placement="right"
                             data-bs-title="<spring:message code="search.button.pageSize"/>"
                             data-bs-trigger="hover">
                            <form:select path="pageSize" class="form-select bg-bg" onchange="submitSearchForm()">
                                <form:option value="12">12</form:option>
                                <form:option value="18">18</form:option>
                                <form:option value="24">24</form:option>
                                <c:if test="${navigationForm.pageSize ne 12 and navigationForm.pageSize ne 18 and navigationForm.pageSize ne 24}">
                                    <form:option value="${navigationForm.pageSize}"><c:out
                                            value="${navigationForm.pageSize}"/></form:option>
                                </c:if>
                            </form:select>
                        </div>
                    </div>
                </c:if>
            </div>
        </form:form>

        <c:if test="${empty results}">
            <article class="container text-center mt-4 d-flex flex-column align-items-center gap-2">
                <div class="d-flex align-middle gap-2 justify-content-center">
                    <img src="<c:url value="/image/no-task.png"/>" alt="Empty Folder" class="icon-xl"/>
                    <h3><spring:message code="directories.noContent"/></h3>
                </div>
                <c:if test="${user ne null and (filterUser eq null or user eq filterUser) and (directory.user eq null or directory.user.userId eq user.userId)}">
                    <p class="text-muted"><spring:message code="directories.noContent.description"/></p>
                    <div class="d-flex gap-2">
                        <a href="#" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           data-bs-title="<spring:message code="uploadNote"/>"
                           data-bs-trigger="hover">
                            <button class="btn nav-icon-button" data-bs-toggle="modal" data-bs-target="#createNoteModal"
                                    id="createNoteModalButton">
                                <img src="<c:url value="/svg/add-document.svg"/>"
                                     alt="<spring:message code="uploadNote"/>"
                                     class="icon-m fill-dark-primary"/>
                            </button>
                        </a>

                        <a href="#" data-bs-toggle="tooltip" data-bs-placement="bottom"
                           data-bs-title="<spring:message code="createDirectory"/>"
                           data-bs-trigger="hover">
                            <button class="btn nav-icon-button" data-bs-toggle="modal"
                                    data-bs-target="#createDirectoryModal"
                                    id="createDirectoryModalButton">
                                <img src="<c:url value="/svg/add-folder.svg"/>"
                                     alt="<spring:message code="createDirectory"/>"
                                     class="icon-m fill-dark-primary"/>
                            </button>
                        </a>
                    </div>
                </c:if>
            </article>
        </c:if>

        <!-- LIST OF NOTES MATCHING -->
        <c:if test="${not empty results}">
            <c:set var="folders" value=""/>
            <c:set var="files" value=""/>

            <!-- HORIZONTAL LIST -->
            <article class="container mt-4 p-0" id="horizontalList">
                <div class="table-responsive">
                    <table class="table table-hover table-search">
                        <thead>
                        <tr>
                            <th class="h-list-name col-9 col-md-9 col-lg-4"><spring:message code="name"/></th>
                            <th class="h-list-owner col-lg-3"><spring:message code="owner"/></th>

                            <!-- To sum 12 cols -->
                            <c:if test="${navigationForm.category eq 'all' or navigationForm.category eq 'directory'}">
                                <c:if test="${navigationForm.sortBy eq 'date'}">
                                    <th class="h-list-modified col-lg-2"><spring:message code="createdAt"/></th>
                                </c:if>
                                <c:if test="${navigationForm.sortBy ne 'date'}">
                                    <th class="h-list-modified col-lg-2"><spring:message code="lastModifiedAt"/></th>
                                </c:if>
                            </c:if>
                            <c:if test="${navigationForm.category ne 'all' and navigationForm.category ne 'directory'}">
                                <c:if test="${navigationForm.sortBy eq 'date'}">
                                    <th class="h-list-modified col-lg-1"><spring:message code="createdAt"/></th>
                                </c:if>
                                <c:if test="${navigationForm.sortBy ne 'date'}">
                                    <th class="h-list-modified col-lg-1"><spring:message code="lastModifiedAt"/></th>
                                </c:if>
                            </c:if>
                            <!--- --->

                            <c:if test="${navigationForm.category ne 'all' and navigationForm.category ne 'directory'}">
                                <th class="h-list-score col-lg-1"><spring:message code="score"/></th>
                            </c:if>

                            <th class="h-list-actions col-3 col-lg-3"></th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="item" items="${results}">

                            <!-- SAVE FOR BOX LIST -->
                            <c:if test="${item.category.formattedName eq 'directory'}">
                                <c:set var="folders" value="${folders}${item.id},"/>
                            </c:if>
                            <c:if test="${item.category.formattedName ne 'directory'}">
                                <c:set var="files" value="${files}${item.id},"/>
                            </c:if>

                            <c:set var="date" value="${item.lastModifiedAt}"/>
                            <c:if test="${navigationForm.sortBy eq 'date'}">
                                <c:set var="date" value="${item.createdAt}"/>
                            </c:if>

                            <tr class="note-found no-select"
                                data-category="<c:out value="${item.category.formattedName}"/>"
                                data-visible="${item.visible}"
                                id="<c:out value="${item.id}"/>.1">
                                <td class="h-list-name">
                                    <c:if test="${item.category.formattedName ne 'directory'}">
                                        <c:if test="${item.fileType eq 'pdf'}">
                                            <img src="<c:url value="/image/pdf.png"/>" alt="pdf" class="icon-m">
                                        </c:if>
                                        <c:if test="${item.fileType eq 'jpeg'}">
                                            <img src="<c:url value="/image/jpeg.png"/>" alt="jpeg" class="icon-m">
                                        </c:if>
                                        <c:if test="${item.fileType eq 'jpg'}">
                                            <img src="<c:url value="/image/jpg.png"/>" alt="jpg" class="icon-m">
                                        </c:if>
                                        <c:if test="${item.fileType eq 'png'}">
                                            <img src="<c:url value="/image/png.png"/>" alt="png" class="icon-m">
                                        </c:if>
                                        <c:if test="${item.fileType eq 'mp3'}">
                                            <img src="<c:url value="/image/mp3.png"/>" alt="mp3" class="icon-m">
                                        </c:if>
                                        <c:if test="${item.fileType eq 'mp4'}">
                                            <img src="<c:url value="/image/mp4.png"/>" alt="mp4" class="icon-m">
                                        </c:if>
                                    </c:if>
                                    <c:if test="${item.category.formattedName eq 'directory'}">
                                        <img src="<c:url value="/svg/folder.svg"/>" alt="${folder}"
                                             data-color="${item.iconColor}"
                                             class="icon-m fill-${item.iconColor} folder-icon">
                                    </c:if>
                                    <span class="card-title align-middle mx-2 note-name">
                                <c:out value="${item.name}"/>
                            </span>
                                </td>
                                <td class="h-list-owner"><a class="link-info"
                                                            href="${baseUrl}/user/${item.user.userId}/note-board"><c:out
                                        value="${item.user.displayName}"/></a></td>
                                <td class="h-list-modified"><spring:message code="date.format"
                                                                            arguments="${date.year},${date.monthValue},${date.dayOfMonth}"/></td>

                                <c:if test="${navigationForm.category ne 'all' and navigationForm.category ne 'directory'}">
                                    <td class="h-list-score">
                                        <c:if test="${item.avgScore eq 0}">
                                            <spring:message code="notes.noScore"/>
                                        </c:if>
                                        <c:if test="${item.avgScore ne 0}">
                                            <fmt:formatNumber type="number" maxFractionDigits="1"
                                                              value="${item.avgScore}"/>
                                        </c:if>
                                    </td>
                                </c:if>


                                <td class="h-list-actions">
                                    <div class="d-flex justify-content-end">
                                        <!-- Favorite -->
                                        <c:if test="${user ne null}">
                                            <c:if test="${item.category.type eq 'directory'}">
                                                <c:set var="addFavorite" value="./${item.id}/addfavorite"/>
                                                <c:set var="removeFavorite" value="./${item.id}/removefavorite"/>
                                            </c:if>
                                            <c:if test="${item.category.type ne 'directory'}">
                                                <c:set var="addFavorite" value="../notes/${item.id}/addfavorite"/>
                                                <c:set var="removeFavorite" value="../notes/${item.id}/removefavorite"/>
                                            </c:if>

                                            <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                 data-bs-title="<spring:message code="favorite"/>"
                                                 data-bs-trigger="hover">
                                                <form:form action="${item.favorite ? removeFavorite : addFavorite}"
                                                           method="post">
                                                    <input name="redirectUrl"
                                                           value="/directory/${item.parentId}?${requestScope['javax.servlet.forward.query_string']}"
                                                           type="hidden"/>
                                                    <button type="submit" onclick="event.stopPropagation();"
                                                            class="btn nav-icon-button"
                                                            data-bs-toggle="tooltip"
                                                            data-bs-placement="bottom"
                                                            data-bs-title="<spring:message code="favorite"/>"
                                                            id="<c:out value="${item.id}"/>.f1">
                                                        <img src="<c:url value="${ item.favorite ?  '/svg/filled-heart.svg' : '/svg/heart.svg'}"/>"
                                                             alt="<spring:message code="favorite"/>"
                                                             class="icon-xs fill-text">
                                                    </button>
                                                </form:form>
                                            </div>
                                        </c:if>

                                        <c:if test="${user ne null and item.user.userId eq user.userId}">
                                            <c:if test="${item.category.formattedName ne 'directory'}">
                                                <!-- EDIT -->
                                                <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                     data-bs-title="<spring:message code="edit"/>"
                                                     data-bs-trigger="hover">
                                                    <button class="btn nav-icon-button edit-button"
                                                            data-bs-toggle="modal" data-bs-target="#editNoteModal"
                                                            id="<c:out value="${item.id}"/>.e1">
                                                        <img src="<c:url value="/svg/pencil.svg"/>"
                                                             alt="<spring:message code="edit"/>"
                                                             class="icon-xs fill-text">
                                                    </button>
                                                </div>
                                            </c:if>
                                            <c:if test="${item.category.formattedName eq 'directory'}">
                                                <!-- EDIT -->
                                                <div href="#" data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                     data-bs-title="<spring:message code="edit"/>"
                                                     data-bs-trigger="hover">
                                                    <button class="btn nav-icon-button edit-button"
                                                            data-bs-toggle="modal" data-bs-target="#editDirectoryModal"
                                                            id="<c:out value="${item.id}"/>.e1">
                                                        <img src="<c:url value="/svg/pencil.svg"/>"
                                                             alt="<spring:message code="edit"/>"
                                                             class="icon-xs fill-text">
                                                    </button>
                                                </div>
                                            </c:if>
                                        </c:if>

                                        <c:if test="${item.category.formattedName ne 'directory'}"> <!-- FOLDERS CANNOT BE DOWNLOADED -->
                                            <a href="../notes/${item.id}/download" download="${item.name}">
                                                <button type="button" class="btn nav-icon-button"
                                                        data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                        data-bs-title="<spring:message code="download"/>"
                                                        data-bs-trigger="hover">
                                                    <img src="<c:url value="/svg/download.svg"/>" alt="${download}"
                                                         class="icon-xs fill-text">
                                                </button>
                                            </a>
                                        </c:if>

                                        <!-- ALL CAN BE COPIED -->
                                        <div>
                                            <button class="btn nav-icon-button copy-button"
                                                    id="<c:out value="${item.id}"/>.c1"
                                                    data-category=""
                                                    data-bs-toggle="tooltip"
                                                    data-bs-placement="bottom"
                                                    data-bs-title="<spring:message code="copyLink"/>"
                                                    data-bs-trigger="hover">
                                                <img src="<c:url value="/svg/link.svg"/>"
                                                     alt="<spring:message code="copyLink"/>"
                                                     class="icon-xs fill-text">
                                            </button>
                                        </div>

                                        <!-- DELETE -->
                                        <c:if test="${user ne null and (item.user.userId eq user.userId or user.isAdmin)}">
                                            <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                 data-bs-title="<spring:message code="delete"/>"
                                                 data-bs-trigger="hover">
                                                <button class="btn nav-icon-button delete-button"
                                                        data-bs-toggle="modal" data-bs-target="#deleteManyModal"
                                                        id="<c:out value="${item.id}"/>.d1">
                                                    <img src="<c:url value="/svg/trash.svg"/>"
                                                         alt="<spring:message code="delete"/>"
                                                         class="icon-xs fill-text">
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                    <input type="checkbox" class="select-checkbox d-none"/>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </article>

            <!-- BOX LIST -->
            <article class="container mt-4 p-0" id="boxList">

                <!-- FOLDERS -->
                <c:if test="${folders ne ''}">
                    <h5 class="mx-1 mb-3"><strong><spring:message code="folders"/></strong></h5>
                    <div class="row">
                        <c:forEach items="${results}" var="item">
                            <c:if test="${item.category.formattedName eq 'directory'}">
                                <div class="col-md-4 mb-4">
                                    <div class="note-found card box search-note-box h-100"
                                         data-category="${item.category.formattedName}"
                                         id="<c:out value="${item.id}"/>.2">
                                        <div class="card-body no-select">

                                            <!-- TITLE AND BUTTONS -->
                                            <div class="d-flex justify-content-between">
                                                <div class="d-flex gap-2 overflow-hidden align-items-center mb-2">
                                                    <img src="<c:url value="/svg/folder.svg"/>" alt="${folder}"
                                                         data-color="${item.iconColor}"
                                                         class="icon-s fill-${item.iconColor} folder-icon">
                                                    <h4 class="card-title text-truncate mb-0 note-name">
                                                        <c:out value="${item.name}"/>
                                                    </h4>
                                                </div>

                                                <div class="d-flex">
                                                    <c:if test="${user ne null}">
                                                        <!-- FAVORITE -->
                                                        <c:set var="addFavorite" value="./${item.id}/addfavorite"/>
                                                        <c:set var="removeFavorite"
                                                               value="./${item.id}/removefavorite"/>

                                                        <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                             data-bs-title="<spring:message code="favorite"/>"
                                                             data-bs-trigger="hover">
                                                            <form:form
                                                                    action="${item.favorite ? removeFavorite : addFavorite}"
                                                                    method="post">
                                                                <input name="redirectUrl"
                                                                       value="/directory/${item.parentId}?${requestScope['javax.servlet.forward.query_string']}"
                                                                       type="hidden"/>
                                                                <button type="submit" onclick="event.stopPropagation();"
                                                                        class="btn nav-icon-button"
                                                                        data-bs-toggle="tooltip"
                                                                        data-bs-placement="bottom"
                                                                        data-bs-title="<spring:message code="favorite"/>"
                                                                        id="<c:out value="${item.id}"/>.f1">
                                                                    <img src="<c:url value="${ item.favorite ?  '/svg/filled-heart.svg' : '/svg/heart.svg'}"/>"
                                                                         alt="<spring:message code="favorite"/>"
                                                                         class="icon-xs fill-text">
                                                                </button>
                                                            </form:form>
                                                        </div>
                                                    </c:if>

                                                    <c:if test="${user ne null and (item.user.userId eq user.userId) }">
                                                        <a data-bs-toggle="tooltip" data-bs-placement="bottom" href="#"
                                                           data-bs-title="<spring:message code="edit"/>"
                                                           data-bs-trigger="hover">
                                                            <button class="btn nav-icon-button edit-button"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#editDirectoryModal"
                                                                    id="<c:out value="${item.id}.e2"/>">
                                                                <img src="<c:url value="/svg/pencil.svg"/>"
                                                                     alt="<spring:message code="edit"/>"
                                                                     class="icon-xs fill-text">
                                                            </button>
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${user ne null and (item.user.userId eq user.userId or user.isAdmin) }">
                                                        <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                             data-bs-title="<spring:message code="delete"/>"
                                                             data-bs-trigger="hover">
                                                            <button class="btn nav-icon-button delete-button"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#deleteManyModal"
                                                                    id="<c:out value="${item.id}"/>.e2">
                                                                <img src="<c:url value="/svg/trash.svg"/>"
                                                                     alt="<spring:message code="delete"/>"
                                                                     class="icon-xs fill-text">
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <span class="card-text">
                                        <strong><spring:message code="owner"/></strong>:
                                        <a href="${baseUrl}/user/${item.user.userId}/note-board"><c:out
                                                value="${item.user.displayName}"/></a>
                                    </span>

                                            <br>

                                            <span class="card-text">
                                        <c:if test="${navigationForm.sortBy eq 'date'}">
                                            <strong><spring:message code="createdAt"/></strong>:
                                        </c:if>
                                                <c:if test="${navigationForm.sortBy ne 'date'}">
                                                    <strong><spring:message code="lastModifiedAt"/></strong>:
                                                </c:if>
                                        <spring:message code="date.format"
                                                        arguments="${date.year},${date.monthValue},${date.dayOfMonth}"/>
                                    </span>

                                            <input type="checkbox" class="select-checkbox d-none"/>

                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>

                <!-- FILES -->
                <c:if test="${files ne ''}">
                    <h5 class="mx-1 mb-3"><strong><spring:message code="files"/></strong></h5>
                    <div class="row">
                        <c:forEach items="${results}" var="item">
                            <c:if test="${item.category.formattedName ne 'directory'}">
                                <div class="col-md-4 mb-4">
                                    <div class="note-found card box search-note-box h-100"
                                         data-category="${item.category.formattedName}"
                                         id="<c:out value="${item.id}"/>.2">
                                        <div class="card-body no-select">

                                            <!-- TITLE AND BUTTONS -->
                                            <div class="d-flex justify-content-between">
                                                <div class="d-flex gap-2 overflow-hidden align-items-center mb-2">
                                                    <c:if test="${item.fileType eq 'pdf'}">
                                                        <img src="<c:url value="/image/pdf.png"/>" alt="pdf"
                                                             class="icon-m">
                                                    </c:if>
                                                    <c:if test="${item.fileType eq 'jpeg'}">
                                                        <img src="<c:url value="/image/jpeg.png"/>" alt="jpeg"
                                                             class="icon-m">
                                                    </c:if>
                                                    <c:if test="${item.fileType eq 'jpg'}">
                                                        <img src="<c:url value="/image/jpg.png"/>" alt="jpg"
                                                             class="icon-m">
                                                    </c:if>
                                                    <c:if test="${item.fileType eq 'png'}">
                                                        <img src="<c:url value="/image/png.png"/>" alt="png"
                                                             class="icon-m">
                                                    </c:if>
                                                    <c:if test="${item.fileType eq 'mp3'}">
                                                        <img src="<c:url value="/image/mp3.png"/>" alt="mp3"
                                                             class="icon-m">
                                                    </c:if>
                                                    <c:if test="${item.fileType eq 'mp4'}">
                                                        <img src="<c:url value="/image/mp4.png"/>" alt="mp4"
                                                             class="icon-m">
                                                    </c:if>
                                                    <h4 class="card-title text-truncate mb-0 note-name">
                                                        <c:out value="${item.name}"/>
                                                    </h4>
                                                </div>

                                                <div class="d-flex">
                                                    <c:if test="${user ne null}">
                                                        <c:set var="addFavorite"
                                                               value="../notes/${item.id}/addfavorite"/>
                                                        <c:set var="removeFavorite"
                                                               value="../notes/${item.id}/removefavorite"/>

                                                        <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                             data-bs-title="<spring:message code="favorite"/>"
                                                             data-bs-trigger="hover">
                                                            <form:form
                                                                    action="${item.favorite ? removeFavorite : addFavorite}"
                                                                    method="post">
                                                                <input name="redirectUrl"
                                                                       value="/directory/${item.parentId}?${requestScope['javax.servlet.forward.query_string']}"
                                                                       type="hidden"/>
                                                                <button type="submit" onclick="event.stopPropagation();"
                                                                        class="btn nav-icon-button"
                                                                        data-bs-toggle="tooltip"
                                                                        data-bs-placement="bottom"
                                                                        data-bs-title="<spring:message code="favorite"/>"
                                                                        id="<c:out value="${item.id}"/>.f1">
                                                                    <img src="<c:url value="${ item.favorite ?  '/svg/filled-heart.svg' : '/svg/heart.svg'}"/>"
                                                                         alt="<spring:message code="favorite"/>"
                                                                         class="icon-xs fill-text">
                                                                </button>
                                                            </form:form>
                                                        </div>
                                                    </c:if>
                                                    <c:if test="${user ne null and (item.user.userId eq user.userId)}">
                                                        <a data-bs-toggle="tooltip" data-bs-placement="bottom" href="#"
                                                           data-bs-title="<spring:message code="edit"/>"
                                                           data-bs-trigger="hover">
                                                            <button class="btn nav-icon-button edit-button"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#editNoteModal"
                                                                    id="<c:out value="${item.id}.e2"/>">

                                                                <img src="<c:url value="/svg/pencil.svg"/>"
                                                                     alt="<spring:message code="edit"/>"
                                                                     class="icon-xs fill-text">
                                                            </button>
                                                        </a>
                                                    </c:if>
                                                    <c:if test="${user ne null and (item.user.userId eq user.userId or user.isAdmin) }">
                                                        <div data-bs-toggle="tooltip" data-bs-placement="bottom"
                                                             data-bs-title="<spring:message code="delete"/>"
                                                             data-bs-trigger="hover">
                                                            <button class="btn nav-icon-button delete-button"
                                                                    data-bs-toggle="modal"
                                                                    data-bs-target="#deleteManyModal"
                                                                    id="<c:out value="${item.id}"/>.e2">
                                                                <img src="<c:url value="/svg/trash.svg"/>"
                                                                     alt="<spring:message code="delete"/>"
                                                                     class="icon-xs fill-text">
                                                            </button>
                                                        </div>
                                                    </c:if>
                                                </div>
                                            </div>


                                            <span class="card-text">
                                        <strong><spring:message code="owner"/></strong>:
                                        <a href="${baseUrl}/user/${item.user.userId}/note-board"><c:out
                                                value="${item.user.displayName}"/></a>
                                    </span>

                                            <br>

                                            <span class="card-text">
                                        <c:if test="${navigationForm.sortBy eq 'date'}">
                                            <strong><spring:message code="createdAt"/></strong>:
                                        </c:if>
                                        <c:if test="${navigationForm.sortBy ne 'date'}">
                                            <strong><spring:message code="lastModifiedAt"/></strong>:
                                        </c:if>
                                        <spring:message code="date.format"
                                                        arguments="${date.year},${date.monthValue},${date.dayOfMonth}"/>
                                    </span>

                                            <br>

                                            <span class="card-text">
                                        <c:if test="${item.avgScore eq 0}">
                                            <strong><spring:message code="notes.noScore"/></strong>
                                        </c:if>
                                        <c:if test="${item.avgScore ne 0}">
                                            <strong><spring:message code="score"/></strong>:
                                            <fmt:formatNumber type="number" maxFractionDigits="1"
                                                              value="${item.avgScore}"/>
                                        </c:if>
                                    </span>
                                            <input type="checkbox" class="select-checkbox d-none"/>
                                        </div>
                                    </div>
                                </div>
                            </c:if>
                        </c:forEach>
                    </div>
                </c:if>
            </article>

            <!-- PAGINATION -->
            <c:if test="${maxPage gt 1}">
                <fragment:paging maxPage="${maxPage}" pageNumber="${currentPage}"/>
            </c:if>
        </c:if>

    </section>
</main>


<!-- CREATE NOTE MODAL -->
<div class="modal fade" id="createNoteModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="uploadLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form modelAttribute="createNoteForm"
                       action="${createUrl}"
                       method="post"
                       enctype="multipart/form-data"
                       autocomplete="off"
                       class="d-flex flex-column"
                       id="createNoteForm">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="uploadLabel"><spring:message
                            code="uploadNote"/></h1>
                    <button type="button" class="btn-close close-modal" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>
                <div class="modal-body pb-0">
                    <!-- CREATE NOTE FORM -->


                    <div class="d-flex flex-column gap-2">
                        <div class="input-group">
                            <label class="input-group-text" for="file"><spring:message
                                    code="file"/></label>
                            <form:input path="file" type="file" class="form-control" id="file" required="true"/>
                        </div>
                        <form:errors path="file" cssClass="text-danger" element="p"/>
                        <p class="text-danger d-none" id="file-size-error">
                            <spring:message code="notes.file.tooHeavy"/>
                        </p>
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="name"><spring:message
                                    code="name"/></label>
                            <form:input path="name" type="text"
                                        class="form-control" id="name" required="true"/>
                        </div>
                        <form:errors path="name" cssClass="text-danger" element="p"/>
                        <form:errors cssClass="text-danger" element="p"/> <!-- Global errors -->
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="categorySelect"><spring:message
                                    code="category"/></label>
                            <form:select path="category" class="form-select" id="categorySelect">
                                <form:option value="theory"><spring:message
                                        code="category.theory"/></form:option>
                                <form:option value="practice"><spring:message
                                        code="category.practice"/></form:option>
                                <form:option value="exam"><spring:message
                                        code="category.exam"/></form:option>
                                <form:option value="other"><spring:message
                                        code="category.other"/></form:option>
                            </form:select>
                        </div>
                        <form:errors path="category" cssClass="text-danger" element="p"/>
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="visible"><spring:message
                                    code="privacy"/></label>
                            <form:select path="visible" class="form-select" id="visible">
                                <form:option value="true"><spring:message
                                        code="public"/></form:option>
                                <form:option value="false"><spring:message
                                        code="private"/></form:option>
                            </form:select>
                        </div>
                        <form:errors path="visible" cssClass="text-danger" element="p"/>
                    </div>

                    <input type="hidden" name="parentId" value="${directory.id}"/>
                    <input type="hidden" name="createNote" value="createNote"/>
                </div>
                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary close-modal"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <input type="submit" class="btn rounded-box button-primary" value="<spring:message
                                            code="upload"/>"/>
                </div>
            </form:form>
        </div>
    </div>
</div>

<!-- CREATE DIRECTORY MODAL -->
<div class="modal fade" id="createDirectoryModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="createLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form modelAttribute="createDirectoryForm"
                       action="${createUrl}"
                       method="post"
                       enctype="multipart/form-data"
                       autocomplete="off"
                       class="d-flex flex-column"
                       id="createDirectoryForm">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="createLabel"><spring:message
                            code="createDirectory"/></h1>
                    <button type="button" class="btn-close close-modal" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>
                <div class="modal-body pb-0">

                    <div class="d-flex flex-column gap-2">
                        <div class="input-group">
                            <label class="input-group-text" for="name"><spring:message
                                    code="name"/></label>
                            <form:input path="name" type="text"
                                        class="form-control" id="name" required="true"/>
                        </div>
                        <form:errors path="name" cssClass="text-danger" element="p"/>
                        <form:errors cssClass="text-danger" element="p"/> <!-- Global errors -->
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="visible"><spring:message
                                    code="privacy"/></label>
                            <form:select path="visible" class="form-select" id="visible">
                                <form:option value="true"><spring:message
                                        code="public"/></form:option>
                                <form:option value="false"><spring:message
                                        code="private"/></form:option>
                            </form:select>
                        </div>
                        <form:errors path="visible" cssClass="text-danger" element="p"/>
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group gap-3 d-flex align-items-center">
                            <label class="input-group-text"><spring:message
                                    code="color"/></label>
                            <c:forEach var="color" items="${colors}">
                                <div>
                                    <form:radiobutton path="color" value="${color}" id="color${color}"
                                                      cssClass="d-none color-radio"/>
                                    <img src="<c:url value="/svg/folder.svg"/>" alt="${folder}"
                                         class="color-option icon-m fill-${color} >"/>
                                </div>
                            </c:forEach>
                            <form:errors path="color" cssClass="text-danger" element="p"/>
                        </div>
                    </div>
                    <input type="hidden" name="parentId" value="${directory.id}"/>
                    <input type="hidden" name="createDirectory" value="createDirectory"/>
                </div>
                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary close-modal"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/>
                    </button>
                    <input type="submit" class="btn rounded-box button-primary" value="<spring:message
                                            code="upload"/>"/>
                </div>
            </form:form>
        </div>
    </div>
</div>

<c:url value="../notes/" var="editNoteUrl"/>
<c:url value="./${directoryId}" var="editDirectoryUrl"/>
<!--  EDIT NOTE MODAL -->
<div class="modal fade" id="editNoteModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="editNoteLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form modelAttribute="editNoteForm"
                       action="${editNoteUrl}"
                       method="post"
                       enctype="multipart/form-data"
                       autocomplete="off"
                       class="d-flex flex-column"
                       id="editNoteForm">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="editNoteLabel"><spring:message
                            code="editNote"/></h1>
                    <button type="button" class="btn-close close-modal" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>
                <div class="modal-body pb-0">
                    <!-- EDIT NOTE FORM -->


                    <div class="d-flex flex-column gap-2">
                        <div class="input-group">
                            <label class="input-group-text" for="name"><spring:message
                                    code="name"/></label>
                            <form:input path="name" type="text"
                                        class="form-control" id="name" required="true"/>
                        </div>
                        <form:errors path="name" cssClass="text-danger" element="p"/>
                        <form:errors cssClass="text-danger" element="p"/> <!-- Global errors -->
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="categorySelect"><spring:message
                                    code="category"/></label>
                            <form:select path="category" class="form-select" id="categorySelect">
                                <form:option value="theory"><spring:message code="category.theory"/></form:option>
                                <form:option value="practice"><spring:message
                                        code="category.practice"/></form:option>
                                <form:option value="exam"><spring:message code="category.exam"/></form:option>
                                <form:option value="other"><spring:message code="category.other"/></form:option>
                            </form:select>
                        </div>
                        <form:errors path="category" cssClass="text-danger" element="p"/>
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="visible"><spring:message
                                    code="privacy"/></label>
                            <form:select path="visible" class="form-select" id="visible">
                                <form:option value="true"><spring:message
                                        code="public"/></form:option>
                                <form:option value="false"><spring:message
                                        code="private"/></form:option>
                            </form:select>
                        </div>
                        <form:errors path="visible" cssClass="text-danger" element="p"/>
                    </div>
                </div>
                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary close-modal"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <input type="submit" class="btn rounded-box button-primary" value="<spring:message
                                                code="update"/>"/>
                </div>
                <form:hidden path="id" id="noteId"/>
                <input type="hidden" name="parentId" value="${directory.id}"/>
                <input name="redirectUrl" value="/directory/${directory.id}?userId=${filterUser.userId}" type="hidden"/>
            </form:form>
        </div>
    </div>
</div>

<!-- EDIT DIRECTORY MODAL-->
<div class="modal fade" id="editDirectoryModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="editDirectoryLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">

            <form:form modelAttribute="editDirectoryForm"
                       action=""
                       method="post"
                       enctype="multipart/form-data"
                       autocomplete="off"
                       class="d-flex flex-column"
                       id="editDirectoryForm">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="editDirectoryLabel"><spring:message
                            code="editDirectory"/></h1>
                    <button type="button" class="btn-close close-modal" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>
                <div class="modal-body pb-0">
                    <!-- EDIT DIRECTORY FORM -->
                    <div class="d-flex flex-column gap-2">
                        <div class="input-group">
                            <label class="input-group-text" for="name"><spring:message
                                    code="name"/></label>
                            <form:input path="name" type="text"
                                        class="form-control" id="name" required="true"/>
                        </div>
                        <form:errors path="name" cssClass="text-danger" element="p"/>
                        <form:errors cssClass="text-danger" element="p"/> <!-- Global errors -->
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group">
                            <label class="input-group-text" for="visible"><spring:message
                                    code="privacy"/></label>
                            <form:select path="visible" class="form-select" id="visible">
                                <form:option value="true"><spring:message
                                        code="public"/></form:option>
                                <form:option value="false"><spring:message
                                        code="private"/></form:option>
                            </form:select>
                        </div>
                        <form:errors path="visible" cssClass="text-danger" element="p"/>
                    </div>

                    <div class="d-flex flex-column gap-2 mt-4">
                        <div class="input-group gap-3 d-flex align-items-center">
                            <label class="input-group-text"><spring:message
                                    code="color"/></label>
                            <c:forEach var="color" items="${colors}">
                                <div>
                                    <form:radiobutton path="color" value="${color}" id="color${color}"
                                                      cssClass="d-none color-radio"/>
                                    <img src="<c:url value="/svg/folder.svg"/>" alt="${folder}"
                                         class="color-option icon-m fill-${color}"/>
                                </div>
                            </c:forEach>
                            <form:errors path="color" cssClass="text-danger" element="p"/>
                        </div>
                    </div>
                </div>

                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary close-modal"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <input type="submit" class="btn rounded-box button-primary" value="<spring:message
                                                code="update"/>"/>
                </div>
                <form:hidden path="id" id="directoryId"/>
                <input type="hidden" name="parentId" id="parentId" value="${directory.id}"/>
                <input type="hidden" name="redirectUrl" value="/directory/${directoryId}?userId=${filterUser.userId}"/>
            </form:form>

        </div>
    </div>
</div>

<!-- DELETE MODAL -->
<c:url var="deleteUrl" value="./delete"/>
<div class="modal fade" id="deleteManyModal" data-bs-backdrop="static" data-bs-keyboard="false"
     tabindex="-1" aria-labelledby="deleteLabel" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content box bg-bg">
            <form:form modelAttribute="deleteWithReasonForm" id="deleteForm" method="POST" action="${deleteUrl}">
                <div class="modal-header">
                    <h1 class="modal-title fs-5" id="deleteLabel"><spring:message code="delete"/></h1>
                    <button type="button" class="btn-close close-modal" data-bs-dismiss="modal"
                            aria-label="Close">
                    </button>
                </div>
                <div class="modal-body pb-0 d-flex flex-column">
                    <spring:message code="DeleteForm.description"/>
                    <spring:message code="DeleteForm.explain" var="deleteMessagePlaceholder"/>
                    <c:if test="${user ne null and user.isAdmin and directory.user.userId ne user.userId}">
                        <label for="reason"></label>
                        <form:textarea path="reason" name="reason" class="form-control mt-3" id="reason"
                                       placeholder="${deleteMessagePlaceholder}"/>
                        <form:errors path="reason" cssClass="text-danger" element="p"/>
                    </c:if>
                </div>

                <form:input path="redirectUrl" type="hidden" name="redirectUrl"
                            value="/directory/${directoryId}?userId=${filterUser.userId}"/>

                <div class="modal-footer mt-4">
                    <button type="button" class="btn rounded-box button-secondary close-modal"
                            data-bs-dismiss="modal">
                        <spring:message code="close"/></button>
                    <input id="deleteSelectedButton" type="submit" class="btn rounded-box button-primary" value="<spring:message
                                                code="delete"/>"/>
                </div>

            </form:form>
        </div>
    </div>
</div>

<fragment:custom-toast message=""/>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.1/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-HwwvtgBNo3bZJJLYd8oVXjrBZt8cqVSpeBNS5n7C8IVInixGAoxmnlMuBnhbgrkm"
        crossorigin="anonymous"></script>

<script src="<c:url value="/js/ascdesc.js"/>"></script>
<script src="<c:url value="/js/popups.js"/>"></script>
<script src="<c:url value="/js/color-picker.js"/>"></script>
<script src="<c:url value="/js/file-control.js"/>"></script>
<script src="<c:url value="/js/search-buttons.js"/>"></script>
<c:if test="${not empty results}">
    <script>
        <c:if test="${filterUser ne null}">
        const filteredUser = "<c:out value="${filterUser.userId}"/>";
        </c:if>
    </script>
    <script src="<c:url value="/js/note-list.js"/>"></script>
    <script src="<c:url value="/js/crud-buttons.js"/>"></script>
</c:if>
<script src="<c:url value="/js/crud-buttons-bnav.js"/>"></script>

<c:if test="${errorsEditNoteForm ne null}">
    <script>
        const id = "<c:out value="${editNoteId}"/>";
        edit(id, true);
        let editNoteModal = new bootstrap.Modal(document.getElementById('editNoteModal'), {})
        editNoteModal.show();
    </script>
</c:if>

<c:if test="${errorsEditDirectoryForm ne null}">
    <script>
        const id = "<c:out value="${editDirectoryId}"/>";
        const myId = "<c:out value="${directoryId}"/>";
        const name = "<c:out value="${directory.name}"/>";
        const iconColor = "<c:out value="${directory.iconColor}"/>";
        const visible = "<c:out value="${directory.visible}"/>";
        const parentId = "<c:out value="${directory.parentId}"/>";
        if (id === myId)
            editBNavDirectory(id, name, visible, iconColor, parentId, true)
        else
            edit(id, true)
        let editDirectoryModal = new bootstrap.Modal(document.getElementById('editDirectoryModal'), {})
        editDirectoryModal.show()

    </script>
</c:if>

<c:if test="${errorsCreateNoteForm ne null}">
    <script>
        const createNoteModalButton = document.getElementById('createNoteModalButton');
        createNoteModalButton.click()
    </script>
</c:if>

<c:if test="${errorsCreateDirectoryForm ne null}">
    <script>
        const createDirectoryModalButton = document.getElementById('createDirectoryModalButton');
        createDirectoryModalButton.click()
    </script>
</c:if>

<c:if test="${errorsDeleteWithReasonForm ne null}">
    <script>
        const noteIds = ${deleteNoteIds};
        const directoryIds = ${deleteDirectoryIds};

        selectedRowIds.clear();

        const deleteForm = document.getElementById('deleteForm')

        noteIds.forEach(id => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'noteIds';
            input.value = id;
            deleteForm.appendChild(input);
            selectedRowIds.add(id);
        });

        directoryIds.forEach(id => {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = 'directoryIds';
            input.value = id;
            deleteForm.appendChild(input);
            selectedRowIds.add(id);
        });

        updateSelectedState()

        let deleteModal = new bootstrap.Modal(document.getElementById('deleteManyModal'), {})
        deleteModal.show();
    </script>
</c:if>

<script>
    const liveToast = document.getElementById('liveToast');
    for (let copyButton of document.getElementsByClassName('copy-button')) {
        copyButton.addEventListener('click', () => {
            displayToast('<spring:message code="toast.linkCopied"/>')
        })
    }
</script>

<script>
    <c:if test="${noteEdited eq true}">
    displayToast('<spring:message code="toast.noteEdited"/>')
    </c:if>

    <c:if test="${noteDeleted eq true}">
    displayToast('<spring:message code="toast.noteDeleted"/>')
    </c:if>

    <c:if test="${directoryCreated eq true}">
    displayToast('<spring:message code="toast.directoryCreated"/>')
    </c:if>

    <c:if test="${directoryDeleted eq true}">
    displayToast('<spring:message code="toast.directoryDeleted"/>')
    </c:if>

    <c:if test="${directoryEdited eq true}">
    displayToast('<spring:message code="toast.directoryEdited"/>')
    </c:if>

    <c:if test="${favoriteAdded eq true}">
    displayToast('<spring:message code="toast.addFavorite"/>')
    </c:if>

    <c:if test="${favoriteRemoved eq true}">
    displayToast('<spring:message code="toast.removeFavorite"/>')
    </c:if>
    <c:if test="${itemsDeleted eq true}">
    displayToast('<spring:message code="toast.itemsDeleted"/>')
    </c:if>
</script>

</body>

</html>
