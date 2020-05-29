<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>N3c Training Courses</title>
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
	<div id="content"><jsp:include page="/header.jsp" flush="true" />
		<jsp:include page="/menu.jsp" flush="true"><jsp:param
				name="caller" value="research" /></jsp:include>
		<div id="centerCol">
			<h2>N3C Training Courses</h2>

			<sql:query var="courses" dataSource="jdbc/covid">
            	select id,offerer,title,description,enrollment_limit,duration from n3c_training.course order by title;
            </sql:query>
			<c:forEach items="${courses.rows}" var="row" varStatus="rowCounter">
				<br />
				<h3>${row.title} <i>(${row.offerer})</i></h3>
				<p>Offerings:</p>
				<sql:query var="offerings" dataSource="jdbc/covid">
            		select id,seqnum,delivery_date,delivery_time as start_time,delivery_time+duration as end_time from n3c_training.course natural join n3c_training.offering where id = ?::int order by delivery_date,start_time;
            		<sql:param>${row.id}</sql:param>
            	</sql:query>
				<ul>
				<c:forEach items="${offerings.rows}" var="offering" varStatus="rowCounter">
					<li><a href="course.jsp?id=${offering.id}&seqnum=${offering.seqnum}">${offering.delivery_date}, ${offering.start_time} - ${offering.end_time}</a>
				</c:forEach>
				</ul>
			</c:forEach>
			<jsp:include page="/footer.jsp" flush="true" />
		</div>
	</div>
</body>
</html>

