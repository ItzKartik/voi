<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.common.RspGetInfo"%>
<%@page import="com.kunshi.interfacef.vosweb.FilterWebReport"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (info == null) {
    response.getWriter().write(RetCodeValue.W_ERROR_FAILED + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_FAILED));
    return;
  }
  FilterWebReport filter = new FilterWebReport();
  filter.customerAccount = info.customerAccount;
  filter.customerType = info.terminalType;
  filter.startTime = request.getParameter("startTime");
  filter.stopTime = request.getParameter("stopTime");
  filter.customerTimeZone = info.customerTimeZone;
  filter.language = request.getRequestURI().contains("chs") ? "zh_cn" : request.getRequestURI().contains("cht") ? "zh_tw" : "en_us";
  RspGetInfo rsp = (RspGetInfo) MGCConfig.listenerWebServer().sendRequestSyn(WebBodyId.VOS_WEB_REPORT_REQ, filter, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (rsp == null) {
    response.getWriter().write(RetCodeValue.W_ERROR_TIMEOUT + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_TIMEOUT));
    return;
  }
  if (rsp.retCode != RetCodeValue.F_OK) {
    response.getWriter().write(rsp.retCode + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), rsp.retCode));
    return;
  }
  response.getWriter().write(rsp.retCode + "|" + rsp.retInfo);
%>
