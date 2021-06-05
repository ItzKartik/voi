<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.common.RspGetInfo"%>
<%@page import="com.kunshi.interfacef.vosweb.FilterWebInfoCustomer"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoCustomer"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoTerminalLogin"%>
<%@page import="com.kunshi.platform.mgc.mgcapi.MGCAPIPublicValue"%>
<%@page import="com.kunshi.vos.clientweb.ShowErrorMessage"%>
<%@page import="com.kunshi.vos.clientweb.MGCConfig"%>
<%
  response.setHeader("Pragma", "no-cache");
  response.setDateHeader("Expires", -1);
  HttpSession session = request.getSession(false);
  WebInfoTerminalLogin info = session == null ? null : (WebInfoTerminalLogin) session.getAttribute("Info");
  if (null == info) {
    response.getWriter().write(RetCodeValue.W_ERROR_FAILED + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_FAILED));
    return;
  }
  FilterWebInfoCustomer filter = new FilterWebInfoCustomer();
  filter.info.account = info.customerAccount;
  RspGetInfo rsp = (RspGetInfo) MGCConfig.listenerEquipment().sendRequestSyn(WebBodyId.VOS_WEB_GETINFOCUSTOMER_REQ, filter, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (rsp == null) {
    response.getWriter().write(RetCodeValue.W_ERROR_TIMEOUT + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_TIMEOUT));
    return;
  }
  if (rsp.retCode != RetCodeValue.F_OK) {
    response.getWriter().write(rsp.retCode + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), rsp.retCode));
    return;
  }
  WebInfoCustomer infoCustomer = (WebInfoCustomer) rsp.retInfo;
  response.getWriter().write(RetCodeValue.F_OK + "|");
  response.getWriter().write(infoCustomer.linkMan + "|");
  response.getWriter().write(infoCustomer.phone + "|");
  response.getWriter().write(infoCustomer.idType + "|");
  response.getWriter().write(infoCustomer.idNumber + "|");
  response.getWriter().write(infoCustomer.fax + "|");
  response.getWriter().write(infoCustomer.email + "|");
  response.getWriter().write(infoCustomer.postCode + "|");
  response.getWriter().write(infoCustomer.address + "|");
%>
