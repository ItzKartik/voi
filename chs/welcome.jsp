<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.*"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%@page import="java.text.DecimalFormat"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin sessionInfo = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  WebLoginResponse responseVos = new WebLoginResponse();
  if (sessionInfo == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  String noReload = request.getParameter("noReload");
  responseVos.retCode = RetCodeValue.F_OK;
  if (noReload == null) {
    WebLogin requestVos = new WebLogin();
    requestVos.terminalName = sessionInfo.terminalName;
    requestVos.terminalPassword = sessionInfo.terminalPassword;
    requestVos.terminalType = sessionInfo.terminalType;
    responseVos = (WebLoginResponse) MGCConfig.listenerWebServer().sendRequestSyn(
        WebBodyId.VOS_WEB_CHECKPASSWORD_REQ, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
    if (responseVos == null) {
      responseVos = new WebLoginResponse();
      responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    }
    if (responseVos.retCode == RetCodeValue.F_OK) {
      session.setAttribute("Info", responseVos.webInfoTerminalLogin);
    }
  }
  if (responseVos.retCode != RetCodeValue.F_OK) {
    responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  responseVos.webInfoTerminalLogin = new WebInfoTerminalLogin();
  responseVos.webInfoTerminalLogin.terminalName = sessionInfo.terminalName;
  responseVos.webInfoTerminalLogin.terminalType = sessionInfo.terminalType;
  responseVos.webInfoTerminalLogin.customerAccount = sessionInfo.customerAccount;
  responseVos.webInfoTerminalLogin.customerName = sessionInfo.customerName;
  responseVos.webInfoTerminalLogin.customerMoney = sessionInfo.customerMoney;
  responseVos.webInfoTerminalLogin.limitMoney = sessionInfo.limitMoney;
  responseVos.webInfoTerminalLogin.isCustomerPassword = sessionInfo.isCustomerPassword;
  response.getWriter().write(JsonUtil.toJson(responseVos));
%>
