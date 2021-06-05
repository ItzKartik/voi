<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.*"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  String randCode = null;
  if (session != null) {
    randCode = (String) session.getAttribute("randCode");
    session.removeAttribute("randCode");
  }
  String code = request.getParameter("randCode");
  WebPayByPhoneCardResponse responseVos = new WebPayByPhoneCardResponse();
  if (randCode == null || !randCode.equals(code)) {
    responseVos.retCode = RetCodeValue.W_ERROR_VERIFYCODE;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (info == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_FAILED;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  WebPayByPhoneCard requestVos = (WebPayByPhoneCard) JsonUtil.fromJson(request.getReader(), WebPayByPhoneCard.class);
  requestVos.account = info.customerAccount;
  requestVos.pin = requestVos.pin.trim();
  requestVos.loginName = info.terminalName;
  requestVos.fromIp = request.getRemoteAddr();
  responseVos = (WebPayByPhoneCardResponse) MGCConfig.listenerEquipment().sendRequestSyn(
      WebBodyId.VOS_WEB_SETINFOPAYBYPHONECARD_REQ, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (responseVos == null) {
    responseVos = new WebPayByPhoneCardResponse();
    responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
  }
  responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
  response.getWriter().write(JsonUtil.toJson(responseVos));
  out.clear();
%>
