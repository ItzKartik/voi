<%@page contentType="text/html; charset=utf-8" %>
<%@page session="false" %>
<%@page import="com.kunshi.interfacef.common.RetCodeValue" %>
<%@page import="com.kunshi.interfaceo.vos.ExternalBodyId" %>
<%@page import="com.kunshi.interfaceo.vos.external.server.ModifyCustomerPhoneBook" %>
<%@page import="com.kunshi.interfaceo.vos.external.server.ModifyCustomerPhoneBookResponse" %>
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
        ModifyCustomerPhoneBook requestVos = (ModifyCustomerPhoneBook) JsonUtil.fromJson(request.getReader(), ModifyCustomerPhoneBook.class);
        if(requestVos == null)
        {
            return;
        }
        requestVos.fromIp=request.getRemoteAddr();
        ModifyCustomerPhoneBookResponse responseVos = new ModifyCustomerPhoneBookResponse();
        responseVos = (ModifyCustomerPhoneBookResponse) MGCConfig.listenerEquipment().sendRequestSyn(
                ExternalBodyId.MODIFY_CUSTOMER_PHONE_BOOK, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
        if(responseVos == null)
        {
            responseVos = new ModifyCustomerPhoneBookResponse();
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
