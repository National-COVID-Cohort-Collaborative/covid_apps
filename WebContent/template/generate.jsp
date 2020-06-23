<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql"%>
<%@ taglib prefix="util" uri="http://icts.uiowa.edu/tagUtil"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

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
			<h3>Fragment: ${param.fragment }</h3>
			
           <jsp:include page="../visualization/syntaxTree.jsp" flush="true">
                <jsp:param name="tgrep" value="${param.fragment }" />
           </jsp:include>
             <div id=others style=" float:right; width:40%">
               <sql:query var="templates" dataSource="jdbc/covid">
                    select mode,tgrep,relation,slot0,slot1
                    from pubmed_central_ack_stanford.template
                    where fragment = ?
                    order by 1,2,3;
                    <sql:param value="${param.fragment}"/>
                </sql:query>
                <c:if test="${templates.rowCount > 0}">
                <table>
                    <tr><th>mode</th><th>tgrep</th><th>relation</th><th>slot0</th><th>slot1</th></tr>
                <c:forEach items="${templates.rows}" var="row" varStatus="rowCounter">
                    <tr><td>${row.mode}</td><td>${row.tgrep}</td><td>${row.relation}</td><td>${row.slot0}</td><td>${row.slot1}</td></tr>
                </c:forEach>
                </table>
                </c:if>
            </div>
            <div id=mode style=" float:left; width:100%">
             
            <form method='GET' action='submit.jsp'>
			<a href="suppress.jsp?fragment=${param.fragment}&tgrep=${param.pattern}">Suppress</a>
			| <a href="defer.jsp?fragment=${param.fragment}&tgrep=${param.pattern}">Defer</a>
            | <a href="complete.jsp?fragment=${param.fragment}&tgrep=${param.pattern}">Completed</a>
			| <button type="submit" name="action" value="submit">Submit</button>
			| <button type="submit" name="action" value="return">Submit&Return</button>
			| tgrep: <input type="text" id="tgrep" name="tgrep" size="100" value="">
			<input type="hidden" name="pattern" value="${param.pattern}">
            <input type="hidden" name="fragment" value="${param.fragment}">
			</div>
			
			<div id=mode style=" float:left; width:100px">
			<h4>Mode</h4>
               <sql:query var="modes" dataSource="jdbc/covid">
                    select mode
                    from covid_biorxiv.template_mode
                   order by seq;
                </sql:query>
                <c:forEach items="${modes.rows}" var="row" varStatus="rowCounter">
                    <input id="mode_${row.mode}" name=mode type="radio" value="${row.mode}" <c:if test="${row.mode == 'instantiate' || row.mode == 'promote'}">onclick="reset_relation();reset_slot0();reset_slot1();"</c:if> >${row.mode}<br>
                </c:forEach>
			</div>
            <div id=relation style=" float:left; width:150px">
            <h4>Relation</h4>
               <sql:query var="modes" dataSource="jdbc/covid">
                    select relation
                    from covid_biorxiv.template_relation
                    order by seq;
                </sql:query>
                <c:forEach items="${modes.rows}" var="row" varStatus="rowCounter">
                    <c:if test="${rowCounter.index != 0 && rowCounter.index % 9 == 0}">
                        </div><div id=relation style=" float:left; width:180px"><h4>Relation, con't.</h4>
                    </c:if>
                    <input id="relation_${row.relation}" name=relation type="radio" value="${row.relation}">${row.relation}<br>
                </c:forEach>
             </div>
            <div id=slot0 style=" float:left; width:150px">
            <h4>Slot 0</h4>
                <sql:query var="modes" dataSource="jdbc/covid">
                   select relation
                    from covid_biorxiv.template_relation
                    order by seq;
                </sql:query>
                <c:forEach items="${modes.rows}" var="row" varStatus="rowCounter">
                    <input id="slot0_${row.relation}_id" name=slot0 type="radio" value="${row.relaton}_id">${row.relation}_id<br>
                </c:forEach>
            </div>
            <div id=slot1 style=" float:left; width:150px">
            <h4>Slot 1</h4>
                 <sql:query var="modes" dataSource="jdbc/covid">
                   select relation
                    from covid_biorxiv.template_relation
                    order by seq;
                </sql:query>
                <c:forEach items="${modes.rows}" var="row" varStatus="rowCounter">
                    <input id="slot1_${row.relation}_id" name=slot1 type="radio" value="${row.relaton}_id">${row.relation}_id<br>
                </c:forEach>
            </div>
            <div id=samples style=" float:left; width:100%">
            <h4>Highest Frequency Text Fragments</h4>
            <table>
                <tr>
                    <th>Frequency</th>
                    <th>Fragment</th>
                </tr>
                <sql:query var="fragments" dataSource="jdbc/covid">
                    select node,count(*) as frequency
                    from covid_biorxiv.fragment
                    where fragment = ?
                    group by 1
                    order by 2 desc limit 10;
                    <sql:param>${param.fragment}</sql:param>
                </sql:query>
                <c:forEach items="${fragments.rows}" var="row" varStatus="rowCounter">
                    <tr>
                        <td align=right>${row.frequency}</td>
                        <td>${row.node}</td>
                    </tr>
                </c:forEach>
            </table>

			<c:choose>
				<c:when	test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Organization ]')}">
					<script type="text/javascript">
						document.getElementById("mode_instantiate").checked = true;
						document.getElementById("relation_organization").checked = true;
						autoset = false;
					</script>
				</c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Person ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_person").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Grant ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_award").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Resource ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_resource").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Discipline ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_discipline").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Collaboration ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_collaboration").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Event ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_event").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Place ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_location").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'PlaceName ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_location").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Support ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_support").checked = true;
                        autoset = false;
                    </script>
                </c:when>
                <c:when test="${fn:indexOf(fn:substringAfter(param.fragment, '['),'[') < 0 && fn:endsWith(param.fragment, 'Technique ]')}">
                    <script type="text/javascript">
                        document.getElementById("mode_instantiate").checked = true;
                        document.getElementById("relation_technique").checked = true;
                        autoset = false;
                    </script>
                </c:when>
			</c:choose>
            <jsp:include page="/footer.jsp" flush="true" />
        </div>
    </div>
</body>
</html>
