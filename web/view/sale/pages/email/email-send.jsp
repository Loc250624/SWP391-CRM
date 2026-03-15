<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="formAction" value="${pageContext.request.contextPath}/sale/email/send"/>
<c:set var="backUrl" value="${pageContext.request.contextPath}/sale/dashboard"/>
<c:set var="templateApiUrl" value="${pageContext.request.contextPath}/sale/email/send?action=templateDetail"/>
<c:set var="showRelated" value="${true}"/>
<jsp:include page="/view/common/email-send-form.jsp"/>
