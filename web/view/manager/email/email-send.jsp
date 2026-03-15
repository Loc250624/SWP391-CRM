<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="formAction" value="${pageContext.request.contextPath}/manager/email/send"/>
<c:set var="backUrl" value="${pageContext.request.contextPath}/manager/email"/>
<c:set var="templateApiUrl" value="${pageContext.request.contextPath}/manager/email-data?action=templateDetail"/>
<jsp:include page="/view/common/email-send-form.jsp"/>
