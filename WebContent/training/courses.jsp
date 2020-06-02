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
 	            	select
	            		id,
	            		seqnum,
	            		to_char(start_time at time zone 'US/Eastern','Dy, Mon FMDD YYYY FMHH:MI PM') as start_time,
	            		to_char(end_time at time zone 'US/Eastern', 'FMHH:MI PM') as end_time,
	            		enrolled,
	            		enrollment_limit 
	            	from n3c_training.offering_detail where id = ?::int and start_time > now() order by start_time;
            		<sql:param>${row.id}</sql:param>
            	</sql:query>
				<ul>
				<c:forEach items="${offerings.rows}" var="offering" varStatus="rowCounter">
					<li><a href="course.jsp?id=${offering.id}&seqnum=${offering.seqnum}">${offering.start_time} - ${offering.end_time} ET</a>
				        (enrollment: ${offering.enrolled} of ${offering.enrollment_limit})
				</c:forEach>
				</ul>
			</c:forEach>
			<jsp:include page="/footer.jsp" flush="true" />
		</div>
	</div>
</body>
</html>

