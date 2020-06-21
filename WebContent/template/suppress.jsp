<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<sql:update dataSource="jdbc/AcknowledgementsTagLib">
    insert into pubmed_central_ack_stanford.template_suppress values(?);
    <sql:param>${param.fragment}</sql:param>
</sql:update>
<<c:if test="${empty param.tgrep}">
    <c:redirect url="browse_unbound.jsp" />
</c:if>
<c:redirect url="browse_pattern.jsp?tgrep=${param.tgrep}" />
