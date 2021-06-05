<%@page contentType="text/html; charset=utf-8" %>
<%@page import="com.kunshi.interfacef.common.RetCodeValue" %>
<%@page import="com.kunshi.interfacef.common.RspGetInfo" %>
<%@page import="com.kunshi.interfacef.vosweb.VosWebTypes" %>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId" %>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoCallbackPhonebook" %>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin" %>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue" %>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage" %>
<%@page import="com.kunshi.vos.clientweb.MGCConfig" %>
<%@page import="java.util.Vector" %>
<%
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", -1);
    WebInfoTerminalLogin sessionInfo = (WebInfoTerminalLogin) session.getAttribute("Info");
    if(sessionInfo == null)
    {
        response.getWriter().write(RetCodeValue.W_ERROR_FAILED + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_FAILED));
        return;
    }
    WebInfoCallbackPhonebook info = new WebInfoCallbackPhonebook();
    info.caller = request.getParameter("caller");
    if(info.caller == null || info.caller.trim().isEmpty())
    {
        response.getWriter().write(RetCodeValue.F_ERROR_CALLERE164NOTEXIST + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.F_ERROR_CALLERE164NOTEXIST));
        return;
    }
    Vector<String> vec = new Vector<String>();
    for(String e164 : request.getParameter("callees").split(","))
    {
        if(e164.trim().length() > 0)
        {
            vec.add(e164);
        }
    }
    if(vec.size() == 0)
    {
        response.getWriter().write(RetCodeValue.F_ERROR_CALLEEE164NOTEXIST + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.F_ERROR_CALLEEE164NOTEXIST));
        return;
    }
    info.callees = vec;
    if(sessionInfo.terminalType == VosWebTypes.LoginType.PHONE)
    {
        info.type = VosWebTypes.BillingMode.BILLING_PHONE;
    }
    else if(sessionInfo.terminalType == VosWebTypes.LoginType.BINDEDE164)
    {
        info.type = VosWebTypes.BillingMode.BILLING_BINDEDE164;
    }
    else if(sessionInfo.terminalType == VosWebTypes.LoginType.PHONECARD)
    {
        info.type = VosWebTypes.BillingMode.BILLING_PIN;
    }
    info.billingNumber = sessionInfo.terminalName;
    RspGetInfo rsp = (RspGetInfo) MGCConfig.listenerEquipment().sendRequestSyn(WebBodyId.VOS_WEB_CALLBACKPHONEBOOK_REQ, info, MGCAPIPublicValue.FM_WEB_TIMEOUT);
    if(rsp == null)
    {
        response.getWriter().write(RetCodeValue.W_ERROR_TIMEOUT + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_TIMEOUT));
        return;
    }
    if(rsp.retCode != RetCodeValue.F_OK)
    {
        response.getWriter().write(rsp.retCode + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), rsp.retCode));
        return;
    }
    response.getWriter().write(RetCodeValue.F_OK + "|");
%>
