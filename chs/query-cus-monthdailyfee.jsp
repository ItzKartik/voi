<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.FilterWebReport"%>
<%@page import="com.kunshi.interfacef.vosweb.GetWebDailyFeeResponse"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  GetWebDailyFeeResponse webResponse = new GetWebDailyFeeResponse();
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (null == info) {
    webResponse.retCode = RetCodeValue.W_ERROR_FAILED;
    webResponse.exception = ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), webResponse.retCode);
    response.getWriter().write(JsonUtil.toJson(webResponse));
    out.clear();
    return;
  }
  FilterWebReport filter = new FilterWebReport();
  filter.customerAccount = info.customerAccount;
  filter.startTime = request.getParameter("startTime");
  filter.stopTime = request.getParameter("stopTime");
  filter.customerType = info.terminalType;
  filter.customerTimeZone = info.customerTimeZone;
  webResponse = (GetWebDailyFeeResponse) MGCConfig.listenerWebServer().sendRequestSyn(WebBodyId.VOS_WEB_MONTHDAILYFEE_REQ, filter,
      MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (webResponse == null) {
    webResponse = new GetWebDailyFeeResponse();
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
