<%@page contentType="text/html; charset=utf-8"%>
<%@page session="false"%>
<%@page import="com.kunshi.interfacef.common.RetCodeValue"%>
<%@page import="com.kunshi.interfacef.common.RspGetInfo"%>
<%@page import="com.kunshi.interfacef.vosweb.FilterWebInfoPhone"%>
<%@page import="com.kunshi.interfacef.vosweb.WebBodyId"%>
<%@page import="com.kunshi.interfacef.vosweb.WebInfoPhone"%>
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
  FilterWebInfoPhone filter = new FilterWebInfoPhone();
  filter.info.e164 = info.terminalName;
  RspGetInfo rsp = (RspGetInfo) MGCConfig.listenerEquipment().sendRequestSyn(WebBodyId.VOS_WEB_GETINFOPHONE_REQ, filter, MGCAPIPublicValue.FM_WEB_TIMEOUT);
  if (rsp == null) {
    response.getWriter().write(RetCodeValue.W_ERROR_TIMEOUT + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), RetCodeValue.W_ERROR_TIMEOUT));
    return;
  }
  if (rsp.retCode != RetCodeValue.F_OK) {
    response.getWriter().write(rsp.retCode + "|" + ShowErrorMessage.showErrorMessageByRetcode(request.getRequestURI(), rsp.retCode));
    return;
  }
  WebInfoPhone infoPhone = (WebInfoPhone) rsp.retInfo;
  response.getWriter().write(RetCodeValue.F_OK + "|");
  response.getWriter().write(infoPhone.bitsOfOpen + "|");
  response.getWriter().write(infoPhone.callForwordBusyNum + "|");
  response.getWriter().write(infoPhone.callForwordAlwaysNum + "|");
  response.getWriter().write(infoPhone.callForwordNoReplyNum + "|");
  response.getWriter().write((infoPhone.bitsOfOpen & WebInfoPhone.MASK_CFTUOPEN) + "|");
  response.getWriter().write((infoPhone.bitsOfOpen & WebInfoPhone.MASK_CFTUENABLE) + "|");
  response.getWriter().write(infoPhone.remoteAlertingPassthrough + "|");
  response.getWriter().write(infoPhone.indicationCallFailed + "|");
  response.getWriter().write(infoPhone.indicationCallRemainTime + "|");
  response.getWriter().write(infoPhone.accountIndicationMethod + "|");
  response.getWriter().write(infoPhone.valueAddedService + "|");
  response.getWriter().write(infoPhone.localAlertingSound + "|");
%>
