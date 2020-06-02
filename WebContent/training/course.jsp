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
			<sql:query var="course" dataSource="jdbc/covid">
            	select id,offerer,title,seqnum,to_char(start_time at time zone 'US/Eastern','Dy, Mon FMDD YYYY FMHH:MI PM') as start_time,to_char(end_time at time zone 'US/Eastern','FMHH:MI PM') as end_time from n3c_training.offering_detail natural join n3c_training.course where seqnum=?::int
            	<sql:param>${param.seqnum}</sql:param>
            </sql:query>
			<c:forEach items="${course.rows}" var="row" varStatus="rowCounter">
				<br />
				<h2>${row.title} <i>(${row.offerer})</i></h2>
				<p>Offering: ${row.start_time} - ${row.end_time} ET</p>
				<sql:query var="registrants" dataSource="jdbc/covid">
            		select email,first_name,last_name from n3c_training.registration natural join n3c_training.person where id = ?::int and seqnum = ?::int order by last_name,first_name;
            		<sql:param>${param.id}</sql:param>
            		<sql:param>${param.seqnum}</sql:param>
            	</sql:query>
				<ul>
				<c:forEach items="${registrants.rows}" var="registrant" varStatus="rowCounter">
					<li>${registrant.last_name}, ${registrant.first_name} [${registrant.email}]
				</c:forEach>
				</ul>
			</c:forEach>
			<jsp:include page="/footer.jsp" flush="true" />
		</div>
	</div>
</body>
</html>

