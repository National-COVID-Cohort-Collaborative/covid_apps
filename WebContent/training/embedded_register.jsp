<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
		<div id="centerCol">
		<h2>Register for Training</h2>
		<c:if test="${not empty param.submit }">
			<c:set var="result" value = "OK"/>
			<sql:query var="course" dataSource="jdbc/covid">
            	select * from n3c_training.offering_detail where seqnum = ?::int and enrolled >= enrollment_limit;
 				<sql:param>${param.section}</sql:param>
            </sql:query>
			<c:forEach items="${course.rows}" var="course" varStatus="rowCounter">
				<p>Sorry, that course is full.</p>
				<c:set var="result" value="failed" />
			</c:forEach>
			<sql:query var="course" dataSource="jdbc/covid">
            	select * from n3c_training.registration where seqnum = ?::int and email = ?;
 				<sql:param>${param.section}</sql:param>
 				<sql:param>${param.email}</sql:param>
            </sql:query>
			<c:forEach items="${course.rows}" var="course" varStatus="rowCounter">
				<p>Sorry, you are already registered for that section.</p>
				<c:set var="result" value="failed" />
			</c:forEach>
			<c:if test="${result == 'OK'}">
				<c:set var="user" value = "new"/>
				<sql:query var="person" dataSource="jdbc/covid">
	            	select * from n3c_training.person where email = ?
	 				<sql:param>${param.email}</sql:param>
	            </sql:query>
				<c:forEach items="${person.rows}" var="person" varStatus="rowCounter">
					<c:set var="user" value="exists" />
				</c:forEach>
				<c:if test="${user == 'new'}">
					<sql:update dataSource="jdbc/covid">
						insert into n3c_training.person(email,first_name,last_name) values (?,?,?);
						<sql:param>${param.email}</sql:param>
						<sql:param>${param.first_name}</sql:param>
						<sql:param>${param.last_name}</sql:param>
					</sql:update>
				</c:if>
				<sql:query var="course" dataSource="jdbc/covid">
	            	select id from n3c_training.offering where seqnum = ?::int;
	 				<sql:param>${param.section}</sql:param>
	            </sql:query>
				<c:forEach items="${course.rows}" var="course" varStatus="rowCounter">
					<sql:update dataSource="jdbc/covid">
						insert into n3c_training.registration(email,id,seqnum) values (?,?::int,?::int);
						<sql:param>${param.email}</sql:param>
						<sql:param>${course.id}</sql:param>
						<sql:param>${param.section}</sql:param>
					</sql:update>
				</c:forEach>
				<p>You're registered!</p>
			</c:if>
		</c:if>
			<form method='GET' action='embedded_register.jsp'>
			<div id=others style="float: left; width: 45%"><div id=others style="float: left; width: 90%">
			<fieldset><legend>Details</legend>
			First Name: <input name="first_name" value="${param.first_name}" size=20><br>
			Last Name: <input name="last_name" value="${param.last_name}" size=40><br>
			Email: <input name="email" value="${param.email}" size=40>
			</fieldset>
			<input type=submit name=submit value=submit>
			</div></div>
			<div id=others style="float: left; width: 45%">
			<sql:query var="course" dataSource="jdbc/covid">
            	select * from n3c_training.course where id in (select id from n3c_training.offering_detail where start_time > now());
            </sql:query>
			<c:forEach items="${course.rows}" var="course" varStatus="rowCounter">
				<h3>${course.title} <i>(${course.offerer})</i></h3>
				<sql:query var="offering" dataSource="jdbc/covid">
	            	select
	            		id,
	            		seqnum,
	            		to_char(start_time at time zone 'US/Eastern','Dy, Mon FMDD YYYY FMHH:MI PM') as start_time,
	            		to_char(end_time at time zone 'US/Eastern', 'FMHH:MI PM') as end_time,
	            		enrolled,
	            		enrollment_limit 
	            	from n3c_training.offering_detail where id = ?::int and start_time > now() order by start_time;
	            	<sql:param>${course.id}</sql:param>
	            </sql:query>
				<c:forEach items="${offering.rows}" var="offering" varStatus="rowCounter">
					<input id="section" name=section type="radio" value="${offering.seqnum}"> ${offering.start_time} - ${offering.end_time}
				        (enrollment: ${offering.enrolled} of ${offering.enrollment_limit})<br>
				</c:forEach>
				<br>
			</c:forEach>
			</div>
			</form>
		</div>
	</div>
</body>
</html>

