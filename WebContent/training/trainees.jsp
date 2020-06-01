<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>N3c Trainees</title>
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
	<div id="content"><jsp:include page="/header.jsp" flush="true" />
		<jsp:include page="/menu.jsp" flush="true"><jsp:param
				name="caller" value="research" /></jsp:include>
		<div id="centerCol">
			<h2>N3C Trainees</h2>

			<sql:query var="courses" dataSource="jdbc/covid">
            	select email,first_name,last_name from n3c_training.person order by last_name,first_name;
            </sql:query>
			<ul>
				<c:forEach items="${courses.rows}" var="row" varStatus="rowCounter">
                    <li>${row.last_name}, ${row.first_name} [${row.email}]
				</c:forEach>
			</ul>
			<jsp:include page="/footer.jsp" flush="true" />
		</div>
	</div>
</body>
</html>

