<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.vosweb.GetWebPayHistoryResponse"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin"%>
<%@page import="com.kunshi.interfacef.vosweb.WebQuery"%>
<%@page import="com.kunshi.platform.common.CommonAlgorithm"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%@page import="com.kunshi.vos.common.JsonUtil"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  GetWebPayHistoryResponse webResponse = new GetWebPayHistoryResponse();
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
  webQuery.terminalName = info.terminalName;
  webQuery.terminalType = info.terminalType;
  webQuery.customerAccount = info.customerAccount;
  webQuery.customerTimeZone = info.customerTimeZone;
  webQuery.type = WebQuery.QUERY_TYPE_CUSTOMER;
  int start = CommonAlgorithm.stringToInt(request.getParameter("start"));
  int limit = CommonAlgorithm.stringToInt(request.getParameter("limit"));
  webQuery.pageIndex = (start + limit) / 100;
  webQuery.startTime = request.getParameter("startTime");
  webQuery.stopTime = request.getParameter("stopTime");
  webResponse = (GetWebPayHistoryResponse) MGCConfig.listenerWebServer().sendRequestSyn(WebBodyId.VOS_WEB_GETWEBINFOPAYHISTORY_REQ, webQuery, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (webResponse == null) {
    webResponse = new GetWebPayHistoryResponse();
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
