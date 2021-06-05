<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.*"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.clientweb.Util"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin sessionInfo = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  ResponseCommon responseVos = new ResponseCommon();
  if (sessionInfo == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  WebSetTermininalPassword requestVos = (WebSetTermininalPassword) JsonUtil.fromJson(request.getReader(), WebSetTermininalPassword.class);
  if (requestVos == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_MISSPARAMETER;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  Util.copyLoginInfo(request, sessionInfo, requestVos);
  sessionInfo.terminalPassword = sessionInfo.terminalPassword == null ? "" : sessionInfo.terminalPassword;
  if (sessionInfo.isCustomerPassword && !sessionInfo.terminalPassword.equals(requestVos.oldPassword)) {
    responseVos.retCode = RetCodeValue.F_ERROR_PASSWORD;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  if (sessionInfo.isCustomerPassword) {
    requestVos.password = null;
  }
  responseVos = (ResponseCommon) MGCConfig.listenerEquipment().sendRequestSyn(
      WebBodyId.SET_TERMINAL_PASSWORD, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (responseVos == null) {
    responseVos = new ResponseCommon();
    responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
  }
  if (responseVos.retCode == RetCodeValue.F_OK) {
    session.removeAttribute("Info");
    sessionInfo.terminalPassword = sessionInfo.isCustomerPassword ? requestVos.customerPassword : requestVos.password;
    session.setAttribute("Info", sessionInfo);
  }
  responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
  response.getWriter().write(JsonUtil.toJson(responseVos));
  out.clear();
%>
