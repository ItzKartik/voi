<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.GetWebSuiteOrderResponse"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin"%>
<%@page import="com.kunshi.interfacef.vosweb.WebQuery"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  GetWebSuiteOrderResponse webResponse = new GetWebSuiteOrderResponse();
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (null == info) {
    webResponse.retCode = RetCodeValue.W_ERROR_FAILED;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  WebQuery webQuery = new WebQuery();
  webQuery.customerId = info.customerId;
  webQuery.customerTimeZone = info.customerTimeZone;
  webResponse = (GetWebSuiteOrderResponse) MGCConfig.listenerWebServer().sendRequestSyn(WebBodyId.VOS_WEB_GETWEBINFOSUITEORDER_REQ, webQuery, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (webResponse == null) {
    webResponse = new GetWebSuiteOrderResponse();
    webResponse.retCode = RetCodeValue.F_ERROR_TIMEOUT;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
  response.getWriter().write(JsonUtil.toJson(webResponse));
  out.clear();
%>
