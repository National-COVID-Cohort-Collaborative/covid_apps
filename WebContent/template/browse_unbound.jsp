<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib  prefix="fn" uri = "http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>N3C Preprint Annotation</title>
<style type="text/css" media="all">
@import "<util:applicationRoot/>/resources/style.css";
</style>
</head>
<body>
    <div id="content"><jsp:include page="/header.jsp" flush="true" />
        <jsp:include page="/menu.jsp" flush="true"><jsp:param
                name="caller" value="research" /></jsp:include>
        <div id="centerCol">
	
            <h3>Unbound fragments</h3>
            <table>
                <tr>
                    <th>Frequency</th>
                    <th></th>
                    <th>Fragment</th>
                </tr>
                <sql:query var="fragments" dataSource="jdbc/covid">
                    select fragment,frequency
                    from covid_biorxiv.fragments
                    where fragment~'^\[NP '
                      and fragment not in (select fragment from covid_biorxiv.template_suppress)
                      and fragment not in (select fragment from covid_biorxiv.template_defer)
                      and fragment not in (select fragment from covid_biorxiv.template)
                    order by 2 desc, 1 limit 1000;
                </sql:query>
                <c:forEach items="${fragments.rows}" var="row" varStatus="rowCounter">
                    <tr>
                        <td align=right>${row.frequency}</td>
                        <td><a href="suppress.jsp?fragment=${fn:escapeXml(row.fragment)}&?tgrep=${param.tgrep}">suppress</a></td>
                        <td nowrap="nowrap"><a href="generate.jsp?fragment=${fn:escapeXml(row.fragment)}">${row.fragment}</a></td>
                    </tr>
                </c:forEach>
            </table>
            <jsp:include page="/footer.jsp" flush="true" />
        </div>
    </div>
</body>
</html>

