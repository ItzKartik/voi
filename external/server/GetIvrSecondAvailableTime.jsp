<%@page contentType="text/html; charset=utf-8" %>
<%@page session="false" %>
<%@page import="com.kunshi.interfacef.common.RetCodeValue" %>
<%@page import="com.kunshi.interfaceo.vos.ExternalBodyId" %>
<%@page import="com.kunshi.interfaceo.vos.external.server.GetIvrSecondAvailableTime" %>
<%@page import="com.kunshi.interfaceo.vos.external.server.GetIvrSecondAvailableTimeResponse" %>
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
        GetIvrSecondAvailableTime requestVos = (GetIvrSecondAvailableTime) JsonUtil.fromJson(request.getReader(), GetIvrSecondAvailableTime.class);
        if(requestVos == null)
        {
            return;
        }
        GetIvrSecondAvailableTimeResponse responseVos = new GetIvrSecondAvailableTimeResponse();
        responseVos = (GetIvrSecondAvailableTimeResponse) MGCConfig.listenerEquipment().sendRequestSyn(
                ExternalBodyId.GET_IVR_SECOND_AVAILABLE_TIME, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
        if(responseVos == null)
        {
            responseVos = new GetIvrSecondAvailableTimeResponse();
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
