<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib uri = "http://java.sun.com/jsp/jstl/functions" prefix = "fn" %>

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
			<c:choose>
				<c:when test="${empty param.fragment and empty param.node}">
 					<h3>Fragments</h3>
					<table>
						<tr>
							<th>Frequency</th>
							<th>Fragment</th>
						</tr>
						<sql:query var="fragments" dataSource="jdbc/covid">
		                    select fragment,frequency
		                    from covid_biorxiv.fragments
		                    order by 2 desc, 1 limit 1000;
		                </sql:query>
						<c:forEach items="${fragments.rows}" var="row" varStatus="rowCounter">
							<tr>
								<td align=right>${row.frequency}</td>
								<td nowrap="nowrap"><a href="vocabulary.jsp?fragment=${row.fragment}">${row.fragment}</a></td>
							</tr>
						</c:forEach>
					</table>
				</c:when>
				<c:when test="${not empty param.fragment and empty param.node}">
            <form method='GET' action='submit_vocabulary.jsp'>
					<button type="submit" name="action" value="submit">Submit</button>
					<h3>Fragment: ${param.fragment }</h3>
            <div id=relation style=" float:left; width:250px">
					<table>
						<tr>
							<th>Frequency</th>
							<th></th>
							<th>node</th>
						</tr>
						<sql:query var="nodes" dataSource="jdbc/covid">
		                    select substring(node from '([^ ]+)/[A-Z]+ ]$') as node,count(*)
		                    from covid_biorxiv.fragment
		                    where fragment = ?
		                      and (substring(node from '([^ ]+)/[A-Z]+ ]$'),substring(? from ':([A-Za-z]*) ]$')) not in
		                          (select term,coalesce(entity_class,'') from covid_biorxiv.vocabulary)
		                    group by 1
		                    order by 2 desc limit 100;
		                    <sql:param>${param.fragment}</sql:param>
                            <sql:param>${param.fragment}</sql:param>
		                </sql:query>
						<c:forEach items="${nodes.rows}" var="row" varStatus="rowCounter">
							<tr>
								<td align=right>${row.count}</td>
		                        <td><input type="checkbox" name="node" value="${row.node}" ></td>
								<td nowrap="nowrap">${row.node}</td>
							</tr>
						</c:forEach>
					</table>
					</div>
            <div id=relation style=" float:left; width:180px">
            <h4>Relation</h4>
               <sql:query var="modes" dataSource="jdbc/covid">
                    select relation,entity_class
                    from covid_biorxiv.template_relation
                    order by seq;
                </sql:query>
                <c:forEach items="${modes.rows}" var="row" varStatus="rowCounter">
                    <c:if test="${rowCounter.index != 0 && rowCounter.index % 20 == 0}">
                        </div><div id=relation style=" float:left; width:180px"><h4>Relation, con't.</h4>
                    </c:if>
                    <input id="relation_${row.relation}" name=relation type="radio" value="${row.entity_class}">${row.relation}<br>
                </c:forEach>
                <input id="relation_${row.relation}" name=relation type="radio" value="ignore">ignore<br>
             </div>
                <input type="hidden" name="fragment" value="${param.fragment}">
					</form>
				</c:when>
			</c:choose>

			<jsp:include page="/footer.jsp" flush="true" />
		</div>
	</div>
</body>
</html>

