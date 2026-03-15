<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="formAction" value="${pageContext.request.contextPath}/support/email/send"/>
<c:set var="backUrl" value="${pageContext.request.contextPath}/support/dashboard"/>
<c:set var="templateApiUrl" value="${pageContext.request.contextPath}/support/email/send?action=templateDetail"/>
<jsp:include page="/view/common/email-send-form.jsp"/>
