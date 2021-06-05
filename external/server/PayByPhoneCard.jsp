<%@page contentType="text/html; charset=utf-8" %>
<%@page session="false" %>
<%@page import="com.kunshi.interfacef.common.RetCodeValue" %>
<%@page import="com.kunshi.interfaceo.vos.ExternalBodyId" %>
<%@page import="com.kunshi.interfaceo.vos.external.server.PayByPhoneCard" %>
<%@page import="com.kunshi.interfaceo.vos.external.server.PayByPhoneCardResponse" %>
<%@page import="com.kunshi.platform.common.Trace" %>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue" %>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage" %>
<%@page import="com.kunshi.vos.clientweb.MGCConfig" %>
<%@page import="com.kunshi.vos.common.JsonUtil" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", -1);
    try
    {
        PayByPhoneCard requestVos = (PayByPhoneCard) JsonUtil.fromJson(request.getReader(), PayByPhoneCard.class);
        if(requestVos == null)
        {
            return;
        }
        requestVos.fromIp=request.getRemoteAddr();
        PayByPhoneCardResponse responseVos = new PayByPhoneCardResponse();
        responseVos = (PayByPhoneCardResponse) MGCConfig.listenerEquipment().sendRequestSyn(
                ExternalBodyId.PAY_BY_PHONE_CARD, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
        if(responseVos == null)
        {
            responseVos = new PayByPhoneCardResponse();
            responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
        }
        responseVos.exception = ShowErrorMessage.exceptionValue(responseVos.retCode);
        response.getWriter().write(JsonUtil.toJson(responseVos));
        out.clear();
    }
    catch(Exception e1)
    {
        Trace.println(e1);
    }
%>
