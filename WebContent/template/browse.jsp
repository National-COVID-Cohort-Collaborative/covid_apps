<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>

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
            <h3>All fragments</h3>
            <table>
                <tr>
                    <th>Frequency</th>
                    <th># Rules</th>
                    <th>Fragment</th>
                </tr>
                <sql:query var="fragments" dataSource="jdbc/AcknowledgementsTagLib">
                    select fragment,count,frequency
                    from pubmed_central_ack_stanford.fragments natural join (select fragment,count(*) from pubmed_central_ack_stanford.template group by 1) as foo
                    order by frequency desc limit 1000;
                </sql:query>
                <c:forEach items="${fragments.rows}" var="row" varStatus="rowCounter">
                    <tr>
                        <td align=right>${row.frequency}</td>
                      <td align=right>${row.count}</td>
                        <td><a href="browse_fragment.jsp?fragment=${row.fragment}">${row.fragment}</a></td>
                    </tr>
                </c:forEach>
            </table>
			<jsp:include page="/footer.jsp" flush="true" /></div>
	</div>
</body>
</html>

