<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="tspace" uri="http://slis.uiowa.edu/tspace"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>PubMed Central Acknowledgements 1.0</title>
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
	<div id="content"><jsp:include page="/header.jsp" flush="true" />
		<jsp:include page="/menu.jsp" flush="true"><jsp:param
				name="caller" value="research" /></jsp:include><div id="centerCol">
			<h3>Fragment: ${param.fragment }</h3>
			
            <div id=mode style=" float:left; width:100%">
			<h4>Submitting Rule</h4>
            <table>
                <tr><th>Fragment</th><td>${param.fragment}</td></tr>
                <tr><th>tgrep Expression</th><td>${param.tgrep}</td></tr>
                <tr><th>Mode</th><td>${param.mode}</td></tr>
                <tr><th>Relation</th><td>${param.relation}</td></tr>
                <tr><th>Slot 0</th><td>${param.slot0}</td></tr>
                <tr><th>Slot 1</th><td>${param.slot1}</td></tr>
            </table>
            <c:if test="${param.mode == 'instantiate' }">
                <sql:update dataSource="jdbc/AcknowledgementsTagLib">
                    insert into pubmed_central_ack_stanford.template(fragment,tgrep,mode,relation) values(?,?,?,?)
                    <sql:param>${param.fragment}</sql:param>
                    <sql:param>${param.tgrep}</sql:param>
                    <sql:param>${param.mode}</sql:param>
                    <sql:param>${param.relation}</sql:param>
                </sql:update>
            </c:if>
            <c:if test="${param.mode == 'promote' }">
                <sql:update dataSource="jdbc/AcknowledgementsTagLib">
                    insert into pubmed_central_ack_stanford.template(fragment,tgrep,mode) values(?,?,?)
                    <sql:param>${param.fragment}</sql:param>
                    <sql:param>${param.tgrep}</sql:param>
                    <sql:param>${param.mode}</sql:param>
                </sql:update>
            </c:if>
            <c:if test="${param.mode == 'store' }">
                <sql:update dataSource="jdbc/AcknowledgementsTagLib">
                    insert into pubmed_central_ack_stanford.template(fragment,tgrep,mode,relation,slot0,slot1) values(?,?,?,?,?,?)
                    <sql:param>${param.fragment}</sql:param>
                    <sql:param>${param.tgrep}</sql:param>
                    <sql:param>${param.mode}</sql:param>
                    <sql:param>${param.relation}</sql:param>
                    <sql:param>${param.slot0}</sql:param>
                    <sql:param>${param.slot1}</sql:param>
                </sql:update>
            </c:if>
			</div>
			<tspace:server spaceName="PMC" hostName="deep-thought.slis.uiowa.edu">
    		      <tspace:write request="refragment" arg1="${param.fragment}"/>
 			</tspace:server>
			<c:if test="${not empty param.fragment}"><a href="generate.jsp?fragment=${param.fragment}&pattern=${param.pattern}">Generate fragment: ${param.fragment}</a></c:if><br>
            <c:if test="${not empty param.pattern}"><a href="browse_pattern.jsp?fragment=${param.fragment}&tgrep=${param.pattern}">Browse pattern: ${param.pattern}</a></c:if>
			<jsp:include page="/footer.jsp" flush="true" /></div>
	</div>
</body>
</html>

