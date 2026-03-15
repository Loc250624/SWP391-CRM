<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="formAction" value="${pageContext.request.contextPath}/sale/email/send" scope="request"/>
<c:set var="backUrl" value="${pageContext.request.contextPath}/sale/dashboard" scope="request"/>
<c:set var="templateApiUrl" value="${pageContext.request.contextPath}/sale/email/send?action=templateDetail" scope="request"/>
<c:set var="showRelated" value="${true}" scope="request"/>
<jsp:include page="/view/common/email-send-form.jsp"/>
