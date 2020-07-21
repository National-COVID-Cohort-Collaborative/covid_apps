<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="tspace" uri="http://slis.uiowa.edu/tspace"%>

<c:forEach var="value" items="${paramValues.node}">
        <c:out value="${value}" />
    </c:forEach>
${param.relation}