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
				<form action="browse_pattern.jsp">
				tgrep regular expression: <input type="text" id="tgrep" name="tgrep" size="100" value="${param.tgrep}"><br>
				<input type="checkbox" name="doAll" <c:if test="${not empty param.doAll}">checked</c:if>> Do all fragments
				</form>
            <h3>Matching Fragments</h3>
            (Currently queued patterns: 
				<tspace:server spaceName="PMC" hostName="deep-thought.slis.uiowa.edu">
				    <tspace:count request="refragment"/>
				</tspace:server>
            )
            <c:if test="${not empty param.tgrep }">
            <table>
                <tr>
                    <th>Frequency</th>
                    <th>Fragment</th>
                </tr>
                <sql:query var="fragments" dataSource="jdbc/AcknowledgementsTagLib">
                    select fragment,frequency
                    from pubmed_central_ack_stanford.fragments
                    where fragment~?
                      and fragment not in (select fragment from pubmed_central_ack_stanford.template_suppress)
                      and fragment not in (select fragment from pubmed_central_ack_stanford.template_defer)
                      and fragment not in (select fragment from pubmed_central_ack_stanford.template_complete)
                      <c:if test="${empty param.doAll}">and fragment not in (select fragment from pubmed_central_ack_stanford.template)</c:if>
                    order by 2 desc limit 1000;
                    <sql:param>${param.tgrep}</sql:param>
                </sql:query>
                <c:forEach items="${fragments.rows}" var="row" varStatus="rowCounter">
                    <tr>
                        <td align=right>${row.frequency}</td>
                        <td><a href="generate.jsp?fragment=${row.fragment}&pattern=${param.tgrep}">${row.fragment}</a></td>
                        <td><a href="suppress.jsp?fragment=${row.fragment}&tgrep=${param.tgrep}">suppress</a></td>
                        <td><a href="defer.jsp?fragment=${row.fragment}&tgrep=${param.tgrep}">defer</a></td>
                    </tr>
                </c:forEach>
            </table>
            </c:if>
			<jsp:include page="/footer.jsp" flush="true" /></div>
	</div>
</body>
</html>

