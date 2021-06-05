<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.platform.common.CommonAlgorithm"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.clientweb.Util"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebGetPhoneBookResponse responseVos = new WebGetPhoneBookResponse();
  WebInfoTerminalLogin sessionInfo = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (sessionInfo == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  FilterWebInfoPhonebook requestVos = new FilterWebInfoPhonebook();
  String parameter = request.getParameter("name");
  if (parameter != null && parameter.trim().length() > 0) {
    requestVos.name = parameter.trim();
  }
  parameter = request.getParameter("e164");
  if (parameter != null && parameter.trim().length() > 0) {
    requestVos.e164 = parameter;
  }
  parameter = request.getParameter("phonebookType");
  if (parameter != null) {
    requestVos.phonebookType = CommonAlgorithm.stringToInt(parameter, 0);
  }
  if (requestVos.phonebookType == 0) {
    responseVos.retCode = RetCodeValue.W_ERROR_MISSPARAMETER;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  Util.copyLoginInfo(request, sessionInfo, requestVos);
  responseVos = (WebGetPhoneBookResponse) MGCConfig.listenerEquipment().sendRequestSyn(
      WebBodyId.VOS_WEB_GETINFOPHONEBOOK_REQ, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (responseVos == null) {
    responseVos = new WebGetPhoneBookResponse();
    responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
  }
  responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
  response.getWriter().write(JsonUtil.toJson(responseVos));
  out.clear();
%>
