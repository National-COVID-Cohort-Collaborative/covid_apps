<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="tspace" uri="http://slis.uiowa.edu/tspace"%>

<c:forEach var="value" items="${paramValues.node}">
	<sql:update dataSource="jdbc/covid">
        insert into covid_biorxiv.vocabulary values(?,?,true)
        <sql:param>${value}</sql:param>
		<sql:param>${param.relation}</sql:param>
	</sql:update>
    <sql:update dataSource="jdbc/covid">
        insert into covid_biorxiv.vocabulary values(?,substring(? from ':([A-Za-z]+) ]$'),false)
        <sql:param>${value}</sql:param>
        <sql:param>${param.fragment}</sql:param>
    </sql:update>
</c:forEach>
<c:redirect url="vocabulary.jsp">
	<c:param name="fragment" value="${param.fragment}" />
</c:redirect>
