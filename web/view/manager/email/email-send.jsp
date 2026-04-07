<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<c:set var="formAction" value="${pageContext.request.contextPath}/manager/email/send" scope="request"/>
<c:set var="backUrl" value="${pageContext.request.contextPath}/manager/email" scope="request"/>
<c:set var="templateApiUrl" value="${pageContext.request.contextPath}/manager/email-data?action=templateDetail" scope="request"/>
<jsp:include page="/view/common/email-send-form.jsp"/>

<c:if test="${not empty retryLog}">
<textarea id="retryBodyHtml" class="d-none"><c:out value="${retryLog.bodyHtml}" escapeXml="true"/></textarea>
<script>
document.addEventListener('DOMContentLoaded', function() {
    // Pre-fill subject
    var subjectInput = document.getElementById('inputSubject');
    if (subjectInput) subjectInput.value = '<c:out value="${retryLog.subject}" escapeXml="true"/>'.replace(/&amp;/g,'&').replace(/&lt;/g,'<').replace(/&gt;/g,'>').replace(/&#034;/g,'"').replace(/&#039;/g,"'");

    // Pre-fill body in manual mode (decode HTML entities)
    var manualBody = document.getElementById('manualBody');
    var retryArea = document.getElementById('retryBodyHtml');
    if (manualBody && retryArea) {
        // The textarea auto-decodes HTML entities
        manualBody.value = retryArea.value;
    }

    // Add the recipient
    var retryEmail = '<c:out value="${retryLog.toEmail}" escapeXml="true"/>';
    var retryName = '<c:out value="${retryLog.toName}" escapeXml="true"/>';
    if (retryEmail) {
        var emailInput = document.getElementById('manualEmail');
        var nameInput = document.getElementById('manualName');
        if (emailInput && nameInput) {
            emailInput.value = retryEmail;
            nameInput.value = retryName || '';
            // Trigger the add manual recipient function
            if (typeof addManualRecipient === 'function') {
                addManualRecipient();
            }
        }
    }
});
</script>
</c:if>
