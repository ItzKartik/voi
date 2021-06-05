<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.*"%>
<%@page import="com.kunshi.interfacef.vosweb.*"%>
<%@page import="com.kunshi.platform.common.CommonAlgorithm"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  HttpSession session = request.getSession(false);
  String randCode = null;
  if (session != null) {
    randCode = (String) session.getAttribute("randCode");
    session.removeAttribute("randCode");
  }
  String code = request.getParameter("randCode");
  WebLoginResponse responseVos = new WebLoginResponse();
  if (randCode == null || !randCode.equals(code)) {
    responseVos.retCode = RetCodeValue.W_ERROR_VERIFYCODE;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  WebLogin requestVos = (WebLogin) JsonUtil.fromJson(request.getReader(), WebLogin.class);
  if (requestVos == null) {
    responseVos.retCode = RetCodeValue.W_ERROR_MISSPARAMETER;
    responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
    response.getWriter().write(JsonUtil.toJson(responseVos));
    out.clear();
    return;
  }
  responseVos = (WebLoginResponse) MGCConfig.listenerWebServer().sendRequestSyn(
      WebBodyId.VOS_WEB_CHECKPASSWORD_REQ, JsonUtil.toJson(requestVos), responseVos, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (responseVos == null) {
    responseVos = new WebLoginResponse();
    responseVos.retCode = RetCodeValue.F_ERROR_TIMEOUT;
  }
  if (responseVos.retCode == RetCodeValue.F_OK) {
    session.setAttribute("Info", responseVos.webInfoTerminalLogin);
  }
  responseVos.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), responseVos.retCode);
  responseVos.webInfoTerminalLogin = null;
  response.getWriter().write(JsonUtil.toJson(responseVos));
%>
